import 'package:flutter_test/flutter_test.dart';
import 'package:gestanea/core/database/models/cart_item_model.dart';

void main() {
  group('CartItemModel', () {
    late DateTime testDate;
    late CartItemModel testCartItem;

    setUp(() {
      testDate = DateTime(2024, 1, 1, 10, 30);
      testCartItem = CartItemModel(
        id: 'cart123',
        userId: 'user123',
        productId: 'prod123',
        productName: 'Baby Stroller',
        productPrice: 299.99,
        variantColor: 'Blue',
        variantSize: 'Standard',
        quantity: 2,
        addedAt: testDate,
      );
    });

    test('toMap should convert model to map correctly', () {
      final map = testCartItem.toMap();

      expect(map['id'], 'cart123');
      expect(map['user_id'], 'user123');
      expect(map['product_id'], 'prod123');
      expect(map['product_name'], 'Baby Stroller');
      expect(map['product_price'], 299.99);
      expect(map['variant_color'], 'Blue');
      expect(map['variant_size'], 'Standard');
      expect(map['quantity'], 2);
      expect(map['added_at'], testDate.toIso8601String());
    });

    test('fromMap should create model from map correctly', () {
      final map = {
        'id': 'cart456',
        'user_id': 'user456',
        'product_id': 'prod456',
        'product_name': 'Diaper Bag',
        'product_price': 49.99,
        'variant_color': 'Pink',
        'variant_size': 'Large',
        'quantity': 1,
        'added_at': '2024-03-15T14:20:00.000',
      };

      final cartItem = CartItemModel.fromMap(map);

      expect(cartItem.id, 'cart456');
      expect(cartItem.userId, 'user456');
      expect(cartItem.productId, 'prod456');
      expect(cartItem.productName, 'Diaper Bag');
      expect(cartItem.productPrice, 49.99);
      expect(cartItem.variantColor, 'Pink');
      expect(cartItem.variantSize, 'Large');
      expect(cartItem.quantity, 1);
    });

    test('should handle cart item without variants', () {
      final simpleItem = CartItemModel(
        id: 'cart789',
        userId: 'user789',
        productId: 'prod789',
        productName: 'Baby Wipes',
        productPrice: 12.50,
        addedAt: testDate,
      );

      final map = simpleItem.toMap();

      expect(map['variant_color'], null);
      expect(map['variant_size'], null);
      expect(map['quantity'], 1); // Default quantity

      final recovered = CartItemModel.fromMap(map);
      expect(recovered.variantColor, null);
      expect(recovered.variantSize, null);
      expect(recovered.quantity, 1);
    });

    test('should default quantity to 1 when not provided in fromMap', () {
      final map = {
        'id': 'cart000',
        'user_id': 'user000',
        'product_id': 'prod000',
        'product_name': 'Test Product',
        'product_price': 10.0,
        'variant_color': null,
        'variant_size': null,
        'added_at': '2024-01-01T00:00:00.000',
      };

      final cartItem = CartItemModel.fromMap(map);
      expect(cartItem.quantity, 1);
    });

    test('copyWith should create new instance with updated fields', () {
      final updated = testCartItem.copyWith(quantity: 5, productPrice: 249.99);

      expect(updated.id, testCartItem.id);
      expect(updated.quantity, 5);
      expect(updated.productPrice, 249.99);
      expect(updated.productName, testCartItem.productName);
    });

    test('copyWith should keep original values when no changes provided', () {
      final copy = testCartItem.copyWith();

      expect(copy.id, testCartItem.id);
      expect(copy.userId, testCartItem.userId);
      expect(copy.quantity, testCartItem.quantity);
      expect(copy.productPrice, testCartItem.productPrice);
    });

    test('toMap and fromMap should be reversible', () {
      final map = testCartItem.toMap();
      final recovered = CartItemModel.fromMap(map);

      expect(recovered.id, testCartItem.id);
      expect(recovered.productName, testCartItem.productName);
      expect(recovered.productPrice, testCartItem.productPrice);
      expect(recovered.quantity, testCartItem.quantity);
      expect(recovered.variantColor, testCartItem.variantColor);
    });

    test('should handle large quantities', () {
      final bulkItem = CartItemModel(
        id: 'cart999',
        userId: 'user999',
        productId: 'prod999',
        productName: 'Diapers Pack',
        productPrice: 35.00,
        quantity: 10,
        addedAt: testDate,
      );

      final map = bulkItem.toMap();
      final recovered = CartItemModel.fromMap(map);

      expect(recovered.quantity, 10);
    });

    test('should handle decimal prices correctly', () {
      final preciseItem = CartItemModel(
        id: 'c1',
        userId: 'u1',
        productId: 'p1',
        productName: 'Test',
        productPrice: 99.95,
        addedAt: testDate,
      );

      final map = preciseItem.toMap();
      final recovered = CartItemModel.fromMap(map);

      expect(recovered.productPrice, 99.95);
    });

    test('should handle integer prices converted to double', () {
      final map = {
        'id': 'c2',
        'user_id': 'u2',
        'product_id': 'p2',
        'product_name': 'Integer Price Product',
        'product_price': 50, // Integer, not double
        'variant_color': null,
        'variant_size': null,
        'quantity': 1,
        'added_at': '2024-01-01T00:00:00.000',
      };

      final cartItem = CartItemModel.fromMap(map);
      expect(cartItem.productPrice, 50.0);
      expect(cartItem.productPrice, isA<double>());
    });
  });
}
