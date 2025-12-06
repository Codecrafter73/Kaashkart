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

  //////// 👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉 CUSTOMER 👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉

  String _getCartKey() {
    final userId = getLoginUserId();
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
  Future<void> setBoolIsLoggedIn(bool value) async {
    print("📝 setBoolIsLoggedIn: $value");
    await _prefs.setBool("isLoggedIn", value);
  }

  Future<bool> getBoolIsLoggedIn() async {
    final value = _prefs.getBool("isLoggedIn") ?? false;
    print("📤 getBoolIsLoggedIn: $value");
    return value;
  }

  Future<void> setLoginUserId(String id) async {
    await _ensureInitialized();
    await _prefs.setString('user_id', id);
  }

  String getLoginUserId() {
    return _prefs.getString('user_id') ?? '';
  }

  Future<void> setLoginUserName(String token) async {
    print("📝 setLoginUserName: $token");
    await _prefs.setString('login_user_name', token);
  }

  Future<String> getLoginUserName() async {
    return _prefs.getString('login_user_name') ?? "";
  }

  Future<void> setLoginUserEmail(String token) async {
    await _prefs.setString('login_user_email', token);
  }

  Future<String> getLoginUserEmail() async {
    return _prefs.getString('login_user_email') ?? "";
  }

  Future<void> setLoginUserPhone(String token) async {
    await _prefs.setString('login_user_phone', token);
  }

  Future<String> getLoginUserPhone() async {
    return _prefs.getString('login_user_phone') ?? "";
  }


  Future<void> clearUserData() async {
    await _ensureInitialized();
    await _prefs.remove('user_id');
    await clearCart();
  }
}