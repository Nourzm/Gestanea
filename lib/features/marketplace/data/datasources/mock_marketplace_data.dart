import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';
import 'package:gestanea/core/database/models/product_review_model.dart';
import 'package:gestanea/core/database/models/product_variant_model.dart';
import 'package:gestanea/core/database/models/product_spec_model.dart';

class MockMarketplaceData {
  static List<ProductCategoryModel> getCategories() {
    return [
      ProductCategoryModel(
        id: 'cat_1',
        name: 'Maternity Wear',
        imageUrl: 'assets/images/Maternity_wear.webp',
        displayOrder: 1,
        createdAt: DateTime.now(),
      ),
      ProductCategoryModel(
        id: 'cat_2',
        name: 'Pain Relief',
        imageUrl: 'assets/images/pain.webp',
        displayOrder: 2,
        createdAt: DateTime.now(),
      ),
      ProductCategoryModel(
        id: 'cat_3',
        name: 'Skin Care',
        imageUrl: 'assets/images/skin_care.webp',
        displayOrder: 3,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<ProductModel> getProducts() {
    return [
      ProductModel(
        id: 'prod_1',
        productName: 'Premium Pregnancy Pillow',
        description:
            'Experience ultimate comfort during pregnancy with our Premium Pregnancy Pillow. Designed with premium memory foam and a full-body C-shape, this pillow provides optimal support for your back, hips, knees, neck, and belly.',
        categoryId: 'cat_1',
        targetAudience: 'pregnant_women',
        price: 22.40,
        originalPrice: 32.00,
        discountPercentage: 30,
        currency: 'USD',
        rating: 4.8,
        reviewsCount: 234,
        imageUrls: [
          'assets/images/product.png',
          'assets/images/product.png',
          'assets/images/product.png',
        ],
        vendorName: 'ComfortCare',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'prod_2',
        productName: 'Back Support Belt',
        description:
            'Ergonomic back support belt designed for pregnancy. Provides gentle support to lower back and reduces strain.',
        categoryId: 'cat_2',
        targetAudience: 'pregnant_women',
        price: 22.40,
        originalPrice: 32.00,
        discountPercentage: 30,
        currency: 'USD',
        rating: 4.5,
        reviewsCount: 156,
        imageUrls: [
          'assets/images/Back_pain_belt.webp',
          'assets/images/Back_pain_belt.webp',
        ],
        vendorName: 'MaternalCare',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'prod_3',
        productName: 'Stretch Mark Cream',
        description:
            'Natural stretch mark prevention cream with cocoa butter and vitamin E.',
        categoryId: 'cat_3',
        targetAudience: 'pregnant_women',
        price: 18.99,
        originalPrice: null,
        discountPercentage: null,
        currency: 'USD',
        rating: 4.6,
        reviewsCount: 89,
        imageUrls: ['assets/images/skin_care.webp'],
        vendorName: 'NaturalBeauty',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<ProductVariantModel> getProductVariants(String productId) {
    return [
      ProductVariantModel(
        id: 'var_1',
        productId: productId,
        type: 'color',
        value: 'Lavender',
        colorHex: '#D4A5E8',
        stock: 50,
        createdAt: DateTime.now(),
      ),
      ProductVariantModel(
        id: 'var_2',
        productId: productId,
        type: 'color',
        value: 'Pink',
        colorHex: '#FF91C7',
        stock: 30,
        createdAt: DateTime.now(),
      ),
      ProductVariantModel(
        id: 'var_3',
        productId: productId,
        type: 'color',
        value: 'Gray',
        colorHex: '#9E9E9E',
        stock: 45,
        createdAt: DateTime.now(),
      ),
      ProductVariantModel(
        id: 'var_4',
        productId: productId,
        type: 'size',
        value: 'Standard',
        stock: 100,
        createdAt: DateTime.now(),
      ),
      ProductVariantModel(
        id: 'var_5',
        productId: productId,
        type: 'size',
        value: 'Large',
        stock: 75,
        createdAt: DateTime.now(),
      ),
      ProductVariantModel(
        id: 'var_6',
        productId: productId,
        type: 'size',
        value: 'XL',
        stock: 50,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<ProductSpecModel> getProductSpecs(String productId) {
    return [
      ProductSpecModel(
        id: 'spec_1',
        productId: productId,
        name: 'Material',
        value: 'Premium Memory Foam',
        createdAt: DateTime.now(),
      ),
      ProductSpecModel(
        id: 'spec_2',
        productId: productId,
        name: 'Cover',
        value: '100% Cotton',
        createdAt: DateTime.now(),
      ),
      ProductSpecModel(
        id: 'spec_3',
        productId: productId,
        name: 'Dimensions',
        value: '54" x 31" x 7"',
        createdAt: DateTime.now(),
      ),
      ProductSpecModel(
        id: 'spec_4',
        productId: productId,
        name: 'Weight',
        value: '4.5 lbs',
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<ProductReviewModel> getProductReviews(String productId) {
    return [
      ProductReviewModel(
        id: 'rev_1',
        productId: productId,
        userId: 'user_1',
        reviewerName: 'Sarah Mitchell',
        rating: 5,
        reviewText:
            'This pillow has been a game-changer! I\'m sleeping so much better now. The quality is excellent and it\'s super comfortable.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ProductReviewModel(
        id: 'rev_2',
        productId: productId,
        userId: 'user_2',
        reviewerName: 'Emily Johnson',
        rating: 5,
        reviewText:
            'Highly recommend! Perfect support for my back and belly. Worth every penny.',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      ProductReviewModel(
        id: 'rev_3',
        productId: productId,
        userId: 'user_3',
        reviewerName: 'Jessica Brown',
        rating: 4,
        reviewText:
            'Great product overall. Very comfortable, though it takes up quite a bit of space on the bed.',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }
}
