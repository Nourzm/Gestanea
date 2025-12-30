import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';
import 'package:gestanea/core/database/models/product_variant_model.dart';
import 'package:gestanea/core/database/models/product_spec_model.dart';
import 'package:gestanea/core/database/models/product_review_model.dart';
import 'package:gestanea/core/config.dart';

class ProductApiService {
  static String get baseUrl => Config.apiBaseUrl;
  static const String endpoint = '/products';

  // ==================== PRODUCTS ====================

  /// Get all products with optional filtering and pagination
  static Future<List<ProductModel>> getProducts({
    int skip = 0,
    int limit = 100,
    String? categoryId,
    bool? isAvailable,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (isAvailable != null)
        queryParams['is_available'] = isAvailable.toString();
      if (search != null) queryParams['search'] = search;

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/').replace(queryParameters: queryParams),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _productFromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Get a single product by ID
  static Future<ProductModel> getProduct(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/$productId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _productFromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  /// Helper to convert API JSON to ProductModel
  static ProductModel _productFromJson(Map<String, dynamic> json) {
    // Handle image_urls - can be string (JSON) or already parsed
    List<String> imageUrls;
    if (json['image_urls'] is String) {
      try {
        imageUrls = List<String>.from(jsonDecode(json['image_urls'] as String));
      } catch (e) {
        // If parsing fails, treat as single URL
        imageUrls = [json['image_urls'] as String];
      }
    } else if (json['image_urls'] is List) {
      imageUrls = List<String>.from(json['image_urls']);
    } else {
      imageUrls = [];
    }

    // Handle is_available - can be boolean or integer
    bool isAvailable;
    if (json['is_available'] is bool) {
      isAvailable = json['is_available'] as bool;
    } else {
      isAvailable = (json['is_available'] as int? ?? 1) == 1;
    }

    return ProductModel(
      id: json['id'] as String,
      productName: json['product_name'] as String,
      description: json['description'] as String?,
      categoryId: json['category_id'] as String,
      targetAudience: json['target_audience'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      discountPercentage: json['discount_percentage'] as int?,
      currency: json['currency'] as String? ?? 'USD',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      imageUrls: imageUrls,
      vendorName: json['vendor_name'] as String?,
      isAvailable: isAvailable,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  // ==================== PRODUCT CATEGORIES ====================

  /// Get all product categories
  static Future<List<ProductCategoryModel>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/categories/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _categoryFromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Get a single category by ID
  static Future<ProductCategoryModel> getCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/categories/$categoryId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _categoryFromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  /// Helper to convert API JSON to ProductCategoryModel
  static ProductCategoryModel _categoryFromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      displayOrder: json['display_order'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  // ==================== PRODUCT VARIANTS ====================

  /// Get all variants for a product
  static Future<List<ProductVariantModel>> getProductVariants(
    String productId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/$productId/variants'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _variantFromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load product variants: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching product variants: $e');
    }
  }

  /// Helper to convert API JSON to ProductVariantModel
  static ProductVariantModel _variantFromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
      colorHex: json['color_hex'] as String?,
      stock: json['stock'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  // ==================== PRODUCT SPECS ====================

  /// Get all specs for a product
  static Future<List<ProductSpecModel>> getProductSpecs(
    String productId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/$productId/specs'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _specFromJson(json)).toList();
      } else {
        throw Exception('Failed to load product specs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product specs: $e');
    }
  }

  /// Helper to convert API JSON to ProductSpecModel
  static ProductSpecModel _specFromJson(Map<String, dynamic> json) {
    return ProductSpecModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  // ==================== PRODUCT REVIEWS ====================

  /// Get all reviews for a product
  static Future<List<ProductReviewModel>> getProductReviews(
    String productId, {
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      final response = await http.get(
        Uri.parse(
          '$baseUrl$endpoint/$productId/reviews',
        ).replace(queryParameters: queryParams),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _reviewFromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load product reviews: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching product reviews: $e');
    }
  }

  /// Helper to convert API JSON to ProductReviewModel
  static ProductReviewModel _reviewFromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      userId: json['user_id'] as String,
      reviewerName: json['reviewer_name'] as String,
      rating: json['rating'] as int,
      reviewText: json['review_text'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}
