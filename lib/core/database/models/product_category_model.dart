class ProductCategoryModel {
  final String id;
  final String?  name;
  final String? imageUrl;
  final int? displayOrder;
  final DateTime createdAt;

  ProductCategoryModel({
    required this.id,
    this.name,
    this.imageUrl,
    this.displayOrder,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      id: map['id'] as String,
      name: map['name'] as String?,
      imageUrl: map['image_url'] as String?,
      displayOrder: map['display_order'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this. displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}