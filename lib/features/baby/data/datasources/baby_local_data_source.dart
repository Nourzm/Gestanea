import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/core/database/models/baby_growth_model.dart';
import 'package:gestanea/core/database/models/milestone_model.dart';
import 'package:gestanea/core/database/models/feeding_log_model.dart';

class BabyLocalDataSource {
  final DatabaseHelper _dbHelper;

  BabyLocalDataSource(this._dbHelper);

  // ==================== BABY CRUD ====================

  Future<BabyModel?> getBabyByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'babies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return BabyModel.fromMap(maps.first);
  }

  Future<List<BabyModel>> getAllBabiesByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'babies',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => BabyModel.fromMap(map)).toList();
  }

  Future<BabyModel?> getBabyById(String babyId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'babies',
      where: 'id = ?',
      whereArgs: [babyId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return BabyModel.fromMap(maps.first);
  }

  Future<void> createBaby(BabyModel baby) async {
    final db = await _dbHelper.database;
    await db.insert('babies', baby.toMap());
  }

  Future<void> updateBaby(BabyModel baby) async {
    final db = await _dbHelper.database;
    await db.update(
      'babies',
      baby.toMap(),
      where: 'id = ?',
      whereArgs: [baby.id],
    );
  }

  Future<void> deleteBaby(String babyId) async {
    final db = await _dbHelper.database;
    await db.delete('babies', where: 'id = ?', whereArgs: [babyId]);
  }

  // ==================== GROWTH RECORDS ====================

  Future<List<BabyGrowthModel>> getGrowthRecords(String babyId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'baby_growth',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'recorded_date DESC',
    );
    return maps.map((map) => BabyGrowthModel.fromMap(map)).toList();
  }

  Future<BabyGrowthModel?> getLatestGrowthRecord(String babyId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'baby_growth',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'recorded_date DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return BabyGrowthModel.fromMap(maps.first);
  }

  Future<void> addGrowthRecord(BabyGrowthModel growth) async {
    final db = await _dbHelper.database;
    await db.insert('baby_growth', growth.toMap());
  }

  Future<void> updateGrowthRecord(BabyGrowthModel growth) async {
    final db = await _dbHelper.database;
    await db.update(
      'baby_growth',
      growth.toMap(),
      where: 'id = ?',
      whereArgs: [growth.id],
    );
  }

  Future<void> deleteGrowthRecord(String growthId) async {
    final db = await _dbHelper.database;
    await db.delete('baby_growth', where: 'id = ?', whereArgs: [growthId]);
  }

  // ==================== MILESTONES ====================

  Future<List<MilestoneModel>> getMilestones(String babyId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'milestones',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'expected_age_months ASC',
    );
    return maps.map((map) => MilestoneModel.fromMap(map)).toList();
  }

  Future<List<MilestoneModel>> getAchievedMilestones(String babyId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'milestones',
      where: 'baby_id = ? AND achieved_date IS NOT NULL',
      whereArgs: [babyId],
      orderBy: 'achieved_date DESC',
    );
    return maps.map((map) => MilestoneModel.fromMap(map)).toList();
  }

  Future<void> addMilestone(MilestoneModel milestone) async {
    final db = await _dbHelper.database;
    await db.insert('milestones', milestone.toMap());
  }

  Future<void> updateMilestone(MilestoneModel milestone) async {
    final db = await _dbHelper.database;
    await db.update(
      'milestones',
      milestone.toMap(),
      where: 'id = ?',
      whereArgs: [milestone.id],
    );
  }

  Future<void> markMilestoneAchieved(
    String milestoneId,
    DateTime achievedDate,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      'milestones',
      {'achieved_date': achievedDate.toIso8601String().split('T')[0]},
      where: 'id = ?',
      whereArgs: [milestoneId],
    );
  }

  Future<void> deleteMilestone(String milestoneId) async {
    final db = await _dbHelper.database;
    await db.delete('milestones', where: 'id = ?', whereArgs: [milestoneId]);
  }

  // ==================== FEEDING LOGS ====================

  Future<List<FeedingLogModel>> getFeedingLogs(
    String babyId, {
    int? limit,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'feeding_logs',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'logged_at DESC',
      limit: limit,
    );
    return maps.map((map) => FeedingLogModel.fromMap(map)).toList();
  }

  Future<List<FeedingLogModel>> getFeedingLogsByDate(
    String babyId,
    DateTime date,
  ) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final maps = await db.query(
      'feeding_logs',
      where: 'baby_id = ? AND DATE(logged_at) = ?',
      whereArgs: [babyId, dateStr],
      orderBy: 'logged_at DESC',
    );
    return maps.map((map) => FeedingLogModel.fromMap(map)).toList();
  }

  Future<void> addFeedingLog(FeedingLogModel feedingLog) async {
    final db = await _dbHelper.database;
    await db.insert('feeding_logs', feedingLog.toMap());
  }

  Future<void> updateFeedingLog(FeedingLogModel feedingLog) async {
    final db = await _dbHelper.database;
    await db.update(
      'feeding_logs',
      feedingLog.toMap(),
      where: 'id = ?',
      whereArgs: [feedingLog.id],
    );
  }

  Future<void> deleteFeedingLog(String feedingLogId) async {
    final db = await _dbHelper.database;
    await db.delete('feeding_logs', where: 'id = ?', whereArgs: [feedingLogId]);
  }

  // ==================== STATISTICS ====================

  Future<Map<String, dynamic>> getFeedingStats(
    String babyId, {
    int days = 7,
  }) async {
    final db = await _dbHelper.database;
    final startDate = DateTime.now().subtract(Duration(days: days));

    final maps = await db.rawQuery(
      '''
      SELECT 
        feeding_type,
        COUNT(*) as count,
        SUM(duration_minutes) as total_duration,
        SUM(amount_ml) as total_amount
      FROM feeding_logs
      WHERE baby_id = ? AND logged_at >= ?
      GROUP BY feeding_type
    ''',
      [babyId, startDate.toIso8601String()],
    );

    return {'stats': maps, 'startDate': startDate, 'endDate': DateTime.now()};
  }
}
