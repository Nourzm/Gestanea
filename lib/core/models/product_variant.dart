class ProductVariant {
  final String id;
  final String productId;
  final String variantType; // 'color', 'size'
  final String variantValue; // 'pink', 'blue', 'S', 'M', 'L'
  final double? priceAdjustment;
  final DateTime createdAt;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.variantType,
    required this.variantValue,
    this.priceAdjustment,
    required this.createdAt,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      variantType: map['variant_type'] as String,
      variantValue: map['variant_value'] as String,
      priceAdjustment: map['price_adjustment'] != null ? (map['price_adjustment'] as num).toDouble() : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'variant_type': variantType,
      'variant_value': variantValue,
      'price_adjustment': priceAdjustment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
