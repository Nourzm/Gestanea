import 'dart:async';
import 'package:bcrypt/bcrypt.dart';
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
        salt TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    // If the table existed before the salt column was introduced, ALTER it.
    // Mirrors the same guard in upgradeSchema (v7) for devices that bypassed it.
    final columns = await db.rawQuery("PRAGMA table_info('auth_credentials')");
    final hasSalt = columns.any((c) => c['name'] == 'salt');
    if (!hasSalt) {
      await db.execute(
        "ALTER TABLE auth_credentials ADD COLUMN salt TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  Future<void> createUserWithPassword({
    required UserModel user,
    required String password,
  }) async {
    final db = await _db;
    await ensureAuthTableExists();

    // BCrypt generates and embeds its own salt; cost factor 12 is the
    // current recommended minimum for interactive logins.
    final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(logRounds: 12));

    await db.transaction((txn) async {
      await txn.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      // salt column is kept for schema compatibility but bcrypt embeds its salt
      // in the hash, so we store an empty string there.
      await txn.insert('auth_credentials', {
        'user_id': user.id,
        'password': passwordHash,
        'salt': '',
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

    final result = await db.rawQuery(
      '''
      SELECT u.*, a.password AS _stored_hash
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

    // Only accept bcrypt hashes (start with $2). Accounts stored under the
    // old SHA-256 or empty-salt scheme are rejected so users re-register.
    if (!storedHash.startsWith('\$2')) return null;

    if (!BCrypt.checkpw(password, storedHash)) return null;

    final userMap = Map<String, Object?>.from(row)..remove('_stored_hash');
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

  Future<void> updateUser(UserModel user) async {
    final db = await _db;
    final values = user.toMap();
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
}
