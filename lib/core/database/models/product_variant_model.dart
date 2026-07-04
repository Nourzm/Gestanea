class ProductVariantModel {
  final String id;
  final String productId;
  final String type;
  final String value;
  final String? colorHex;
  final int stock;
  final DateTime createdAt;

  ProductVariantModel({
    required this.id,
    required this.productId,
    required this.type,
    required this.value,
    this.colorHex,
    this.stock = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'type': type,
      'value': value,
      'color_hex': colorHex,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ProductVariantModel.fromMap(Map<String, dynamic> map) {
    return ProductVariantModel(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      type: map['type'] as String,
      value: map['value'] as String,
      colorHex: map['color_hex'] as String?,
      stock: map['stock'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ProductVariantModel copyWith({
    String? id,
    String? productId,
    String? type,
    String? value,
    String? colorHex,
    int? stock,
    DateTime? createdAt,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      value: value ?? this.value,
      colorHex: colorHex ?? this.colorHex,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
