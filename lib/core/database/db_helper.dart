import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  /// Single source of truth for the schema version. Tests reference this so
  /// they can never drift from what the app actually opens.
  @visibleForTesting
  static const int schemaVersion = 9;

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gestanea.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: schemaVersion,
      onCreate: createSchema,
      onUpgrade: upgradeSchema,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Static so the migration path can be exercised against an in-memory
  /// database in tests without touching the singleton.
  @visibleForTesting
  static Future<void> upgradeSchema(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE doctors ADD COLUMN wilaya TEXT');
    }
    if (oldVersion < 3) {
      // Old version - skip
    }
    if (oldVersion < 4) {
      // Drop and recreate measurements table without foreign key
      await db.execute('DROP TABLE IF EXISTS measurements');
      await db.execute('''
      CREATE TABLE measurements (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        weight REAL,
        heart_rate INTEGER,
        systolic INTEGER,
        diastolic INTEGER,
        recorded_at TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    }
    if (oldVersion < 5) {
      // Drop and recreate symptoms table without foreign key
      await db.execute('DROP TABLE IF EXISTS symptoms');
      await db.execute('''
      CREATE TABLE symptoms (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        symptom_name TEXT NOT NULL,
        severity TEXT,
        notes TEXT,
        recorded_at TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    }
    if (oldVersion < 6) {
      // Drop and recreate lab_results table
      await db.execute('DROP TABLE IF EXISTS lab_results');
      await db.execute('''
    CREATE TABLE lab_results (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      test_name TEXT NOT NULL,
      value REAL,
      unit TEXT,
      normal_range_min REAL,
      normal_range_max REAL,
      interpretation TEXT,
      lab_date TEXT NOT NULL,
      report_image_url TEXT,
      extracted_by_ocr INTEGER DEFAULT 0,
      created_at TEXT NOT NULL
    )
  ''');
    }
    if (oldVersion < 7) {
      // auth_credentials is created lazily on first signup, so on some
      // devices it doesn't exist yet at upgrade time. Create it (already
      // carrying the new salt column) and only ALTER when an old copy
      // without the column is present — otherwise openDatabase would throw
      // "no such table" / "duplicate column" and brick every DB call.
      await db.execute('''
      CREATE TABLE IF NOT EXISTS auth_credentials (
        user_id TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        salt TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
      final columns = await db.rawQuery(
        "PRAGMA table_info('auth_credentials')",
      );
      final hasSalt = columns.any((c) => c['name'] == 'salt');
      if (!hasSalt) {
        // Pre-existing table from the unsalted era. Existing rows get an
        // empty salt, which fails verification — users must re-register.
        await db.execute(
          "ALTER TABLE auth_credentials ADD COLUMN salt TEXT NOT NULL DEFAULT ''",
        );
      }
    }
    if (oldVersion < 8) {
      // Mood logging goes live. The moods table only ever lived in createSchema,
      // so installs that upgraded through earlier versions may not have it —
      // create it (with the new energy_level/sleep_quality columns) and only
      // ALTER when an older copy without those columns is present.
      await db.execute('''
      CREATE TABLE IF NOT EXISTS moods (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        mood TEXT NOT NULL,
        intensity INTEGER,
        energy_level INTEGER,
        sleep_quality INTEGER,
        notes TEXT,
        recorded_at TEXT DEFAULT CURRENT_TIMESTAMP,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
      final moodCols = await db.rawQuery("PRAGMA table_info('moods')");
      final names = moodCols.map((c) => c['name'] as String).toSet();
      if (!names.contains('energy_level')) {
        await db.execute('ALTER TABLE moods ADD COLUMN energy_level INTEGER');
      }
      if (!names.contains('sleep_quality')) {
        await db.execute('ALTER TABLE moods ADD COLUMN sleep_quality INTEGER');
      }
    }
    if (oldVersion < 9) {
      // BMI needs the mother's height + pre-pregnancy weight, stored on the
      // active pregnancy. Add the columns only when absent.
      final pregCols = await db.rawQuery("PRAGMA table_info('pregnancies')");
      final names = pregCols.map((c) => c['name'] as String).toSet();
      if (!names.contains('pre_pregnancy_weight')) {
        await db.execute(
          'ALTER TABLE pregnancies ADD COLUMN pre_pregnancy_weight REAL',
        );
      }
      if (!names.contains('height_cm')) {
        await db.execute('ALTER TABLE pregnancies ADD COLUMN height_cm REAL');
      }
    }
  }

  /// Static + visible for the same reason as [upgradeSchema].
  @visibleForTesting
  static Future<void> createSchema(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        phone TEXT,
        country TEXT,
        language TEXT,
        theme TEXT,
        notifications_enabled INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Pregnancies table
    await db.execute('''
      CREATE TABLE pregnancies (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        lmp_date TEXT NOT NULL,
        due_date TEXT NOT NULL,
        current_week INTEGER,
        current_trimester TEXT,
        is_active INTEGER DEFAULT 1,
        medical_conditions TEXT,
        pre_pregnancy_weight REAL,
        height_cm REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Kick counts table
    await db.execute('''
      CREATE TABLE kick_counts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        kick_count INTEGER NOT NULL,
        duration_minutes INTEGER,
        recorded_at TEXT DEFAULT CURRENT_TIMESTAMP,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Babies table
    await db.execute('''
      CREATE TABLE babies (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        gender TEXT,
        date_of_birth TEXT NOT NULL,
        birth_weight REAL,
        birth_height REAL,
        theme_color TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Baby growth table
    await db.execute('''
      CREATE TABLE baby_growth (
        id TEXT PRIMARY KEY,
        baby_id TEXT NOT NULL,
        recorded_date TEXT NOT NULL,
        weight REAL,
        weight_percentile INTEGER,
        height_percentile INTEGER,
        growth_status TEXT,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // Milestones table
    await db.execute('''
      CREATE TABLE milestones (
        id TEXT PRIMARY KEY,
        baby_id TEXT NOT NULL,
        milestone_name TEXT NOT NULL,
        expected_age_months INTEGER,
        achieved_date TEXT,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // Feeding logs table
    await db.execute('''
      CREATE TABLE feeding_logs (
        id TEXT PRIMARY KEY,
        baby_id TEXT NOT NULL,
        feeding_type TEXT NOT NULL,
        duration_minutes INTEGER,
        amount_ml REAL,
        breast_side TEXT,
        logged_at TEXT DEFAULT CURRENT_TIMESTAMP,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // Vitals table
    await db.execute('''
      CREATE TABLE vitals (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        vital_type TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT,
        recorded_at TEXT DEFAULT CURRENT_TIMESTAMP,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Moods table
    await db.execute('''
      CREATE TABLE moods (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        mood TEXT NOT NULL,
        intensity INTEGER,
        energy_level INTEGER,
        sleep_quality INTEGER,
        notes TEXT,
        recorded_at TEXT DEFAULT CURRENT_TIMESTAMP,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Lab Results table
    await db.execute('''
  CREATE TABLE lab_results (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    test_name TEXT NOT NULL,
    value REAL,
    unit TEXT,
    normal_range_min REAL,
    normal_range_max REAL,
    interpretation TEXT,
    lab_date TEXT NOT NULL,
    report_image_url TEXT,
    extracted_by_ocr INTEGER DEFAULT 0,
    created_at TEXT NOT NULL
  )
''');

    // Risk alerts table
    await db.execute('''
      CREATE TABLE risk_alerts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        alert_type TEXT NOT NULL,
        severity TEXT NOT NULL,
        message TEXT NOT NULL,
        recommendation TEXT,
        is_resolved INTEGER DEFAULT 0,
        detected_at TEXT DEFAULT CURRENT_TIMESTAMP,
        resolved_at TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        baby_id TEXT,
        title TEXT NOT NULL,
        doctor_name TEXT,
        appointment_type TEXT,
        appointment_date TEXT NOT NULL,
        location TEXT,
        notes TEXT,
        reminder_time TEXT,
        is_completed INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // Medicines table
    await db.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        baby_id TEXT,
        medicine_name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        type TEXT,
        frequency_type TEXT NOT NULL,
        frequency_value INTEGER,
        scheduled_times TEXT,
        start_date TEXT NOT NULL,
        end_date TEXT,
        medicine_image_url TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // Medicine logged table
    await db.execute('''
      CREATE TABLE medicine_logged (
        id TEXT PRIMARY KEY,
        medicine_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        logged_date TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        logged_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        reminder_type TEXT NOT NULL,
        reference_id TEXT,
        title TEXT NOT NULL,
        description TEXT,
        reminder_time TEXT NOT NULL,
        repeat_pattern TEXT,
        is_completed INTEGER DEFAULT 0,
        completed_at TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tips table
    await db.execute('''
      CREATE TABLE tips (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT,
        target_audience TEXT,
        image_url TEXT,
        source TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // User saved tips table
    await db.execute('''
      CREATE TABLE user_saved_tips (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        tip_id TEXT NOT NULL,
        saved_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (tip_id) REFERENCES tips (id) ON DELETE CASCADE
      )
    ''');

    // Doctors table
    await db.execute('''
      CREATE TABLE doctors (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        specialty TEXT,
        distance REAL,
        gender TEXT,
        phone TEXT,
        email TEXT,
        latitude REAL,
        longitude REAL,
        rating REAL,
        reviews_count INTEGER DEFAULT 0,
        address TEXT,
        isfavorite INTEGER,
        wilaya TEXT
      )
    ''');

    // Product categories table
    await db.execute('''
      CREATE TABLE product_categories (
        id TEXT PRIMARY KEY,
        name TEXT,
        image_url TEXT,
        display_order INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        product_name TEXT NOT NULL,
        description TEXT,
        category_id TEXT NOT NULL,
        target_audience TEXT,
        price REAL NOT NULL,
        original_price REAL,
        discount_percentage INTEGER,
        currency TEXT DEFAULT 'USD',
        rating REAL DEFAULT 0,
        reviews_count INTEGER DEFAULT 0,
        image_urls TEXT NOT NULL,
        vendor_name TEXT,
        is_available INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES product_categories (id) ON DELETE SET NULL
      )
    ''');

    // Product variants table
    await db.execute('''
      CREATE TABLE product_variants (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        type TEXT NOT NULL,
        value TEXT NOT NULL,
        color_hex TEXT,
        stock INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Product specs table
    await db.execute('''
      CREATE TABLE product_specs (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        name TEXT NOT NULL,
        value TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Product reviews table
    await db.execute('''
      CREATE TABLE product_reviews (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        reviewer_name TEXT NOT NULL,
        rating INTEGER NOT NULL,
        review_text TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Cart items table
    await db.execute('''
      CREATE TABLE cart_items (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_price REAL NOT NULL,
        variant_color TEXT,
        variant_size TEXT,
        quantity INTEGER NOT NULL DEFAULT 1,
        added_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        full_name TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        delivery_address TEXT NOT NULL,
        city TEXT NOT NULL,
        special_instructions TEXT,
        payment_method TEXT NOT NULL,
        subtotal REAL NOT NULL,
        delivery_fee REAL NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        order_date TEXT DEFAULT CURRENT_TIMESTAMP,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Order items table
    await db.execute('''
      CREATE TABLE order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        variant_color TEXT,
        variant_size TEXT,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL
      )
    ''');

    // User activity log table
    await db.execute('''
      CREATE TABLE user_activity_log (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        activity_type TEXT NOT NULL,
        activity_details TEXT,
        page_visited TEXT,
        session_id TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    // Measurements table (combined vitals)
    await db.execute('''
  CREATE TABLE measurements (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    weight REAL,
    heart_rate INTEGER,
    systolic INTEGER,
    diastolic INTEGER,
    recorded_at TEXT NOT NULL,
    notes TEXT,
    created_at TEXT NOT NULL
  )
''');
    // Symptoms table
    await db.execute('''
  CREATE TABLE symptoms (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    symptom_name TEXT NOT NULL,
    severity TEXT,
    notes TEXT,
    recorded_at TEXT NOT NULL,
    created_at TEXT NOT NULL
  )
''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      _database = null;
      await db.close();
    }
  }
}
