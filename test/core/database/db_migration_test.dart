import 'package:flutter_test/flutter_test.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Regression tests for the v6 -> v7 migration.
///
/// The original v7 step ran a bare
/// `ALTER TABLE auth_credentials ADD COLUMN salt ...`, but auth_credentials
/// is created lazily on first signup — devices where nobody had signed up
/// had no such table, the ALTER threw, openDatabase failed, and every DB
/// call in the app crashed. These tests pin the fixed behaviour for both
/// upgrade shapes.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  /// Minimal v6 fixture: only what the v7 step interacts with.
  Future<Database> openV6({required bool withAuthTable}) async {
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: 6,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            email TEXT UNIQUE NOT NULL,
            name TEXT NOT NULL
          )
        ''');
        if (withAuthTable) {
          // Old unsalted shape, as created by the pre-v7 app.
          await db.execute('''
            CREATE TABLE auth_credentials (
              user_id TEXT PRIMARY KEY,
              password TEXT NOT NULL,
              FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
            )
          ''');
        }
      },
    );
    return db;
  }

  Future<bool> hasSaltColumn(Database db) async {
    final cols = await db.rawQuery("PRAGMA table_info('auth_credentials')");
    return cols.any((c) => c['name'] == 'salt');
  }

  test('v6 -> v7 succeeds when auth_credentials never existed', () async {
    final db = await openV6(withAuthTable: false);
    // Must not throw — this exact call used to crash with "no such table".
    await DatabaseHelper.upgradeSchema(db, 6, DatabaseHelper.schemaVersion);
    expect(await hasSaltColumn(db), isTrue);
    await db.close();
  });

  test('v6 -> v7 adds salt to a pre-existing unsalted table', () async {
    final db = await openV6(withAuthTable: true);
    await db.insert('users', {'id': 'u1', 'email': 'a@b.c', 'name': 'A'});
    await db.insert('auth_credentials', {
      'user_id': 'u1',
      'password': 'legacy-hash',
    });

    await DatabaseHelper.upgradeSchema(db, 6, DatabaseHelper.schemaVersion);

    expect(await hasSaltColumn(db), isTrue);
    // Legacy row survives with an empty salt (login layer rejects it,
    // forcing re-registration, but the migration must not lose the row).
    final rows = await db.query('auth_credentials');
    expect(rows, hasLength(1));
    expect(rows.first['salt'], '');
    await db.close();
  });

  test('migration is idempotent if re-run after a prior crash', () async {
    // Simulates the self-healing path: a device whose first v7 attempt
    // failed mid-transaction retries the same migration on next launch.
    final db = await openV6(withAuthTable: false);
    await DatabaseHelper.upgradeSchema(db, 6, DatabaseHelper.schemaVersion);
    await DatabaseHelper.upgradeSchema(db, 6, DatabaseHelper.schemaVersion);
    expect(await hasSaltColumn(db), isTrue);
    await db.close();
  });

  // ---- v8 (moods energy_level/sleep_quality) & v9 (pregnancies BMI cols) ----

  Future<Set<String>> columnsOf(Database db, String table) async {
    final cols = await db.rawQuery("PRAGMA table_info('$table')");
    return cols.map((c) => c['name'] as String).toSet();
  }

  /// Minimal v7 fixture. [withMoods]/[withPregnancies] simulate devices in
  /// different historical states (both tables only ever lived in
  /// createSchema, so upgraded devices may lack either).
  Future<Database> openV7({
    required bool withMoods,
    required bool withPregnancies,
  }) async {
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: 7,
      onCreate: (db, _) async {
        if (withMoods) {
          // Pre-v8 shape: no energy_level / sleep_quality.
          await db.execute('''
            CREATE TABLE moods (
              id TEXT PRIMARY KEY,
              user_id TEXT NOT NULL,
              mood TEXT NOT NULL,
              intensity INTEGER,
              notes TEXT,
              recorded_at TEXT,
              created_at TEXT
            )
          ''');
        }
        if (withPregnancies) {
          // Pre-v9 shape: no pre_pregnancy_weight / height_cm.
          await db.execute('''
            CREATE TABLE pregnancies (
              id TEXT PRIMARY KEY,
              user_id TEXT NOT NULL,
              lmp_date TEXT NOT NULL,
              due_date TEXT NOT NULL,
              is_active INTEGER DEFAULT 1
            )
          ''');
        }
      },
    );
    return db;
  }

  test(
    'v7 -> latest adds mood + pregnancy columns to existing tables',
    () async {
      final db = await openV7(withMoods: true, withPregnancies: true);
      await db.insert('pregnancies', {
        'id': 'p1',
        'user_id': 'u1',
        'lmp_date': '2026-01-01',
        'due_date': '2026-10-08',
      });

      await DatabaseHelper.upgradeSchema(db, 7, DatabaseHelper.schemaVersion);

      expect(
        await columnsOf(db, 'moods'),
        containsAll(<String>['energy_level', 'sleep_quality']),
      );
      expect(
        await columnsOf(db, 'pregnancies'),
        containsAll(<String>['pre_pregnancy_weight', 'height_cm']),
      );
      // Existing row survives with null new columns.
      final rows = await db.query('pregnancies');
      expect(rows, hasLength(1));
      expect(rows.first['pre_pregnancy_weight'], isNull);
      await db.close();
    },
  );

  test(
    'v7 -> latest succeeds when moods and pregnancies never existed',
    () async {
      // Regression: the original v9 step bare-ALTERed pregnancies and threw
      // "no such table" on devices that lacked it, bricking the upgrade.
      final db = await openV7(withMoods: false, withPregnancies: false);
      await DatabaseHelper.upgradeSchema(db, 7, DatabaseHelper.schemaVersion);
      expect(
        await columnsOf(db, 'moods'),
        containsAll(<String>['mood', 'energy_level', 'sleep_quality']),
      );
      expect(
        await columnsOf(db, 'pregnancies'),
        containsAll(<String>['lmp_date', 'pre_pregnancy_weight', 'height_cm']),
      );
      await db.close();
    },
  );

  test('v7 -> latest is idempotent on re-run', () async {
    final db = await openV7(withMoods: true, withPregnancies: true);
    await DatabaseHelper.upgradeSchema(db, 7, DatabaseHelper.schemaVersion);
    await DatabaseHelper.upgradeSchema(db, 7, DatabaseHelper.schemaVersion);
    expect(
      await columnsOf(db, 'pregnancies'),
      containsAll(<String>['pre_pregnancy_weight', 'height_cm']),
    );
    await db.close();
  });

  test('fresh createSchema produces all core tables', () async {
    final db = await openDatabase(inMemoryDatabasePath);
    await DatabaseHelper.createSchema(db, DatabaseHelper.schemaVersion);
    final tables = (await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    )).map((r) => r['name']).toSet();
    expect(
      tables,
      containsAll(<String>[
        'users',
        'pregnancies',
        'babies',
        'kick_counts',
        'measurements',
        'symptoms',
        'lab_results',
        'appointments',
        'medicines',
        'medicine_logged',
        'orders',
        'order_items',
      ]),
    );
    await db.close();
  });
}
