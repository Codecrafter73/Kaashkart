import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationUtil {
  static const _cacheKey = "cached_location_data";

  /// Get location and address (uses cache if available)
  static Future<Map<String, dynamic>?> getCurrentLocationWithAddress({
    bool promptUserIfDisabled = true,
    bool useCache = true,
  }) async {
    try {
      // ✅ Step 1: Check cache first
      if (useCache) {
        final cached = await _getCachedLocation();
        if (cached != null) {
          if (kDebugMode) print("📍 Using cached location");
          return cached;
        }
      }

      // Step 2: Check if GPS is ON
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (promptUserIfDisabled) {
          await Geolocator.openLocationSettings();
          await Future.delayed(const Duration(seconds: 2));
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
        }
        if (!serviceEnabled) return null;
      }

      // Step 3: Permission handling
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return null;
      }

      // Step 4: Try last known position
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null && _isRecent(lastPosition)) {
        final address = await _getAddressFromPosition(lastPosition);
        final data = {"position": lastPosition, "address": address};
        await _saveCachedLocation(data);
        return data;
      }

      // Step 5: Get fresh position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final address = await _getAddressFromPosition(position);
      final data = {"position": position, "address": address};

      // ✅ Save to cache
      await _saveCachedLocation(data);

      return data;
    } catch (e) {
      if (kDebugMode) print("❌ Location error: $e");
      return null;
    }
  }

  /// Converts coordinates into address
  static Future<Map<String, dynamic>> _getAddressFromPosition(Position pos) async {
    try {
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final addressMap = {
          "street": p.street,
          "subLocality": p.subLocality,
          "locality": p.locality,
          "postalCode": p.postalCode,
          "administrativeArea": p.administrativeArea,
          "country": p.country,
          "latitude": pos.latitude,
          "longitude": pos.longitude,
          "formattedAddress": [
            p.street,
            p.subLocality,
            p.locality,
            p.postalCode,
            // p.administrativeArea,
          ].where((e) => e != null && e.isNotEmpty).join(', '),
        };
        return addressMap;
      }
    } catch (e) {
      if (kDebugMode) print("⚠️ Reverse geocoding failed: $e");
    }
    return {
      "formattedAddress": "Unknown location",
      "latitude": pos.latitude,
      "longitude": pos.longitude,
    };
  }

  /// Cache handling
  static Future<void> _saveCachedLocation(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode({
      "latitude": data["position"].latitude,
      "longitude": data["position"].longitude,
      "address": data["address"],
      "timestamp": DateTime.now().toIso8601String(),
    });
    await prefs.setString(_cacheKey, jsonData);
  }

  static Future<Map<String, dynamic>?> _getCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString == null) return null;

    final data = jsonDecode(jsonString);
    final timestamp = DateTime.parse(data["timestamp"]);

    // Cache validity (30 mins)
    if (DateTime.now().difference(timestamp).inMinutes > 10) {
      return null;
    }

    final position = Position(
      latitude: data["latitude"],
      longitude: data["longitude"],
      timestamp: timestamp,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0, // ✅ added
      headingAccuracy: 0,  // ✅ added
    );


    return {"position": position, "address": data["address"]};
  }

  static bool _isRecent(Position pos) {
    final t = pos.timestamp ?? DateTime.now().subtract(const Duration(minutes: 5));
    return DateTime.now().difference(t).inSeconds <= 15;
  }
}
