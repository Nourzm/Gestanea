import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/feeding_log.dart';

class FeedingRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<FeedingLog>>> getFeedingLogs(String babyId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'feeding_logs',
        where: 'baby_id = ?',
        whereArgs: [babyId],
        orderBy: 'date DESC, time DESC',
      );
      final logs = maps.map((m) => FeedingLog.fromMap(m)).toList();
      return Result.success(logs);
    } catch (e) {
      return Result.failure('Failed to get feeding logs: ${e.toString()}');
    }
  }

  Future<Result<FeedingLog>> addFeedingLog(FeedingLog log) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('feeding_logs', log.toMap());
      return Result.success(log, 'Feeding log added successfully');
    } catch (e) {
      return Result.failure('Failed to add feeding log: ${e.toString()}');
    }
  }

  Future<Result<FeedingLog>> updateFeedingLog(FeedingLog log) async {
    try {
      final db = await _dbHelper.database;
      await db.update('feeding_logs', log.toMap(), where: 'id = ?', whereArgs: [log.id]);
      return Result.success(log, 'Feeding log updated successfully');
    } catch (e) {
      return Result.failure('Failed to update feeding log: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteFeedingLog(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('feeding_logs', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Feeding log deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete feeding log: ${e.toString()}');
    }
  }
}
