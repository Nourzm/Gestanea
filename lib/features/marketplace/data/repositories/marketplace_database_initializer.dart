import 'package:gestanea/features/marketplace/data/repositories/marketplace_local_data_source.dart';
import 'package:gestanea/features/marketplace/data/datasources/mock_marketplace_data.dart';

/// Helper class to initialize marketplace database with mock data
class MarketplaceDatabaseInitializer {
  final MarketplaceLocalDataSource _dataSource = MarketplaceLocalDataSource();

  /// Initialize database with mock data if it's empty
  Future<void> initializeWithMockData() async {
    try {
      final hasCategories = await _dataSource.hasCategories();
      final hasProducts = await _dataSource.hasProducts();

      // Only add mock data if database is empty
      if (!hasCategories) {
        final mockCategories = MockMarketplaceData.getCategories();
        await _dataSource.insertCategories(mockCategories);
      }

      if (!hasProducts) {
        final mockProducts = MockMarketplaceData.getProducts();
        await _dataSource.insertProducts(mockProducts);

        // Add variants, specs, and reviews for each product
        for (var product in mockProducts) {
          final variants = MockMarketplaceData.getProductVariants(product.id);
          await _dataSource.insertProductVariants(variants);

          final specs = MockMarketplaceData.getProductSpecs(product.id);
          await _dataSource.insertProductSpecs(specs);

          final reviews = MockMarketplaceData.getProductReviews(product.id);
          await _dataSource.insertProductReviews(reviews);
        }
      }
    } catch (e) {
      print('Error initializing marketplace database: $e');
      rethrow;
    }
  }

  /// Clear all data and reinitialize with mock data
  Future<void> resetWithMockData() async {
    try {
      await _dataSource.clearAllMarketplaceData();
      await initializeWithMockData();
    } catch (e) {
      print('Error resetting marketplace database: $e');
      rethrow;
    }
  }

  /// Get all categories from database
  Future<dynamic> getCategories() async {
    try {
      return await _dataSource.getCategories();
    } catch (e) {
      print('Error getting categories: $e');
      rethrow;
    }
  }

  /// Get all products from database
  Future<dynamic> getProducts() async {
    try {
      return await _dataSource.getProducts();
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }
}
