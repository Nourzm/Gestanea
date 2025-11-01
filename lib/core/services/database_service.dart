import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pregnancy_baby_app/core/constants/app_strings.dart';
import 'package:pregnancy_baby_app/core/exceptions/app_exceptions.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._internal();

  DatabaseService._internal();

  factory DatabaseService() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, AppStrings.dbName);

      return await openDatabase(
        path,
        version: AppStrings.dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw AppDatabaseException('Failed to initialize database: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables here
    // Example: User table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        name TEXT,
        phone TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Example: Pregnancy tracking table
    await db.execute('''
      CREATE TABLE pregnancy_tracking (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        lmp_date TEXT NOT NULL,
        due_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Example: Baby profile table
    await db.execute('''
      CREATE TABLE baby_profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        gender TEXT,
        weight REAL,
        height REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Example: Health logs table
    await db.execute('''
      CREATE TABLE health_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        baby_id INTEGER,
        log_type TEXT NOT NULL,
        log_date TEXT NOT NULL,
        value TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (baby_id) REFERENCES baby_profiles (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE users ADD COLUMN profile_image TEXT');
    // }
  }

  // Generic CRUD operations

  /// Insert a record
  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.insert(table, data);
    } catch (e) {
      throw AppDatabaseException.insertFailed(table);
    }
  }

  /// Query records
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await database;
      return await db.query(
        table,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw AppDatabaseException.queryFailed();
    }
  }

  /// Get a single record by ID
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    try {
      final db = await database;
      final results = await db.query(
        table,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw AppDatabaseException.queryFailed();
    }
  }

  /// Update a record
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw AppDatabaseException.updateFailed(table);
    }
  }

  /// Delete a record
  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw AppDatabaseException.deleteFailed(table);
    }
  }

  /// Delete by ID
  Future<int> deleteById(String table, int id) async {
    return await delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Execute raw query
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    try {
      final db = await database;
      return await db.rawQuery(sql, arguments);
    } catch (e) {
      throw AppDatabaseException.queryFailed();
    }
  }

  /// Execute raw insert/update/delete
  Future<int> rawExecute(String sql, [List<dynamic>? arguments]) async {
    try {
      final db = await database;
      await db.execute(sql, arguments);
      return 1;
    } catch (e) {
      throw AppDatabaseException('Raw execute failed: $e');
    }
  }

  /// Clear all data from a table
  Future<void> clearTable(String table) async {
    try {
      final db = await database;
      await db.delete(table);
    } catch (e) {
      throw AppDatabaseException('Failed to clear table $table: $e');
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete database
  Future<void> deleteDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, AppStrings.dbName);
      await databaseFactory.deleteDatabase(path);
      _database = null;
    } catch (e) {
      throw AppDatabaseException('Failed to delete database: $e');
    }
  }
}