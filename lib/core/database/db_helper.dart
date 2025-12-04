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
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const intTypeNullable = 'INTEGER';
    const realType = 'REAL NOT NULL';
    const realTypeNullable = 'REAL';
    const boolType = 'INTEGER NOT NULL'; // SQLite uses 0/1 for boolean

    // 1. Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        email $textType,
        name $textType,
        phone $textTypeNullable,
        profile_image $textTypeNullable,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // 2. Pregnancies table
    await db.execute('''
      CREATE TABLE pregnancies (
        id $idType,
        user_id $textType,
        start_date $textType,
        due_date $textType,
        is_active $boolType,
        medical_conditions $textTypeNullable,
        notes $textTypeNullable,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. Babies table
    await db.execute('''
      CREATE TABLE babies (
        id $idType,
        user_id $textType,
        name $textType,
        gender $textType,
        birth_date $textType,
        birth_weight $realTypeNullable,
        birth_height $realTypeNullable,
        blood_type $textTypeNullable,
        profile_image $textTypeNullable,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 4. Kick counts table
    await db.execute('''
      CREATE TABLE kick_counts (
        id $idType,
        pregnancy_id $textType,
        date $textType,
        start_time $textType,
        end_time $textTypeNullable,
        count $intType,
        duration_minutes $intTypeNullable,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE CASCADE
      )
    ''');

    // 5. Baby growth table
    await db.execute('''
      CREATE TABLE baby_growth (
        id $idType,
        baby_id $textType,
        date $textType,
        weight $realType,
        height $realType,
        head_circumference $realTypeNullable,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // 6. Milestones table
    await db.execute('''
      CREATE TABLE milestones (
        id $idType,
        baby_id $textType,
        title $textType,
        description $textTypeNullable,
        category $textType,
        expected_age_months $intTypeNullable,
        achieved $boolType,
        achieved_date $textTypeNullable,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // 7. Feeding logs table
    await db.execute('''
      CREATE TABLE feeding_logs (
        id $idType,
        baby_id $textType,
        date $textType,
        time $textType,
        type $textType,
        duration_minutes $intTypeNullable,
        amount_ml $realTypeNullable,
        breast_side $textTypeNullable,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE CASCADE
      )
    ''');

    // 8. Vitals table
    await db.execute('''
      CREATE TABLE vitals (
        id $idType,
        user_id $textType,
        pregnancy_id $textTypeNullable,
        date $textType,
        time $textType,
        type $textType,
        value $realType,
        unit $textType,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE SET NULL
      )
    ''');

    // 9. Symptoms table
    await db.execute('''
      CREATE TABLE symptoms (
        id $idType,
        user_id $textType,
        pregnancy_id $textTypeNullable,
        date $textType,
        time $textType,
        symptom $textType,
        severity $intType,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE SET NULL
      )
    ''');

    // 10. Moods table
    await db.execute('''
      CREATE TABLE moods (
        id $idType,
        user_id $textType,
        pregnancy_id $textTypeNullable,
        date $textType,
        time $textType,
        mood $textType,
        intensity $intType,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE SET NULL
      )
    ''');

    // 11. Lab results table
    await db.execute('''
      CREATE TABLE lab_results (
        id $idType,
        user_id $textType,
        pregnancy_id $textTypeNullable,
        date $textType,
        test_name $textType,
        value $realType,
        unit $textType,
        reference_range $textTypeNullable,
        status $textType,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE SET NULL
      )
    ''');

    // 12. Risk alerts table
    await db.execute('''
      CREATE TABLE risk_alerts (
        id $idType,
        user_id $textType,
        pregnancy_id $textTypeNullable,
        alert_type $textType,
        severity $textType,
        message $textType,
        recommendations $textTypeNullable,
        is_resolved $boolType,
        created_at $textType,
        resolved_at $textTypeNullable,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE SET NULL
      )
    ''');

    // 13. Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id $idType,
        user_id $textType,
        pregnancy_id $textTypeNullable,
        baby_id $textTypeNullable,
        doctor_id $textTypeNullable,
        title $textType,
        description $textTypeNullable,
        date $textType,
        time $textType,
        location $textTypeNullable,
        status $textType,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE SET NULL,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE SET NULL,
        FOREIGN KEY (doctor_id) REFERENCES doctors (id) ON DELETE SET NULL
      )
    ''');

    // 14. Medicines table
    await db.execute('''
      CREATE TABLE medicines (
        id $idType,
        user_id $textType,
        pregnancy_id $textTypeNullable,
        baby_id $textTypeNullable,
        name $textType,
        dosage $textType,
        frequency $textType,
        times_per_day $intType,
        start_date $textType,
        end_date $textTypeNullable,
        is_active $boolType,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pregnancy_id) REFERENCES pregnancies (id) ON DELETE SET NULL,
        FOREIGN KEY (baby_id) REFERENCES babies (id) ON DELETE SET NULL
      )
    ''');

    // 15. Medicine logs table
    await db.execute('''
      CREATE TABLE medicine_logs (
        id $idType,
        medicine_id $textType,
        scheduled_time $textType,
        taken_time $textTypeNullable,
        status $textType,
        notes $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE CASCADE
      )
    ''');

    // 16. Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id $idType,
        user_id $textType,
        title $textType,
        description $textTypeNullable,
        date $textType,
        time $textType,
        type $textType,
        is_completed $boolType,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 17. Tips table
    await db.execute('''
      CREATE TABLE tips (
        id $idType,
        title $textType,
        content $textType,
        category $textType,
        stage $textTypeNullable,
        image_url $textTypeNullable,
        created_at $textType
      )
    ''');

    // 18. User saved tips table
    await db.execute('''
      CREATE TABLE user_saved_tips (
        id $idType,
        user_id $textType,
        tip_id $textType,
        saved_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (tip_id) REFERENCES tips (id) ON DELETE CASCADE
      )
    ''');

    // 19. Doctors table
    await db.execute('''
      CREATE TABLE doctors (
        id $idType,
        name $textType,
        specialty $textType,
        gender $textType,
        phone $textType,
        email $textTypeNullable,
        address $textType,
        latitude $realType,
        longitude $realType,
        rating $realType,
        years_experience $intTypeNullable,
        photo_url $textTypeNullable,
        created_at $textType
      )
    ''');

    // 20. User favorite doctors table
    await db.execute('''
      CREATE TABLE user_favorite_doctors (
        id $idType,
        user_id $textType,
        doctor_id $textType,
        favorited_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (doctor_id) REFERENCES doctors (id) ON DELETE CASCADE
      )
    ''');

    // 21. Product categories table
    await db.execute('''
      CREATE TABLE product_categories (
        id $idType,
        name $textType,
        icon $textTypeNullable,
        image_url $textTypeNullable,
        created_at $textType
      )
    ''');

    // 22. Products table
    await db.execute('''
      CREATE TABLE products (
        id $idType,
        category_id $textType,
        name $textType,
        description $textType,
        price $realType,
        discount_percentage $realTypeNullable,
        image_url $textType,
        rating $realTypeNullable,
        reviews_count $intTypeNullable,
        stock_quantity $intType,
        created_at $textType,
        FOREIGN KEY (category_id) REFERENCES product_categories (id) ON DELETE CASCADE
      )
    ''');

    // 23. Product variants table
    await db.execute('''
      CREATE TABLE product_variants (
        id $idType,
        product_id $textType,
        variant_type $textType,
        variant_value $textType,
        price_adjustment $realTypeNullable,
        created_at $textType,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // 24. Product specs table
    await db.execute('''
      CREATE TABLE product_specs (
        id $idType,
        product_id $textType,
        spec_name $textType,
        spec_value $textType,
        created_at $textType,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // 25. Product reviews table
    await db.execute('''
      CREATE TABLE product_reviews (
        id $idType,
        product_id $textType,
        user_id $textType,
        rating $realType,
        comment $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 26. Cart items table
    await db.execute('''
      CREATE TABLE cart_items (
        id $idType,
        user_id $textType,
        product_id $textType,
        quantity $intType,
        selected_color $textTypeNullable,
        selected_size $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // 27. Orders table
    await db.execute('''
      CREATE TABLE orders (
        id $idType,
        user_id $textType,
        order_number $textType,
        total_amount $realType,
        status $textType,
        payment_method $textTypeNullable,
        shipping_address $textTypeNullable,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 28. Order items table
    await db.execute('''
      CREATE TABLE order_items (
        id $idType,
        order_id $textType,
        product_id $textType,
        quantity $intType,
        price $realType,
        selected_color $textTypeNullable,
        selected_size $textTypeNullable,
        created_at $textType,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<bool> isDatabaseEmpty() async {
    final db = await instance.database;
    final result = await db.query('users', limit: 1);
    return result.isEmpty;
  }
}
