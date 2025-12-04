class Order {
  final String id;
  final String userId;
  final String orderNumber;
  final double totalAmount;
  final String status; // 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
  final String? paymentMethod;
  final String? shippingAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.shippingAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      orderNumber: map['order_number'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
      status: map['status'] as String,
      paymentMethod: map['payment_method'] as String?,
      shippingAddress: map['shipping_address'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    String? orderNumber,
    double? totalAmount,
    String? status,
    String? paymentMethod,
    String? shippingAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderNumber: orderNumber ?? this.orderNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
