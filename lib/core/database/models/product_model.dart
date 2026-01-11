import 'dart:convert';

class ProductModel {
  final String id;
  final String productName;
  final String? description;
  final String categoryId;
  final String? targetAudience;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final String currency;
  final double rating;
  final int reviewsCount;
  final List<String> imageUrls;
  final String? vendorName;
  final bool isAvailable;
  final DateTime createdAt;
  final Map<String, dynamic>? translations;

  ProductModel({
    required this.id,
    required this.productName,
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
    this.translations,
  });

  /// Get translated product name based on language code
  String getTranslatedName(String languageCode) {
    if (translations != null && translations!.containsKey(languageCode)) {
      final translation = translations![languageCode];
      if (translation is Map<String, dynamic>) {
        // Try 'product_name' field first, then 'name', then 'productName'
        if (translation.containsKey('product_name')) {
          return translation['product_name'] as String;
        } else if (translation.containsKey('name')) {
          return translation['name'] as String;
        } else if (translation.containsKey('productName')) {
          return translation['productName'] as String;
        }
      }
    }
    return productName;
  }

  /// Get translated description based on language code
  String? getTranslatedDescription(String languageCode) {
    if (translations != null && translations!.containsKey(languageCode)) {
      final translation = translations![languageCode];
      if (translation is Map<String, dynamic> &&
          translation.containsKey('description')) {
        return translation['description'] as String;
      }
    }
    return description;
  }

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
      'translations': translations != null ? jsonEncode(translations) : null,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? parsedTranslations;
    if (map['translations'] != null) {
      try {
        if (map['translations'] is String) {
          parsedTranslations =
              jsonDecode(map['translations'] as String) as Map<String, dynamic>;
        } else if (map['translations'] is Map) {
          parsedTranslations = Map<String, dynamic>.from(
            map['translations'] as Map,
          );
        }
      } catch (e) {
        parsedTranslations = null;
      }
    }

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
      currency: map['currency'] as String? ?? 'USD',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: map['reviews_count'] as int? ?? 0,
      imageUrls: List<String>.from(jsonDecode(map['image_urls'] as String)),
      vendorName: map['vendor_name'] as String?,
      isAvailable: (map['is_available'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      translations: parsedTranslations,
    );
  }

  ProductModel copyWith({
    String? id,
    String? productName,
    String? description,
    String? categoryId,
    String? targetAudience,
    double? price,
    double? originalPrice,
    int? discountPercentage,
    String? currency,
    double? rating,
    int? reviewsCount,
    List<String>? imageUrls,
    String? vendorName,
    bool? isAvailable,
    DateTime? createdAt,
    Map<String, dynamic>? translations,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      targetAudience: targetAudience ?? this.targetAudience,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      currency: currency ?? this.currency,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageUrls: imageUrls ?? this.imageUrls,
      vendorName: vendorName ?? this.vendorName,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      translations: translations ?? this.translations,
    );
  }
}
