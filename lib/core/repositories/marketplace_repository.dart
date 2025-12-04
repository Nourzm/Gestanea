import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/product_category.dart';
import 'package:gestanea/core/models/product.dart';
import 'package:gestanea/core/models/product_variant.dart';
import 'package:gestanea/core/models/product_spec.dart';
import 'package:gestanea/core/models/product_review.dart';
import 'package:gestanea/core/models/cart_item.dart';
import 'package:gestanea/core/models/order.dart';
import 'package:gestanea/core/models/order_item.dart';

class MarketplaceRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Categories
  Future<Result<List<ProductCategory>>> getCategories() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('product_categories', orderBy: 'name ASC');
      final categories = maps.map((m) => ProductCategory.fromMap(m)).toList();
      return Result.success(categories);
    } catch (e) {
      return Result.failure('Failed to get categories: ${e.toString()}');
    }
  }

  // Products
  Future<Result<List<Product>>> getAllProducts() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('products', orderBy: 'created_at DESC');
      final products = maps.map((m) => Product.fromMap(m)).toList();
      return Result.success(products);
    } catch (e) {
      return Result.failure('Failed to get products: ${e.toString()}');
    }
  }

  Future<Result<List<Product>>> getProductsByCategory(String categoryId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'products',
        where: 'category_id = ?',
        whereArgs: [categoryId],
        orderBy: 'created_at DESC',
      );
      final products = maps.map((m) => Product.fromMap(m)).toList();
      return Result.success(products);
    } catch (e) {
      return Result.failure('Failed to get products by category: ${e.toString()}');
    }
  }

  Future<Result<Product>> getProduct(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.failure('Product not found');
      return Result.success(Product.fromMap(maps.first));
    } catch (e) {
      return Result.failure('Failed to get product: ${e.toString()}');
    }
  }

  Future<Result<List<Product>>> searchProducts(String query) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'products',
        where: 'name LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'created_at DESC',
      );
      final products = maps.map((m) => Product.fromMap(m)).toList();
      return Result.success(products);
    } catch (e) {
      return Result.failure('Failed to search products: ${e.toString()}');
    }
  }

  // Product Variants
  Future<Result<List<ProductVariant>>> getProductVariants(String productId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'product_variants',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      final variants = maps.map((m) => ProductVariant.fromMap(m)).toList();
      return Result.success(variants);
    } catch (e) {
      return Result.failure('Failed to get product variants: ${e.toString()}');
    }
  }

  // Product Specs
  Future<Result<List<ProductSpec>>> getProductSpecs(String productId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'product_specs',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      final specs = maps.map((m) => ProductSpec.fromMap(m)).toList();
      return Result.success(specs);
    } catch (e) {
      return Result.failure('Failed to get product specs: ${e.toString()}');
    }
  }

  // Product Reviews
  Future<Result<List<ProductReview>>> getProductReviews(String productId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'product_reviews',
        where: 'product_id = ?',
        whereArgs: [productId],
        orderBy: 'created_at DESC',
      );
      final reviews = maps.map((m) => ProductReview.fromMap(m)).toList();
      return Result.success(reviews);
    } catch (e) {
      return Result.failure('Failed to get product reviews: ${e.toString()}');
    }
  }

  // Cart
  Future<Result<List<CartItem>>> getCartItems(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'cart_items',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      final items = maps.map((m) => CartItem.fromMap(m)).toList();
      return Result.success(items);
    } catch (e) {
      return Result.failure('Failed to get cart items: ${e.toString()}');
    }
  }

  Future<Result<CartItem>> addToCart(CartItem item) async {
    try {
      final db = await _dbHelper.database;
      
      // Check if item already exists
      final existing = await db.query(
        'cart_items',
        where: 'user_id = ? AND product_id = ? AND selected_color = ? AND selected_size = ?',
        whereArgs: [item.userId, item.productId, item.selectedColor, item.selectedSize],
      );

      if (existing.isNotEmpty) {
        // Update quantity
        final existingItem = CartItem.fromMap(existing.first);
        final updated = CartItem(
          id: existingItem.id,
          userId: existingItem.userId,
          productId: existingItem.productId,
          quantity: existingItem.quantity + item.quantity,
          selectedColor: existingItem.selectedColor,
          selectedSize: existingItem.selectedSize,
          createdAt: existingItem.createdAt,
        );
        await db.update('cart_items', updated.toMap(), where: 'id = ?', whereArgs: [updated.id]);
        return Result.success(updated, 'Cart updated');
      } else {
        await db.insert('cart_items', item.toMap());
        return Result.success(item, 'Added to cart');
      }
    } catch (e) {
      return Result.failure('Failed to add to cart: ${e.toString()}');
    }
  }

  Future<Result<CartItem>> updateCartItem(CartItem item) async {
    try {
      final db = await _dbHelper.database;
      await db.update('cart_items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
      return Result.success(item, 'Cart item updated');
    } catch (e) {
      return Result.failure('Failed to update cart item: ${e.toString()}');
    }
  }

  Future<Result<bool>> removeFromCart(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('cart_items', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Removed from cart');
    } catch (e) {
      return Result.failure('Failed to remove from cart: ${e.toString()}');
    }
  }

  Future<Result<bool>> clearCart(String userId) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('cart_items', where: 'user_id = ?', whereArgs: [userId]);
      return Result.success(true, 'Cart cleared');
    } catch (e) {
      return Result.failure('Failed to clear cart: ${e.toString()}');
    }
  }

  // Orders
  Future<Result<List<Order>>> getOrders(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'orders',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      final orders = maps.map((m) => Order.fromMap(m)).toList();
      return Result.success(orders);
    } catch (e) {
      return Result.failure('Failed to get orders: ${e.toString()}');
    }
  }

  Future<Result<Order>> getOrder(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('orders', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.failure('Order not found');
      return Result.success(Order.fromMap(maps.first));
    } catch (e) {
      return Result.failure('Failed to get order: ${e.toString()}');
    }
  }

  Future<Result<List<OrderItem>>> getOrderItems(String orderId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );
      final items = maps.map((m) => OrderItem.fromMap(m)).toList();
      return Result.success(items);
    } catch (e) {
      return Result.failure('Failed to get order items: ${e.toString()}');
    }
  }

  Future<Result<Order>> createOrder(Order order, List<OrderItem> items) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('orders', order.toMap());
      for (final item in items) {
        await db.insert('order_items', item.toMap());
      }
      return Result.success(order, 'Order created successfully');
    } catch (e) {
      return Result.failure('Failed to create order: ${e.toString()}');
    }
  }

  Future<Result<Order>> updateOrder(Order order) async {
    try {
      final db = await _dbHelper.database;
      final updated = Order(
        id: order.id,
        userId: order.userId,
        orderNumber: order.orderNumber,
        totalAmount: order.totalAmount,
        status: order.status,
        paymentMethod: order.paymentMethod,
        shippingAddress: order.shippingAddress,
        createdAt: order.createdAt,
        updatedAt: DateTime.now(),
      );
      await db.update('orders', updated.toMap(), where: 'id = ?', whereArgs: [order.id]);
      return Result.success(updated, 'Order updated');
    } catch (e) {
      return Result.failure('Failed to update order: ${e.toString()}');
    }
  }
}
