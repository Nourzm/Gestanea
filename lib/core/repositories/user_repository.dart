import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/user.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<User>> getUser(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return Result.failure('User not found');
      }

      return Result.success(User.fromMap(maps.first));
    } catch (e) {
      return Result.failure('Failed to get user: ${e.toString()}');
    }
  }

  Future<Result<User>> getUserByEmail(String email) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isEmpty) {
        return Result.failure('User not found');
      }

      return Result.success(User.fromMap(maps.first));
    } catch (e) {
      return Result.failure('Failed to get user: ${e.toString()}');
    }
  }

  Future<Result<User>> createUser(User user) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('users', user.toMap());
      return Result.success(user, 'User created successfully');
    } catch (e) {
      return Result.failure('Failed to create user: ${e.toString()}');
    }
  }

  Future<Result<User>> updateUser(User user) async {
    try {
      final db = await _dbHelper.database;
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      await db.update(
        'users',
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return Result.success(updatedUser, 'User updated successfully');
    } catch (e) {
      return Result.failure('Failed to update user: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteUser(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      return Result.success(true, 'User deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete user: ${e.toString()}');
    }
  }

  // Simulate login
  Future<Result<User>> login(String email, String password) async {
    try {
      // In a real app, you'd verify password
      final result = await getUserByEmail(email);
      if (result.isSuccess) {
        return Result.success(result.data!, 'Login successful');
      }
      return Result.failure('Invalid credentials');
    } catch (e) {
      return Result.failure('Login failed: ${e.toString()}');
    }
  }

  // Get current user (demo purposes - always returns Sara)
  Future<Result<User>> getCurrentUser() async {
    return getUserByEmail('sara@gestanea.app');
  }
}
