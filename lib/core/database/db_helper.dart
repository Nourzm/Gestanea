import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
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
      version: 12,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
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
        created_at TEXT NOT NULL,
        synced INTEGER DEFAULT 1
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
      // Add onboarding_completed column to users table
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN onboarding_completed INTEGER DEFAULT 0',
        );
      } catch (e) {
        // Column might already exist, ignore
        print('Note: onboarding_completed column may already exist: $e');
      }
    }
    if (oldVersion < 8) {
      // Add profile_picture_path column to users table
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN profile_picture_path TEXT',
        );
      } catch (e) {
        // Column might already exist, ignore
        print('Note: profile_picture_path column may already exist: $e');
      }
    }
    if (oldVersion < 9) {
      // Create notifications table for FCM notifications
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notifications (
          id TEXT PRIMARY KEY,
          user_id TEXT,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          image_url TEXT,
          topic TEXT,
          data TEXT,
          received_at TEXT NOT NULL,
          is_read INTEGER DEFAULT 0,
          read_at TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
      // Create indexes for notifications table
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_notifications_received_at ON notifications(received_at DESC)',
      );
      print('Notifications table created successfully');
    }
    if (oldVersion < 10) {
      // Safety migration: ensure notifications table exists even if the app
      // reached v9 before the migration was added.
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notifications (
          id TEXT PRIMARY KEY,
          user_id TEXT,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          image_url TEXT,
          topic TEXT,
          data TEXT,
          received_at TEXT NOT NULL,
          is_read INTEGER DEFAULT 0,
          read_at TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_notifications_received_at ON notifications(received_at DESC)',
      );
      print('Notifications table ensured (v10 migration)');
    }
    if (oldVersion < 11) {
      // Add onboarding-related columns to users table
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN date_of_birth TEXT',
        );
      } catch (e) {
        print('Note: date_of_birth column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN height_cm REAL',
        );
      } catch (e) {
        print('Note: height_cm column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN baseline_weight REAL',
        );
      } catch (e) {
        print('Note: baseline_weight column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN user_status TEXT',
        );
      } catch (e) {
        print('Note: user_status column may already exist: $e');
      }
      
      // Add columns to pregnancies table
      try {
        await db.execute(
          'ALTER TABLE pregnancies ADD COLUMN is_first_pregnancy INTEGER DEFAULT 0',
        );
      } catch (e) {
        print('Note: is_first_pregnancy column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE pregnancies ADD COLUMN is_high_risk INTEGER DEFAULT 0',
        );
      } catch (e) {
        print('Note: is_high_risk column may already exist: $e');
      }
      
      // Create user_health_profile table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_health_profile (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL UNIQUE,
          blood_type TEXT,
          chronic_conditions TEXT,
          allergies TEXT,
          emergency_contact_name TEXT,
          emergency_contact_phone TEXT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_user_health_profile_user_id ON user_health_profile(user_id)',
      );
      print('Onboarding schema updated (v11 migration)');
    }
    if (oldVersion < 12) {
      // Add new columns to tips table for enhanced tips feature
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN is_global INTEGER DEFAULT 0',
        );
      } catch (e) {
        print('Note: is_global column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN priority INTEGER DEFAULT 0',
        );
      } catch (e) {
        print('Note: priority column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN pregnancy_week_from INTEGER',
        );
      } catch (e) {
        print('Note: pregnancy_week_from column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN pregnancy_week_to INTEGER',
        );
      } catch (e) {
        print('Note: pregnancy_week_to column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN pregnancy_month_from INTEGER',
        );
      } catch (e) {
        print('Note: pregnancy_month_from column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN pregnancy_month_to INTEGER',
        );
      } catch (e) {
        print('Note: pregnancy_month_to column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN postpartum_week_from INTEGER',
        );
      } catch (e) {
        print('Note: postpartum_week_from column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN postpartum_week_to INTEGER',
        );
      } catch (e) {
        print('Note: postpartum_week_to column may already exist: $e');
      }
      try {
        await db.execute(
          'ALTER TABLE tips ADD COLUMN content_json TEXT',
        );
      } catch (e) {
        print('Note: content_json column may already exist: $e');
      }
      print('Tips schema updated (v12 migration)');
      // Add synced column to measurements table for offline support
      // Check if column exists first to avoid duplicate column error
      var result = await db.rawQuery('PRAGMA table_info(measurements)');
      bool hasSyncedColumn = result.any((column) => column['name'] == 'synced');
      
      if (!hasSyncedColumn) {
        await db.execute('''
          ALTER TABLE measurements ADD COLUMN synced INTEGER DEFAULT 1
        ''');
      }
    }
    if (oldVersion < 8) {
      // Add synced column to symptoms table for offline support
      var result = await db.rawQuery('PRAGMA table_info(symptoms)');
      bool hasSyncedColumn = result.any((column) => column['name'] == 'synced');
      
      if (!hasSyncedColumn) {
        await db.execute('''
          ALTER TABLE symptoms ADD COLUMN synced INTEGER DEFAULT 1
        ''');
      }
    }
    if (oldVersion < 9) {
      // Add duration column to symptoms table
      var result = await db.rawQuery('PRAGMA table_info(symptoms)');
      bool hasDurationColumn = result.any((column) => column['name'] == 'duration');
      
      if (!hasDurationColumn) {
        await db.execute('''
          ALTER TABLE symptoms ADD COLUMN duration TEXT
        ''');
      }
    }
    if (oldVersion < 10) {
      // Add synced column to lab_results table for offline support
      var result = await db.rawQuery('PRAGMA table_info(lab_results)');
      bool hasSyncedColumn = result.any((column) => column['name'] == 'synced');
      
      if (!hasSyncedColumn) {
        await db.execute('''
          ALTER TABLE lab_results ADD COLUMN synced INTEGER DEFAULT 1
        ''');
      }
    }
    if (oldVersion < 11) {
      // Add synced column to moods table for offline support
      var result = await db.rawQuery('PRAGMA table_info(moods)');
      bool hasSyncedColumn = result.any((column) => column['name'] == 'synced');
      
      if (!hasSyncedColumn) {
        await db.execute('''
          ALTER TABLE moods ADD COLUMN synced INTEGER DEFAULT 1
        ''');
      }
    }
    if (oldVersion < 12) {
      // Remove foreign key constraint from moods table
      // SQLite doesn't support dropping foreign keys, so we need to recreate the table
      
      // 1. Create new moods table without foreign key
      await db.execute('''
        CREATE TABLE moods_new (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          mood TEXT NOT NULL,
          intensity INTEGER,
          notes TEXT,
          recorded_at TEXT DEFAULT CURRENT_TIMESTAMP,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          synced INTEGER DEFAULT 1
        )
      ''');
      
      // 2. Copy data from old table to new table
      await db.execute('''
        INSERT INTO moods_new (id, user_id, mood, intensity, notes, recorded_at, created_at, synced)
        SELECT id, user_id, mood, intensity, notes, recorded_at, created_at, synced FROM moods
      ''');
      
      // 3. Drop old table
      await db.execute('DROP TABLE moods');
      
      // 4. Rename new table to original name
      await db.execute('ALTER TABLE moods_new RENAME TO moods');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table (must be created first as other tables reference it)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        phone TEXT,
        country TEXT,
        language TEXT,
        theme TEXT,
        notifications_enabled INTEGER DEFAULT 1,
        onboarding_completed INTEGER DEFAULT 0,
        profile_picture_path TEXT,
        date_of_birth TEXT,
        height_cm REAL,
        baseline_weight REAL,
        user_status TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
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
        is_first_pregnancy INTEGER DEFAULT 0,
        is_high_risk INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
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
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
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
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
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

    // Moods table (no foreign key constraint for Supabase compatibility)
    await db.execute('''
      CREATE TABLE moods (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        mood TEXT NOT NULL,
        intensity INTEGER,
        notes TEXT,
        recorded_at TEXT DEFAULT CURRENT_TIMESTAMP,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
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
        content_json TEXT,
        category TEXT,
        target_audience TEXT,
        image_url TEXT,
        source TEXT,
        is_active INTEGER DEFAULT 1,
        is_global INTEGER DEFAULT 0,
        priority INTEGER DEFAULT 0,
        pregnancy_week_from INTEGER,
        pregnancy_week_to INTEGER,
        pregnancy_month_from INTEGER,
        pregnancy_month_to INTEGER,
        postpartum_week_from INTEGER,
        postpartum_week_to INTEGER,
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

    // User health profile table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_health_profile (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL UNIQUE,
        blood_type TEXT,
        chronic_conditions TEXT,
        allergies TEXT,
        emergency_contact_name TEXT,
        emergency_contact_phone TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_user_health_profile_user_id ON user_health_profile(user_id)',
    );

    // Notifications table for FCM notifications
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        image_url TEXT,
        topic TEXT,
        data TEXT,
        received_at TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        read_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for notifications table
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notifications_received_at ON notifications(received_at DESC)',
    );
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
    created_at TEXT NOT NULL,
    synced INTEGER DEFAULT 1
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
    final db = await instance.database;
    db.close();
  }
}
