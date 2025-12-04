import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/tip.dart';

class EducationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<Tip>>> getAllTips() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('tips', orderBy: 'created_at DESC');
      final tips = maps.map((m) => Tip.fromMap(m)).toList();
      return Result.success(tips);
    } catch (e) {
      return Result.failure('Failed to get tips: ${e.toString()}');
    }
  }

  Future<Result<List<Tip>>> getTipsByCategory(String category) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'tips',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'created_at DESC',
      );
      final tips = maps.map((m) => Tip.fromMap(m)).toList();
      return Result.success(tips);
    } catch (e) {
      return Result.failure('Failed to get tips by category: ${e.toString()}');
    }
  }

  Future<Result<List<Tip>>> getTipsByStage(String stage) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'tips',
        where: 'stage = ?',
        whereArgs: [stage],
        orderBy: 'created_at DESC',
      );
      final tips = maps.map((m) => Tip.fromMap(m)).toList();
      return Result.success(tips);
    } catch (e) {
      return Result.failure('Failed to get tips by stage: ${e.toString()}');
    }
  }

  Future<Result<List<Tip>>> getSavedTips(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.rawQuery('''
        SELECT t.* FROM tips t
        INNER JOIN user_saved_tips ust ON t.id = ust.tip_id
        WHERE ust.user_id = ?
        ORDER BY ust.saved_at DESC
      ''', [userId]);
      final tips = maps.map((m) => Tip.fromMap(m)).toList();
      return Result.success(tips);
    } catch (e) {
      return Result.failure('Failed to get saved tips: ${e.toString()}');
    }
  }

  Future<Result<bool>> toggleSave(String userId, String tipId) async {
    try {
      final db = await _dbHelper.database;
      
      // Check if already saved
      final existing = await db.query(
        'user_saved_tips',
        where: 'user_id = ? AND tip_id = ?',
        whereArgs: [userId, tipId],
      );

      if (existing.isNotEmpty) {
        // Remove from saved
        await db.delete(
          'user_saved_tips',
          where: 'user_id = ? AND tip_id = ?',
          whereArgs: [userId, tipId],
        );
        return Result.success(false, 'Removed from saved tips');
      } else {
        // Add to saved
        await db.insert('user_saved_tips', {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'user_id': userId,
          'tip_id': tipId,
          'saved_at': DateTime.now().toIso8601String(),
        });
        return Result.success(true, 'Added to saved tips');
      }
    } catch (e) {
      return Result.failure('Failed to toggle save: ${e.toString()}');
    }
  }

  Future<Result<bool>> isSaved(String userId, String tipId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'user_saved_tips',
        where: 'user_id = ? AND tip_id = ?',
        whereArgs: [userId, tipId],
      );
      return Result.success(maps.isNotEmpty);
    } catch (e) {
      return Result.failure('Failed to check save status: ${e.toString()}');
    }
  }

  Future<Result<List<Tip>>> searchTips(String query) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'tips',
        where: 'title LIKE ? OR content LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'created_at DESC',
      );
      final tips = maps.map((m) => Tip.fromMap(m)).toList();
      return Result.success(tips);
    } catch (e) {
      return Result.failure('Failed to search tips: ${e.toString()}');
    }
  }
}
