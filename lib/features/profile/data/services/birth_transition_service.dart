// lib/features/profile/data/services/birth_transition_service.dart
import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/baby_model.dart';

class BirthTransitionService {
  final DatabaseHelper _dbHelper;

  BirthTransitionService({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  /// Transitions user from pregnancy to postpartum mode
  /// 1. Deactivates active pregnancy
  /// 2. Creates a new baby record
  /// Returns the created baby
  Future<BabyModel> giveBirth({
    required int userId,
    required String babyName,
    required DateTime dateOfBirth,
    required String gender,
    double? birthWeight,
    double? birthHeight,
  }) async {
    final db = await _dbHelper.database;

    // 1. Deactivate active pregnancy (user_id is TEXT in database)
    await db.update(
      'pregnancies',
      {'is_active': 0},
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId.toString()],
    );

    // 2. Create baby record
    final now = DateTime.now();
    final baby = BabyModel(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId.toString(),
      name: babyName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      birthWeight: birthWeight,
      birthHeight: birthHeight,
      themeColor: gender == 'girl' ? '#FFB6D9' : '#87CEEB',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    await db.insert('babies', baby.toMap());

    return baby;
  }

  /// Transitions user from pregnancy to postpartum mode using string user ID
  Future<BabyModel> giveBirthWithStringId({
    required String userId,
    required String babyName,
    required DateTime dateOfBirth,
    required String gender,
    double? birthWeight,
    double? birthHeight,
  }) async {
    final db = await _dbHelper.database;

    // 1. Deactivate active pregnancy
    await db.update(
      'pregnancies',
      {'is_active': 0},
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
    );

    // 2. Create baby record
    final now = DateTime.now();
    final baby = BabyModel(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      name: babyName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      birthWeight: birthWeight,
      birthHeight: birthHeight,
      themeColor: gender == 'girl' ? '#FFB6D9' : '#87CEEB',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    await db.insert('babies', baby.toMap());

    return baby;
  }

  /// Marks user as no longer pregnant without creating a baby
  Future<void> endPregnancy(int userId) async {
    final db = await _dbHelper.database;
    await db.update(
      'pregnancies',
      {'is_active': 0},
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId.toString()],
    );
  }

  /// Marks user as no longer pregnant without creating a baby (string-based)
  Future<void> endPregnancyWithStringId(String userId) async {
    final db = await _dbHelper.database;
    await db.update(
      'pregnancies',
      {'is_active': 0},
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
    );
  }

  /// Checks if user has an active pregnancy
  Future<bool> hasActivePregnancy(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'pregnancies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId.toString()],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Checks if user has an active baby
  Future<bool> hasActiveBaby(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'babies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId.toString()],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
