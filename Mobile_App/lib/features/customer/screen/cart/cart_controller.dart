import 'package:flutter/material.dart';
import 'package:kaashtkart/features/customer/screen/customer/cart/model/cart_item_model.dart';
import 'package:kaashtkart/core/utls/storage_helper.dart';

class CartProvider extends ChangeNotifier {
  final StorageHelper _storage = StorageHelper();
  List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  int get totalUniqueItems => _items.length; // unique cart counter
  double get totalMRP => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => totalMRP >= 500 ? 0.0 : (totalMRP > 0 ? 149.0 : 0.0);
  double get totalAmount => totalMRP + deliveryFee;
  bool get isEmpty => _items.isEmpty;

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _items = await _storage.loadCartItems();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    await _storage.saveCartItems(_items);
    notifyListeners();
  }

  // Unique key for variant = productId + size
  String _getUniqueKey(String productId, String size) {
    return '${productId}_$size';
  }

  // Add Single Product (No Variants)
  Future<void> addSingleProduct(Map<String, dynamic> product) async {
    final uniqueKey = _getUniqueKey(product['name'], 'Standard');

    final existingIndex = _items.indexWhere(
          (item) => _getUniqueKey(item.productId, item.size) == uniqueKey,
    );

    if (existingIndex != -1) {
      // Same product → increase quantity
      _items[existingIndex].quantity += 1;
    } else {
      // New product → add new item
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product['name'],
        name: product['name'],
        image: product['image'] ?? '',
        size: 'Standard',
        price: _parsePrice(product['price']),
        pricePerUnit: _parsePrice(product['price']),
        quantity: 1,
        badge: product['badge'],
      );
      _items.add(newItem);
    }

    await _saveCart();
  }

  // Add Variants (Smart Merge)
  Future<void> addVariants(
      Map<String, dynamic> product,
      Map<int, int> selectedQuantities,
      ) async {
    final variants = product['variants'] as List<Map<String, dynamic>>;

    for (var entry in selectedQuantities.entries) {
      final index = entry.key;
      final qtyToAdd = entry.value;

      if (qtyToAdd <= 0 || index >= variants.length) continue;

      final variant = variants[index];
      final uniqueKey = _getUniqueKey(product['name'], variant['size']);

      final existingIndex = _items.indexWhere(
            (item) => _getUniqueKey(item.productId, item.size) == uniqueKey,
      );

      if (existingIndex != -1) {
        // Same variant exists → increase quantity
        _items[existingIndex].quantity += qtyToAdd;
      } else {
        // New variant → add fresh
        final newItem = CartItem(
          id: '${DateTime.now().millisecondsSinceEpoch}_$index',
          productId: product['name'],
          name: product['name'],
          image: variant['image'] ?? product['image'] ?? '',
          size: variant['size'] ?? 'Standard',
          price: _parsePrice(variant['price']),
          pricePerUnit: _parsePrice(variant['pricePerUnit']),
          quantity: qtyToAdd,
          badge: variant['badge'] ?? product['badge'],
        );
        _items.add(newItem);
      }
    }

    await _saveCart();
  }

  // Increase / Decrease
  void increaseQuantity(String itemId) => _updateQuantity(itemId, 1);
  void decreaseQuantity(String itemId) => _updateQuantity(itemId, -1);

  void _updateQuantity(String itemId, int change) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final newQty = _items[index].quantity + change;
    if (newQty <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: newQty);
    }
    _saveCart();
  }

  // Remove Item
  Future<void> removeItem(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
    await _saveCart();
  }

  // Clear Cart
  Future<void> clearCart() async {
    _items.clear();
    await _storage.clearCart();
    notifyListeners();
  }

  // Helper: Parse price string like "₹2,278" → 2278.0
  double _parsePrice(dynamic price) {
    if (price is num) return price.toDouble();
    if (price is String) {
      return double.tryParse(price.replaceAll('₹', '').replaceAll(',', '').trim()) ?? 0.0;
    }
    return 0.0;
  }
}