/// CartItem Model - Represents a single item in cart
class CartItem {
  final String id;
  final String productId;
  final String name;
  final String image;
  final String size;
  final double price;
  final double pricePerUnit;
  int quantity;
  final String? badge;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.size,
    required this.price,
    required this.pricePerUnit,
    required this.quantity,
    this.badge,
  });

  // ✅ Total price for this item
  double get totalPrice => price * quantity;

  // ✅ Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'size': size,
      'price': price,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'badge': badge,
    };
  }

  // ✅ Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      quantity: json['quantity'] as int,
      badge: json['badge'] as String?,
    );
  }

  // ✅ Create a copy with modified fields
  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? image,
    String? size,
    double? price,
    double? pricePerUnit,
    int? quantity,
    String? badge,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      size: size ?? this.size,
      price: price ?? this.price,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      quantity: quantity ?? this.quantity,
      badge: badge ?? this.badge,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, size: $size, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}