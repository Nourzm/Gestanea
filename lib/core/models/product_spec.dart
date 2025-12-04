class ProductSpec {
  final String id;
  final String productId;
  final String specName;
  final String specValue;
  final DateTime createdAt;

  ProductSpec({
    required this.id,
    required this.productId,
    required this.specName,
    required this.specValue,
    required this.createdAt,
  });

  factory ProductSpec.fromMap(Map<String, dynamic> map) {
    return ProductSpec(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      specName: map['spec_name'] as String,
      specValue: map['spec_value'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'spec_name': specName,
      'spec_value': specValue,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
