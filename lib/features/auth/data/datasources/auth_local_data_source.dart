import 'dart:async';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class AuthLocalDataSource {
  final DatabaseHelper _dbHelper;

  AuthLocalDataSource(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  Future<void> ensureAuthTableExists() async {
    final db = await _db;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS auth_credentials (
        user_id TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> createUserWithPassword({
    required UserModel user,
    required String password,
  }) async {
    final db = await _db;
    await ensureAuthTableExists();

    final passwordHash = _hashPassword(password);

    await db.transaction((txn) async {
      // Insert user
      await txn.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      // Insert credentials
      await txn.insert('auth_credentials', {
        'user_id': user.id,
        'password': passwordHash,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
    });
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _db;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<UserModel?> getUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    final db = await _db;
    await ensureAuthTableExists();

    final passwordHash = _hashPassword(password);

    final result = await db.rawQuery(
      '''
      SELECT u.*
      FROM users u
      INNER JOIN auth_credentials a ON u.id = a.user_id
      WHERE u.email = ? AND a.password = ?
      LIMIT 1
    ''',
      [email, passwordHash],
    );

    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await _db;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<bool> emailExists(String email) async {
    final db = await _db;
    final maps = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  /// Update an existing user record in the users table.
  /// This method guarantees updated_at is set to the provided value in the model.
  Future<void> updateUser(UserModel user) async {
    final db = await _db;
    final values = user.toMap();
    // Ensure updated_at is present; user.toMap should include it.
    if (!values.containsKey('updated_at') || values['updated_at'] == null) {
      values['updated_at'] = DateTime.now().toIso8601String();
    }

    await db.update(
      'users',
      values,
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Create a user without password (for OTP-based authentication)
  Future<void> createUser(UserModel user) async {
    final db = await _db;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Update password for a user
  Future<void> updatePassword({
    required String userId,
    required String newPassword,
  }) async {
    final db = await _db;
    await ensureAuthTableExists();

    final passwordHash = _hashPassword(newPassword);

    await db.update(
      'auth_credentials',
      {'password': passwordHash},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
