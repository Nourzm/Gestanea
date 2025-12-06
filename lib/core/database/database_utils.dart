import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/user_model.dart';

/// Utility functions for database operations
class DatabaseUtils {
  static final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Ensure a user exists in the database before inserting related data
  /// This prevents foreign key constraint errors
  static Future<void> ensureUserExists(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) {
      // Create mock user
      final user = UserModel(
        id: userId,
        email: 'mock_$userId@gestanea.com',
        name: 'Mock User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await db.insert('users', user.toMap());
      print('Created mock user: $userId');
    }
  }

  /// Check if a user exists in the database
  static Future<bool> userExists(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Get or create a user
  static Future<UserModel> getOrCreateUser(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      final user = UserModel(
        id: userId,
        email: 'mock_$userId@gestanea.com',
        name: 'Mock User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await db.insert('users', user.toMap());
      return user;
    }
  }
}
