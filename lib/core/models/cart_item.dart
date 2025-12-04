class CartItem {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final DateTime createdAt;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    required this.createdAt,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      productId: map['product_id'] as String,
      quantity: map['quantity'] as int,
      selectedColor: map['selected_color'] as String?,
      selectedSize: map['selected_size'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'created_at': createdAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    String? id,
    String? userId,
    String? productId,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    DateTime? createdAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
