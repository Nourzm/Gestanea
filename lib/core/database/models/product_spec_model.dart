class ProductSpecModel {
  final String id;
  final String productId;
  final String name;
  final String value;
  final DateTime createdAt;

  ProductSpecModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.value,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'value': value,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ProductSpecModel.fromMap(Map<String, dynamic> map) {
    return ProductSpecModel(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      name: map['name'] as String,
      value: map['value'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ProductSpecModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? value,
    DateTime? createdAt,
  }) {
    return ProductSpecModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
