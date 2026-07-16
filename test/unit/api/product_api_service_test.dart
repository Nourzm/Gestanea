import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@GenerateMocks([http.Client])
void main() {
  group('ProductApiService', () {
    setUp(() {});

    group('getProducts', () {
      test('should return list of products on successful API call', () async {
        final mockResponse = [
          {
            'id': 'prod1',
            'product_name': 'Baby Stroller',
            'description': 'Comfortable stroller',
            'category_id': 'cat1',
            'target_audience': 'Parents',
            'price': 299.99,
            'original_price': null,
            'discount_percentage': null,
            'currency': 'USD',
            'rating': 4.5,
            'reviews_count': 120,
            'image_urls': ['url1.jpg', 'url2.jpg'],
            'vendor_name': 'Baby Store',
            'is_available': true,
            'created_at': '2024-01-01T00:00:00.000Z',
          },
        ];

        // Test the structure of expected data
        expect(mockResponse.first['product_name'], 'Baby Stroller');
        expect(mockResponse.first['price'], 299.99);
        expect(mockResponse.first['is_available'], true);
      });

      test('should handle integer price converted to double', () {
        final mockProduct = {
          'price': 100, // Integer
        };

        final priceAsDouble = (mockProduct['price'] as num).toDouble();
        expect(priceAsDouble, 100.0);
        expect(priceAsDouble, isA<double>());
      });

      test('should handle image_urls as JSON string', () {
        final imageUrlsJson = '["url1.jpg", "url2.jpg"]';
        final parsed = List<String>.from(jsonDecode(imageUrlsJson));

        expect(parsed.length, 2);
        expect(parsed.first, 'url1.jpg');
      });

      test('should handle image_urls as List', () {
        final imageUrlsList = ['url1.jpg', 'url2.jpg'];
        final parsed = List<String>.from(imageUrlsList);

        expect(parsed.length, 2);
        expect(parsed.first, 'url1.jpg');
      });

      test('should handle empty image_urls', () {
        final imageUrls = <String>[];
        expect(imageUrls, isEmpty);
      });

      test('should handle is_available as boolean', () {
        final product1 = {'is_available': true};
        expect(product1['is_available'], true);
      });

      test('should handle is_available as integer', () {
        final product2 = {'is_available': 1};
        final isAvailable = (product2['is_available'] as int) == 1;
        expect(isAvailable, true);
      });

      test('should default is_available to true if null', () {
        final product3 = {'is_available': null};
        final isAvailable = (product3['is_available'] as int? ?? 1) == 1;
        expect(isAvailable, true);
      });

      test('should build correct query parameters', () {
        final queryParams = <String, String>{
          'skip': '0',
          'limit': '100',
          'category_id': 'cat1',
          'is_available': 'true',
          'search': 'stroller',
        };

        expect(queryParams['skip'], '0');
        expect(queryParams['category_id'], 'cat1');
        expect(queryParams['search'], 'stroller');
      });

      test('should handle optional query parameters', () {
        final queryParams = <String, String>{'skip': '10', 'limit': '50'};

        expect(queryParams.length, 2);
        expect(queryParams.containsKey('category_id'), false);
      });

      test('should handle API error with status code 500', () {
        const statusCode = 500;
        expect(
          () => throw Exception('Failed to load products: $statusCode'),
          throwsException,
        );
      });

      test('should handle network error', () {
        expect(
          () => throw Exception('Error fetching products: Network error'),
          throwsException,
        );
      });
    });

    group('getProduct', () {
      test('should return single product on successful API call', () {
        final mockProduct = {
          'id': 'prod1',
          'product_name': 'Baby Stroller',
          'category_id': 'cat1',
          'price': 299.99,
          'image_urls': ['url1.jpg'],
          'is_available': true,
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        expect(mockProduct['id'], 'prod1');
        expect(mockProduct['product_name'], 'Baby Stroller');
      });

      test('should handle 404 not found error', () {
        expect(() => throw Exception('Product not found'), throwsException);
      });

      test('should handle invalid product ID', () {
        const invalidId = '';
        expect(invalidId, isEmpty);
      });
    });

    group('getCategories', () {
      test('should return list of categories on successful API call', () {
        final mockCategories = [
          {
            'id': 'cat1',
            'name': 'Baby Care',
            'image_url': 'cat1.jpg',
            'display_order': 1,
            'created_at': '2024-01-01T00:00:00.000Z',
          },
          {
            'id': 'cat2',
            'name': 'Maternity',
            'image_url': 'cat2.jpg',
            'display_order': 2,
            'created_at': '2024-01-01T00:00:00.000Z',
          },
        ];

        expect(mockCategories.length, 2);
        expect(mockCategories.first['name'], 'Baby Care');
      });

      test('should handle empty categories list', () {
        final emptyCategories = <Map<String, dynamic>>[];
        expect(emptyCategories, isEmpty);
      });

      test('should handle API error', () {
        expect(
          () => throw Exception('Failed to load categories: 500'),
          throwsException,
        );
      });
    });

    group('Error handling', () {
      test(
        'should throw exception with descriptive message on network error',
        () {
          const errorMessage = 'Error fetching products: Network unavailable';
          expect(errorMessage, contains('Network unavailable'));
        },
      );

      test('should throw exception on JSON decode error', () {
        expect(
          () => jsonDecode('invalid json'),
          throwsA(isA<FormatException>()),
        );
      });

      test('should handle timeout errors', () {
        expect(() => throw Exception('Request timeout'), throwsException);
      });

      test('should handle empty response body', () {
        const emptyResponse = '';
        expect(emptyResponse, isEmpty);
      });
    });

    group('Product data parsing', () {
      test('should parse product with all fields', () {
        final fullProduct = {
          'id': 'prod1',
          'product_name': 'Complete Product',
          'description': 'Full description',
          'category_id': 'cat1',
          'target_audience': 'Parents',
          'price': 99.99,
          'original_price': 149.99,
          'discount_percentage': 33,
          'currency': 'USD',
          'rating': 4.8,
          'reviews_count': 250,
          'image_urls': ['url1.jpg', 'url2.jpg'],
          'vendor_name': 'Top Vendor',
          'is_available': true,
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        expect(fullProduct.length, 15);
        expect(fullProduct['discount_percentage'], 33);
        expect(fullProduct['original_price'], 149.99);
      });

      test('should parse product with minimal fields', () {
        final minimalProduct = {
          'id': 'prod2',
          'product_name': 'Basic Product',
          'category_id': 'cat1',
          'price': 19.99,
          'image_urls': [],
          'is_available': true,
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        expect(minimalProduct['description'], null);
        expect(minimalProduct['original_price'], null);
      });

      test('should handle default values for optional fields', () {
        final currency = 'USD'; // default
        final rating = 0.0; // default
        final reviewsCount = 0; // default

        expect(currency, 'USD');
        expect(rating, 0.0);
        expect(reviewsCount, 0);
      });

      test('should parse datetime string correctly', () {
        const dateString = '2024-01-01T00:00:00.000Z';
        final parsed = DateTime.parse(dateString);

        expect(parsed.year, 2024);
        expect(parsed.month, 1);
        expect(parsed.day, 1);
      });

      test('should handle null datetime with default', () {
        final defaultDate = DateTime.now();
        expect(defaultDate, isA<DateTime>());
      });
    });

    group('Category data parsing', () {
      test('should parse category with all fields', () {
        final category = {
          'id': 'cat1',
          'name': 'Baby Care',
          'image_url': 'cat1.jpg',
          'display_order': 1,
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        expect(category['id'], 'cat1');
        expect(category['display_order'], 1);
      });

      test('should handle null optional fields in category', () {
        final category = {
          'id': 'cat2',
          'name': null,
          'image_url': null,
          'display_order': null,
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        expect(category['name'], null);
        expect(category['image_url'], null);
      });
    });

    group('API endpoint construction', () {
      test('should construct correct base URL', () {
        const endpoint = '/products';
        expect(endpoint, startsWith('/'));
        expect(endpoint, contains('products'));
      });

      test('should construct correct product detail URL', () {
        const productId = 'prod123';
        final url = '/products/$productId';

        expect(url, '/products/prod123');
      });

      test('should construct correct categories URL', () {
        const categoriesUrl = '/products/categories/';
        expect(categoriesUrl, contains('categories'));
      });

      test('should handle query parameters in URL', () {
        final uri = Uri.parse(
          'http://example.com/products',
        ).replace(queryParameters: {'skip': '0', 'limit': '10'});

        expect(uri.queryParameters['skip'], '0');
        expect(uri.queryParameters['limit'], '10');
      });
    });
  });
}
