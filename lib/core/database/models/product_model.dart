import 'dart:convert';

class ProductModel {
  final String id;
  final String productName;
  final String? description;
  final String categoryId;
  final String? targetAudience;
  final double price;
  final double? originalPrice;
  final int?  discountPercentage;
  final String currency;
  final double rating;
  final int reviewsCount;
  final List<String> imageUrls;
  final String? vendorName;
  final bool isAvailable;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this. productName,
    this.description,
    required this.categoryId,
    this.targetAudience,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.currency = 'USD',
    this.rating = 0,
    this.reviewsCount = 0,
    required this.imageUrls,
    this.vendorName,
    this.isAvailable = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_name': productName,
      'description': description,
      'category_id': categoryId,
      'target_audience': targetAudience,
      'price': price,
      'original_price': originalPrice,
      'discount_percentage': discountPercentage,
      'currency': currency,
      'rating': rating,
      'reviews_count': reviewsCount,
      'image_urls': jsonEncode(imageUrls),
      'vendor_name': vendorName,
      'is_available': isAvailable ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      productName: map['product_name'] as String,
      description: map['description'] as String?,
      categoryId: map['category_id'] as String,
      targetAudience: map['target_audience'] as String?,
      price: (map['price'] as num).toDouble(),
      originalPrice: map['original_price'] != null
          ? (map['original_price'] as num).toDouble()
          : null,
      discountPercentage: map['discount_percentage'] as int?,
      currency: map['currency'] as String?  ?? 'USD',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: map['reviews_count'] as int? ??  0,
      imageUrls: List<String>.from(jsonDecode(map['image_urls'] as String)),
      vendorName: map['vendor_name'] as String?,
      isAvailable: (map['is_available'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ProductModel copyWith({
    String?  id,
    String? productName,
    String? description,
    String? categoryId,
    String? targetAudience,
    double? price,
    double? originalPrice,
    int?  discountPercentage,
    String? currency,
    double?  rating,
    int? reviewsCount,
    List<String>? imageUrls,
    String? vendorName,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      categoryId: categoryId ??  this.categoryId,
      targetAudience: targetAudience ?? this.targetAudience,
      price: price ?? this. price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      currency: currency ?? this.currency,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageUrls: imageUrls ?? this.imageUrls,
      vendorName: vendorName ?? this.vendorName,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}