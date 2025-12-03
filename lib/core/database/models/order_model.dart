class OrderModel {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String deliveryAddress;
  final String city;
  final String? specialInstructions;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.deliveryAddress,
    required this.city,
    this.specialInstructions,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    this.status = 'pending',
    required this.orderDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'delivery_address': deliveryAddress,
      'city': city,
      'special_instructions': specialInstructions,
      'payment_method': paymentMethod,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'total_amount': totalAmount,
      'status': status,
      'order_date': orderDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      fullName: map['full_name'] as String,
      phoneNumber: map['phone_number'] as String,
      deliveryAddress: map['delivery_address'] as String,
      city: map['city'] as String,
      specialInstructions: map['special_instructions'] as String?,
      paymentMethod: map['payment_method'] as String,
      subtotal: (map['subtotal'] as num).toDouble(),
      deliveryFee: (map['delivery_fee'] as num).toDouble(),
      totalAmount: (map['total_amount'] as num).toDouble(),
      status: map['status'] as String? ?? 'pending',
      orderDate: DateTime.parse(map['order_date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phoneNumber,
    String? deliveryAddress,
    String? city,
    String? specialInstructions,
    String? paymentMethod,
    double? subtotal,
    double? deliveryFee,
    double? totalAmount,
    String? status,
    DateTime? orderDate,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      city: city ?? this.city,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
