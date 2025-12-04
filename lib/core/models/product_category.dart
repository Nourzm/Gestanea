class ProductCategory {
  final String id;
  final String name;
  final String? icon;
  final String? imageUrl;
  final DateTime createdAt;

  ProductCategory({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
    required this.createdAt,
  });

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String?,
      imageUrl: map['image_url'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
