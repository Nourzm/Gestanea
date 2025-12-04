class Product {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final double? discountPercentage;
  final String imageUrl;
  final double? rating;
  final int? reviewsCount;
  final int stockQuantity;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPercentage,
    required this.imageUrl,
    this.rating,
    this.reviewsCount,
    required this.stockQuantity,
    required this.createdAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      categoryId: map['category_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      discountPercentage: map['discount_percentage'] != null ? (map['discount_percentage'] as num).toDouble() : null,
      imageUrl: map['image_url'] as String,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      reviewsCount: map['reviews_count'] as int?,
      stockQuantity: map['stock_quantity'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'discount_percentage': discountPercentage,
      'image_url': imageUrl,
      'rating': rating,
      'reviews_count': reviewsCount,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get finalPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;
}
