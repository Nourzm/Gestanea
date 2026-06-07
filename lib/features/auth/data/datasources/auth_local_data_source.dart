import 'dart:async';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class AuthLocalDataSource {
  static const int _iterations = 10000;
  static const int _saltBytes = 16;

  final DatabaseHelper _dbHelper;
  final Random _rng = Random.secure();

  AuthLocalDataSource(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  Future<void> ensureAuthTableExists() async {
    final db = await _db;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS auth_credentials (
        user_id TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        salt TEXT NOT NULL DEFAULT '',
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

    final salt = _generateSalt();
    final passwordHash = _hashPassword(password, salt);

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
        'salt': salt,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
    });
  }

  /// Insert (or replace) a user row WITHOUT touching auth_credentials.
  /// Used when Supabase Auth is the source of truth and the local row is
  /// just a profile cache.
  Future<void> createUserMirror(UserModel user) async {
    final db = await _db;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

    // Fetch the user + their salt, then verify the hash in Dart to avoid
    // leaking timing info that a raw SQL equality comparison would expose.
    final result = await db.rawQuery(
      '''
      SELECT u.*, a.password AS _stored_hash, a.salt AS _stored_salt
      FROM users u
      INNER JOIN auth_credentials a ON u.id = a.user_id
      WHERE u.email = ?
      LIMIT 1
    ''',
      [email],
    );

    if (result.isEmpty) return null;

    final row = result.first;
    final storedHash = row['_stored_hash'] as String? ?? '';
    final storedSalt = row['_stored_salt'] as String? ?? '';
    if (storedSalt.isEmpty) {
      // Legacy/empty-salt account from older schema — refuse login so the
      // user re-registers under the new hashing scheme.
      return null;
    }
    final candidateHash = _hashPassword(password, storedSalt);
    if (!_constantTimeEquals(candidateHash, storedHash)) return null;

    final userMap = Map<String, Object?>.from(row)
      ..remove('_stored_hash')
      ..remove('_stored_salt');
    return UserModel.fromMap(userMap);
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

  String _generateSalt() {
    final bytes = List<int>.generate(_saltBytes, (_) => _rng.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hashPassword(String password, String salt) {
    // Iterated SHA-256 with salt. Not as strong as bcrypt/argon2, but a
    // significant upgrade over single-round unsalted SHA-256 and uses only
    // the `crypto` package already in pubspec.
    List<int> current = utf8.encode('$salt:$password');
    for (var i = 0; i < _iterations; i++) {
      current = sha256.convert(current).bytes;
    }
    return base64Url.encode(current);
  }

  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
