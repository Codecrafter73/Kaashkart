import 'dart:convert';
import 'package:kaashtkart/features/customer/screen/customer/cart/model/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorageHelper {
  static final StorageHelper _instance = StorageHelper._internal();
  factory StorageHelper() => _instance;
  StorageHelper._internal();

  static const String _cartKeyPrefix = 'kaashtkart_cart_';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) await init();
  }

  String _getCartKey() {
    final userId = getUserId();
    return userId.isNotEmpty ? '${_cartKeyPrefix}_$userId' : _cartKeyPrefix;
  }

  // Save Cart
  Future<void> saveCartItems(List<CartItem> items) async {
    await _ensureInitialized();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_getCartKey(), jsonString);
  }

  // Load Cart
  Future<List<CartItem>> loadCartItems() async {
    await _ensureInitialized();
    final jsonString = _prefs.getString(_getCartKey());
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => CartItem.fromJson(e)).toList();
  }

  // Clear Cart
  Future<void> clearCart() async {
    await _ensureInitialized();
    await _prefs.remove(_getCartKey());
  }

  // User ID (for multi-user support)
  Future<void> setUserId(String id) async {
    await _ensureInitialized();
    await _prefs.setString('user_id', id);
  }

  String getUserId() {
    return _prefs.getString('user_id') ?? '';
  }

  Future<void> clearUserData() async {
    await _ensureInitialized();
    await _prefs.remove('user_id');
    await clearCart();
  }
}