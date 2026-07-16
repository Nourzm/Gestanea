// lib/features/pregnancy/data/datasources/pregnancy_local_data_source.dart
import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/pregnancy_model.dart';
import '../../../../core/database/models/kick_count_model.dart';

abstract class PregnancyLocalDataSource {
  Future<PregnancyModel?> getActivePregnancy(String userId);
  Future<void> createPregnancy(PregnancyModel pregnancy);
  Future<void> updatePregnancy(PregnancyModel pregnancy);
  Future<void> deactivatePregnancy(String pregnancyId);
  Future<Map<String, dynamic>> calculatePregnancyWeek(String userId);
  Future<List<KickCountModel>> getKickCounts(String userId, {int? limit});
  Future<KickCountModel?> getTodayKickSession(String userId);
  Future<void> saveKickSession(KickCountModel kickCount);
  Future<void> updateKickSession(KickCountModel kickCount);
}

class PregnancyLocalDataSourceImpl implements PregnancyLocalDataSource {
  final DatabaseHelper _dbHelper;

  PregnancyLocalDataSourceImpl({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<PregnancyModel?> getActivePregnancy(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'pregnancies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return PregnancyModel.fromMap(result.first);
  }

  @override
  Future<void> createPregnancy(PregnancyModel pregnancy) async {
    final db = await _dbHelper.database;
    await db.insert('pregnancies', pregnancy.toMap());
  }

  @override
  Future<void> updatePregnancy(PregnancyModel pregnancy) async {
    final db = await _dbHelper.database;
    await db.update(
      'pregnancies',
      pregnancy.toMap(),
      where: 'id = ?',
      whereArgs: [pregnancy.id],
    );
  }

  @override
  Future<void> deactivatePregnancy(String pregnancyId) async {
    final db = await _dbHelper.database;
    await db.update(
      'pregnancies',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [pregnancyId],
    );
  }

  @override
  Future<Map<String, dynamic>> calculatePregnancyWeek(String userId) async {
    final pregnancy = await getActivePregnancy(userId);
    
    if (pregnancy == null) {
      return {
        'currentWeek': 0,
        'currentDay': 0,
        'trimester': 'N/A',
        'daysLeft': 0,
        'dueDate': null,
        'progressPercentage': 0.0,
      };
    }

    final lmpDate = pregnancy.lmpDate;
    final now = DateTime.now();
    final daysSinceLmp = now.difference(lmpDate).inDays;

    final currentWeek = (daysSinceLmp ~/ 7) + 1;
    final currentDay = daysSinceLmp % 7;

    String trimester;
    if (currentWeek <= 12) {
      trimester = '1st Trimester';
    } else if (currentWeek <= 27) {
      trimester = '2nd Trimester';
    } else {
      trimester = '3rd Trimester';
    }

    // Calculate days left (40 weeks = 280 days)
    int daysLeft = 280 - daysSinceLmp;
    if (daysLeft < 0) daysLeft = 0;

    // Calculate progress percentage
    double progressPercentage = (daysSinceLmp / 280) * 100;
    if (progressPercentage > 100) progressPercentage = 100;

    return {
      'currentWeek': currentWeek,
      'currentDay': currentDay,
      'trimester': trimester,
      'daysLeft': daysLeft,
      'dueDate': pregnancy.dueDate,
      'progressPercentage': progressPercentage,
    };
  }

  @override
  Future<List<KickCountModel>> getKickCounts(String userId, {int? limit}) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'kick_counts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
      limit: limit,
    );
    return result.map((map) => KickCountModel.fromMap(map)).toList();
  }

  @override
  Future<KickCountModel?> getTodayKickSession(String userId) async {
    final db = await _dbHelper.database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.query(
      'kick_counts',
      where: 'user_id = ? AND recorded_at >= ? AND recorded_at < ?',
      whereArgs: [
        userId,
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
      orderBy: 'recorded_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return KickCountModel.fromMap(result.first);
  }

  @override
  Future<void> saveKickSession(KickCountModel kickCount) async {
    final db = await _dbHelper.database;
    await db.insert('kick_counts', kickCount.toMap());
  }

  @override
  Future<void> updateKickSession(KickCountModel kickCount) async {
    final db = await _dbHelper.database;
    await db.update(
      'kick_counts',
      kickCount.toMap(),
      where: 'id = ?',
      whereArgs: [kickCount.id],
    );
  }
}
