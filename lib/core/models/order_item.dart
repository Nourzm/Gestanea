class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double price;
  final String? selectedColor;
  final String? selectedSize;
  final DateTime createdAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.selectedColor,
    this.selectedSize,
    required this.createdAt,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as String,
      orderId: map['order_id'] as String,
      productId: map['product_id'] as String,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      selectedColor: map['selected_color'] as String?,
      selectedSize: map['selected_size'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get totalPrice => price * quantity;
}
