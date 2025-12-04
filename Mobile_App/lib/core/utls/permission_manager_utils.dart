import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'custom_snack_bar.dart';
import 'responsive_helper_utils.dart';


/// Permission Manager for Android & iOS (All Versions)
///
/// Supports:
/// - Android 5.0 to Android 14+ (API 21 to 34+)
/// - iOS 12.0 to iOS 17+
///
/// SETUP REQUIRED - See instructions at bottom of file
class PermissionManager {

  /// Request Photos/Media Permission (Smart version detection)
  ///
  /// Automatically handles:
  /// - Android 13+ (API 33+): READ_MEDIA_IMAGES
  /// - Android 11-12 (API 30-32): READ_EXTERNAL_STORAGE
  /// - Android 10 and below: READ_EXTERNAL_STORAGE
  /// - iOS: Photo Library access
  static Future<bool> requestPhotosPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      return await _requestAndroidPhotosPermission(context);
    } else if (Platform.isIOS) {
      return await _requestIOSPhotosPermission(context);
    }
    return false;
  }

  /// Request Photos AND Videos Permission (Combined)
  /// Use this when you want to pick both photos and videos
  static Future<bool> requestPhotosAndVideosPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      // Android 13+ needs both photos and videos permission
      if (androidVersion >= 33) {
        final photosGranted = await _requestAndroidPhotosPermission(context);
        final videosGranted = await _requestAndroidVideoPermission(context);
        return photosGranted && videosGranted;
      }
      // Android 12 and below - storage permission covers both
      else {
        return await _requestAndroidStoragePermission(context);
      }
    } else if (Platform.isIOS) {
      // iOS - photo library permission covers both photos and videos
      return await _requestIOSPhotosPermission(context);
    }
    return false;
  }

  /// Request Storage Permission for documents/files
  static Future<bool> requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      return await _requestAndroidStoragePermission(context);
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit storage permission for file picker
      return true;
    }
    return false;
  }

  /// Request Video Permission
  static Future<bool> requestVideoPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      return await _requestAndroidVideoPermission(context);
    } else if (Platform.isIOS) {
      return await _requestIOSPhotosPermission(context);
    }
    return false;
  }

  /// Request Audio/Music Permission
  static Future<bool> requestAudioPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      return await _requestAndroidAudioPermission(context);
    } else if (Platform.isIOS) {
      return await _requestIOSMediaLibraryPermission(context);
    }
    return false;
  }

  /// Request Camera Permission
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      await _showPermissionDialog(
        context,
        title: 'Camera Permission Required',
        message: 'To capture photos, we need access to your camera. Please grant the permission.',
      );

      final newStatus = await Permission.camera.request();
      if (newStatus.isGranted) {
        return true;
      } else if (newStatus.isPermanentlyDenied) {
        await _showSettingsDialog(context);
      }
    } else if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context);
    } else {
      final newStatus = await Permission.camera.request();
      return newStatus.isGranted;
    }
    return false;
  }

  /// Request Microphone Permission
  static Future<bool> requestMicrophonePermission(BuildContext context) async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      await _showPermissionDialog(
        context,
        title: 'Microphone Permission Required',
        message: 'To record audio, we need access to your microphone. Please grant the permission.',
      );

      final newStatus = await Permission.microphone.request();
      if (newStatus.isGranted) {
        return true;
      } else if (newStatus.isPermanentlyDenied) {
        await _showSettingsDialog(context);
      }
    } else if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context);
    } else {
      final newStatus = await Permission.microphone.request();
      return newStatus.isGranted;
    }
    return false;
  }

  // ==================== ANDROID SPECIFIC ====================

  /// Android Photos Permission (Version-aware)
  static Future<bool> _requestAndroidPhotosPermission(BuildContext context) async {
    final androidVersion = await _getAndroidVersion();

    Permission permission;
    String permissionName;

    // Android 13+ (API 33+)
    if (androidVersion >= 33) {
      permission = Permission.photos;
      permissionName = 'Photos';
    }
    // Android 6.0 to 12 (API 23-32)
    else {
      permission = Permission.storage;
      permissionName = 'Storage';
    }

    return await _handlePermission(
      context,
      permission,
      title: '$permissionName Permission Required',
      message: 'To access photos, we need $permissionName permission. Please grant the permission.',
    );
  }

  /// Android Storage Permission (Version-aware)
  static Future<bool> _requestAndroidStoragePermission(BuildContext context) async {
    final androidVersion = await _getAndroidVersion();

    Permission permission;
    String permissionName;

    // Android 11+ (API 30+) - For accessing all files
    if (androidVersion >= 30) {
      permission = Permission.manageExternalStorage;
      permissionName = 'File Access';

      // Check if we can request this permission
      final status = await permission.status;
      if (status.isDenied) {
        await _showPermissionDialog(
          context,
          title: '$permissionName Permission Required',
          message: 'To access files, we need permission. You may need to enable "All files access" in settings.',
        );

        // This will open settings directly for MANAGE_EXTERNAL_STORAGE
        final granted = await openAppSettings();
        return granted;
      }
      return status.isGranted;
    }
    // Android 10 and below (API 29 and below)
    else {
      permission = Permission.storage;
      permissionName = 'Storage';
    }

    return await _handlePermission(
      context,
      permission,
      title: '$permissionName Permission Required',
      message: 'To access files, we need $permissionName permission. Please grant the permission.',
    );
  }

  /// Android Video Permission (Version-aware)
  static Future<bool> _requestAndroidVideoPermission(BuildContext context) async {
    final androidVersion = await _getAndroidVersion();

    Permission permission;
    String permissionName;

    // Android 13+ (API 33+)
    if (androidVersion >= 33) {
      permission = Permission.videos;
      permissionName = 'Videos';
    }
    // Android 6.0 to 12 (API 23-32)
    else {
      permission = Permission.storage;
      permissionName = 'Storage';
    }

    return await _handlePermission(
      context,
      permission,
      title: '$permissionName Permission Required',
      message: 'To access videos, we need $permissionName permission. Please grant the permission.',
    );
  }

  /// Android Audio Permission (Version-aware)
  static Future<bool> _requestAndroidAudioPermission(BuildContext context) async {
    final androidVersion = await _getAndroidVersion();

    Permission permission;
    String permissionName;

    // Android 13+ (API 33+)
    if (androidVersion >= 33) {
      permission = Permission.audio;
      permissionName = 'Audio';
    }
    // Android 6.0 to 12 (API 23-32)
    else {
      permission = Permission.storage;
      permissionName = 'Storage';
    }

    return await _handlePermission(
      context,
      permission,
      title: '$permissionName Permission Required',
      message: 'To access audio files, we need $permissionName permission. Please grant the permission.',
    );
  }

  /// Get Android SDK Version (Alternative method without device_info_plus)
  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      try {
        // Try to check which permissions are available to determine Android version
        // Android 13+ has photos permission
        final photosStatus = await Permission.photos.status;
        if (photosStatus != PermissionStatus.denied ||
            await Permission.photos.isRestricted == false) {
          // If photos permission exists, likely Android 13+
          return 33;
        }

        // Android 11-12 has manageExternalStorage
        final manageStorageStatus = await Permission.manageExternalStorage.status;
        if (manageStorageStatus != PermissionStatus.denied ||
            await Permission.manageExternalStorage.isRestricted == false) {
          return 30;
        }

        // Default to older Android versions
        return 29;
      } catch (e) {
        // If any error, default to API 33 (Android 13) for safety
        // This ensures we use the most modern permission approach
        return 33;
      }
    }
    return 0;
  }

  // ==================== iOS SPECIFIC ====================

  /// iOS Photos Permission
  static Future<bool> _requestIOSPhotosPermission(BuildContext context) async {
    return await _handlePermission(
      context,
      Permission.photos,
      title: 'Photo Library Permission Required',
      message: 'To access photos, we need permission to your photo library. Please grant the permission.',
    );
  }

  /// iOS Media Library Permission (for music/audio)
  static Future<bool> _requestIOSMediaLibraryPermission(BuildContext context) async {
    return await _handlePermission(
      context,
      Permission.mediaLibrary,
      title: 'Media Library Permission Required',
      message: 'To access audio files, we need permission to your media library. Please grant the permission.',
    );
  }

  // ==================== HELPER METHODS ====================

  /// Generic permission handler
  static Future<bool> _handlePermission(
      BuildContext context,
      Permission permission, {
        required String title,
        required String message,
      }) async {
    final status = await permission.status;

    if (status.isGranted || status.isLimited) {
      return true;
    } else if (status.isDenied) {
      await _showPermissionDialog(context, title: title, message: message);

      final newStatus = await permission.request();
      if (newStatus.isGranted || newStatus.isLimited) {
        return true;
      } else if (newStatus.isPermanentlyDenied) {
        await _showSettingsDialog(context);
      }
    } else if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context);
    } else {
      final newStatus = await permission.request();
      return newStatus.isGranted || newStatus.isLimited;
    }
    return false;
  }

  /// Show permission explanation dialog
  static Future<void> _showPermissionDialog(
      BuildContext context, {
        required String title,
        required String message,
      }) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(
          message,
          style: AppTextStyles.body1(
            dialogContext,
            overrideStyle: TextStyle(
              fontSize: ResponsiveHelper.fontSize(dialogContext, 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: AppTextStyles.heading2(
                dialogContext,
                overrideStyle: TextStyle(
                  color: Colors.red,
                  fontSize: ResponsiveHelper.fontSize(dialogContext, 12),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: Text(
              'Continue',
              style: AppTextStyles.heading2(
                dialogContext,
                overrideStyle: TextStyle(
                  color: AppColors.primary,
                  fontSize: ResponsiveHelper.fontSize(dialogContext, 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show settings dialog for permanently denied permissions
  static Future<void> _showSettingsDialog(BuildContext context) async {
    CustomSnackbarHelper.customShowSnackbar(
      context: context,
      message: "Permission is permanently denied. Please enable it in app settings.",
      backgroundColor: Colors.red,
    );
    await openAppSettings();
  }
}
