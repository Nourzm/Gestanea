import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gestanea/features/marketplace/logic/marketplace_bloc.dart';
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Marketplace Flow Integration Tests', () {
    late MarketplaceBloc marketplaceBloc;
    late List<ProductCategoryModel> mockCategories;
    late List<ProductModel> mockProducts;

    setUp(() {
      marketplaceBloc = MarketplaceBloc();

      mockCategories = [
        ProductCategoryModel(
          id: 'cat1',
          name: 'Baby Care',
          imageUrl: 'cat1.jpg',
          displayOrder: 1,
          createdAt: DateTime.now(),
        ),
        ProductCategoryModel(
          id: 'cat2',
          name: 'Maternity',
          imageUrl: 'cat2.jpg',
          displayOrder: 2,
          createdAt: DateTime.now(),
        ),
        ProductCategoryModel(
          id: 'cat3',
          name: 'Health',
          imageUrl: 'cat3.jpg',
          displayOrder: 3,
          createdAt: DateTime.now(),
        ),
      ];

      mockProducts = [
        ProductModel(
          id: 'prod1',
          productName: 'Baby Stroller Premium',
          description: 'High-quality baby stroller with comfort features',
          categoryId: 'cat1',
          price: 299.99,
          originalPrice: 399.99,
          discountPercentage: 25,
          rating: 4.5,
          reviewsCount: 120,
          imageUrls: ['stroller1.jpg', 'stroller2.jpg'],
          isAvailable: true,
          createdAt: DateTime.now(),
        ),
        ProductModel(
          id: 'prod2',
          productName: 'Maternity Dress Blue',
          description: 'Beautiful blue maternity dress',
          categoryId: 'cat2',
          price: 49.99,
          rating: 4.8,
          reviewsCount: 85,
          imageUrls: ['dress1.jpg'],
          isAvailable: true,
          createdAt: DateTime.now(),
        ),
        ProductModel(
          id: 'prod3',
          productName: 'Baby Diaper Pack',
          description: 'Soft and absorbent diapers',
          categoryId: 'cat1',
          price: 35.00,
          rating: 4.2,
          reviewsCount: 200,
          imageUrls: ['diaper1.jpg'],
          isAvailable: true,
          createdAt: DateTime.now(),
        ),
        ProductModel(
          id: 'prod4',
          productName: 'Prenatal Vitamins',
          description: 'Essential vitamins for pregnancy',
          categoryId: 'cat3',
          price: 25.99,
          rating: 4.7,
          reviewsCount: 150,
          imageUrls: ['vitamins1.jpg'],
          isAvailable: true,
          createdAt: DateTime.now(),
        ),
        ProductModel(
          id: 'prod5',
          productName: 'Baby Monitor',
          description: 'Video baby monitor with night vision',
          categoryId: 'cat1',
          price: 149.99,
          rating: 4.6,
          reviewsCount: 95,
          imageUrls: ['monitor1.jpg'],
          isAvailable: false, // Out of stock
          createdAt: DateTime.now(),
        ),
      ];
    });

    tearDown(() {
      marketplaceBloc.close();
    });

    test('Search flow - find products by name', () {
      // Simulate search for "stroller"
      const query = 'stroller';
      final results = mockProducts
          .where(
            (p) => p.productName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      expect(results.length, 1);
      expect(results.first.productName, 'Baby Stroller Premium');
      expect(results.first.price, 299.99);
    });

    test('Search flow - case insensitive search', () {
      const query = 'BABY';
      final results = mockProducts
          .where(
            (p) => p.productName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      expect(results.length, 3); // Baby Stroller, Baby Diaper, Baby Monitor
    });

    test('Search flow - search in descriptions', () {
      const query = 'vitamins';
      final results = mockProducts
          .where(
            (p) =>
                p.productName.toLowerCase().contains(query.toLowerCase()) ||
                (p.description?.toLowerCase().contains(query.toLowerCase()) ??
                    false),
          )
          .toList();

      expect(results.length, 1);
      expect(results.first.productName, 'Prenatal Vitamins');
    });

    test('Search flow - no results', () {
      const query = 'nonexistent';
      final results = mockProducts
          .where(
            (p) => p.productName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      expect(results, isEmpty);
    });

    test('Search flow - empty query returns all available products', () {
      const query = '';
      final results = query.isEmpty
          ? mockProducts.where((p) => p.isAvailable).toList()
          : mockProducts;

      expect(results.length, 4); // Excludes out of stock monitor
    });

    test('Filter by category - Baby Care products', () {
      const categoryId = 'cat1';
      final results = mockProducts
          .where((p) => p.categoryId == categoryId && p.isAvailable)
          .toList();

      expect(
        results.length,
        2,
      ); // Stroller and Diapers (Monitor is unavailable)
      expect(results.every((p) => p.categoryId == 'cat1'), true);
    });

    test('Filter by category - Maternity products', () {
      const categoryId = 'cat2';
      final results = mockProducts
          .where((p) => p.categoryId == categoryId && p.isAvailable)
          .toList();

      expect(results.length, 1);
      expect(results.first.productName, 'Maternity Dress Blue');
    });

    test('Filter by category - Health products', () {
      const categoryId = 'cat3';
      final results = mockProducts
          .where((p) => p.categoryId == categoryId && p.isAvailable)
          .toList();

      expect(results.length, 1);
      expect(results.first.productName, 'Prenatal Vitamins');
    });

    test('Combined filter - category and search', () {
      const categoryId = 'cat1';
      const query = 'baby';

      final results = mockProducts
          .where((p) => p.categoryId == categoryId)
          .where(
            (p) => p.productName.toLowerCase().contains(query.toLowerCase()),
          )
          .where((p) => p.isAvailable)
          .toList();

      expect(results.length, 2); // Baby Stroller and Baby Diaper
    });

    test('Product availability filtering', () {
      final availableProducts = mockProducts
          .where((p) => p.isAvailable)
          .toList();

      expect(availableProducts.length, 4);
      expect(availableProducts.every((p) => p.isAvailable), true);
    });

    test('Sort products by price - ascending', () {
      final sorted = List<ProductModel>.from(mockProducts)
        ..sort((a, b) => a.price.compareTo(b.price));

      expect(sorted.first.price, 25.99); // Prenatal Vitamins
      expect(sorted.last.price, 299.99); // Baby Stroller
    });

    test('Sort products by price - descending', () {
      final sorted = List<ProductModel>.from(mockProducts)
        ..sort((a, b) => b.price.compareTo(a.price));

      expect(sorted.first.price, 299.99); // Baby Stroller
      expect(sorted.last.price, 25.99); // Prenatal Vitamins
    });

    test('Sort products by rating', () {
      final sorted = List<ProductModel>.from(mockProducts)
        ..sort((a, b) => b.rating.compareTo(a.rating));

      expect(sorted.first.rating, 4.8); // Maternity Dress
      expect(sorted.first.productName, 'Maternity Dress Blue');
    });

    test('Sort products by reviews count', () {
      final sorted = List<ProductModel>.from(mockProducts)
        ..sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));

      expect(sorted.first.reviewsCount, 200); // Baby Diaper Pack
    });

    test('Filter products with discount', () {
      final discounted = mockProducts
          .where(
            (p) => p.discountPercentage != null && p.discountPercentage! > 0,
          )
          .toList();

      expect(discounted.length, 1);
      expect(discounted.first.productName, 'Baby Stroller Premium');
      expect(discounted.first.discountPercentage, 25);
    });

    test('Calculate discount amount', () {
      final product = mockProducts.first; // Baby Stroller with discount

      if (product.originalPrice != null && product.discountPercentage != null) {
        final discountAmount = product.originalPrice! - product.price;
        final expectedDiscount =
            product.originalPrice! * (product.discountPercentage! / 100);

        expect(discountAmount, closeTo(expectedDiscount, 0.01));
        expect(discountAmount, 100.00); // 399.99 - 299.99
      }
    });

    test('Price range filtering - budget products', () {
      const maxPrice = 50.0;
      final budgetProducts = mockProducts
          .where((p) => p.price <= maxPrice && p.isAvailable)
          .toList();

      expect(budgetProducts.length, 3); // Maternity Dress, Diapers, Vitamins
      expect(budgetProducts.every((p) => p.price <= maxPrice), true);
    });

    test('Price range filtering - premium products', () {
      const minPrice = 100.0;
      final premiumProducts = mockProducts
          .where((p) => p.price >= minPrice)
          .toList();

      expect(premiumProducts.length, 2); // Baby Stroller and Baby Monitor
    });

    test('Rating filter - highly rated products', () {
      const minRating = 4.5;
      final highlyRated = mockProducts
          .where((p) => p.rating >= minRating)
          .toList();

      expect(highlyRated.length, 4);
      expect(highlyRated.every((p) => p.rating >= minRating), true);
    });

    test('Pagination simulation - first page', () {
      const pageSize = 2;
      const page = 0;

      final paginatedProducts = mockProducts
          .skip(page * pageSize)
          .take(pageSize)
          .toList();

      expect(paginatedProducts.length, 2);
      expect(paginatedProducts.first.id, 'prod1');
    });

    test('Pagination simulation - second page', () {
      const pageSize = 2;
      const page = 1;

      final paginatedProducts = mockProducts
          .skip(page * pageSize)
          .take(pageSize)
          .toList();

      expect(paginatedProducts.length, 2);
      expect(paginatedProducts.first.id, 'prod3');
    });

    test('Category display order', () {
      final sortedCategories = List<ProductCategoryModel>.from(mockCategories)
        ..sort(
          (a, b) => (a.displayOrder ?? 999).compareTo(b.displayOrder ?? 999),
        );

      expect(sortedCategories.first.name, 'Baby Care');
      expect(sortedCategories.last.name, 'Health');
    });

    test('Product count per category', () {
      final categoryProductCount = <String, int>{};

      for (final product in mockProducts.where((p) => p.isAvailable)) {
        categoryProductCount[product.categoryId] =
            (categoryProductCount[product.categoryId] ?? 0) + 1;
      }

      expect(categoryProductCount['cat1'], 2); // Baby Care
      expect(categoryProductCount['cat2'], 1); // Maternity
      expect(categoryProductCount['cat3'], 1); // Health
    });

    test('Search with special characters', () {
      const query = '@#\$%';
      final results = mockProducts
          .where(
            (p) => p.productName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      expect(results, isEmpty);
    });

    test('Complex search scenario - multiple criteria', () {
      // Search for baby products, in Baby Care category, under \$200, available
      const query = 'baby';
      const categoryId = 'cat1';
      const maxPrice = 200.0;

      final results = mockProducts
          .where((p) => p.isAvailable)
          .where((p) => p.categoryId == categoryId)
          .where(
            (p) => p.productName.toLowerCase().contains(query.toLowerCase()),
          )
          .where((p) => p.price <= maxPrice)
          .toList();

      expect(results.length, 1); // Only Baby Diaper Pack matches all criteria
      expect(results.first.productName, 'Baby Diaper Pack');
    });

    test('Popular products - by reviews count', () {
      const minReviews = 100;
      final popular =
          mockProducts.where((p) => p.reviewsCount >= minReviews).toList()
            ..sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));

      expect(popular.length, 3);
      expect(popular.first.productName, 'Baby Diaper Pack'); // 200 reviews
    });

    test('Best deals - highest discount percentage', () {
      final deals =
          mockProducts
              .where(
                (p) =>
                    p.discountPercentage != null && p.discountPercentage! > 0,
              )
              .toList()
            ..sort(
              (a, b) => (b.discountPercentage ?? 0).compareTo(
                a.discountPercentage ?? 0,
              ),
            );

      expect(deals.isNotEmpty, true);
      expect(deals.first.discountPercentage, 25);
    });

    test('Empty category has no products', () {
      const nonExistentCategory = 'cat999';
      final results = mockProducts
          .where((p) => p.categoryId == nonExistentCategory)
          .toList();

      expect(results, isEmpty);
    });

    test('Product with multiple images', () {
      final productWithImages = mockProducts.firstWhere(
        (p) => p.imageUrls.length > 1,
      );

      expect(productWithImages.productName, 'Baby Stroller Premium');
      expect(productWithImages.imageUrls.length, 2);
    });

    test('Products without discount have null original price', () {
      final noDiscount = mockProducts
          .where((p) => p.originalPrice == null)
          .toList();

      expect(noDiscount.length, 4);
    });
  });
}
