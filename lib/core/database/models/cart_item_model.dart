class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final double productPrice;
  final String?  variantColor;
  final String? variantSize;
  final int quantity;
  final DateTime addedAt;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    this.variantColor,
    this.variantSize,
    this.quantity = 1,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'product_name': productName,
      'product_price': productPrice,
      'variant_color': variantColor,
      'variant_size': variantSize,
      'quantity': quantity,
      'added_at': addedAt. toIso8601String(),
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      productId: map['product_id'] as String,
      productName: map['product_name'] as String,
      productPrice: (map['product_price'] as num).toDouble(),
      variantColor: map['variant_color'] as String?,
      variantSize: map['variant_size'] as String?,
      quantity: map['quantity'] as int?  ?? 1,
      addedAt: DateTime.parse(map['added_at'] as String),
    );
  }

  CartItemModel copyWith({
    String? id,
    String? userId,
    String? productId,
    String? productName,
    double? productPrice,
    String? variantColor,
    String? variantSize,
    int? quantity,
    DateTime?  addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      productName: productName ??  this.productName,
      productPrice: productPrice ?? this.productPrice,
      variantColor: variantColor ?? this.variantColor,
      variantSize: variantSize ?? this.variantSize,
      quantity: quantity ??  this.quantity,
      addedAt: addedAt ?? this. addedAt,
    );
  }
}