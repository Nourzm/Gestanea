import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/lab_result_model.dart';

class LabResultsLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<LabResultModel>> getLabResults(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'lab_results',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'lab_date DESC, created_at DESC',
      );
      return maps.map((map) => LabResultModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch local lab results: $e');
    }
  }

  Future<void> addLabResult(LabResultModel labResult) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('lab_results', labResult.toMap());
    } catch (e) {
      throw Exception('Failed to add local lab result: $e');
    }
  }

  Future<void> updateLabResult(LabResultModel labResult) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'lab_results',
        labResult.toMap(),
        where: 'id = ?',
        whereArgs: [labResult.id],
      );
    } catch (e) {
      throw Exception('Failed to update local lab result: $e');
    }
  }

  Future<void> deleteLabResult(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'lab_results',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete local lab result: $e');
    }
  }

  Future<LabResultModel?> getLabResultById(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'lab_results',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return LabResultModel.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to fetch local lab result: $e');
    }
  }

  Future<List<LabResultModel>> getLabResultsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final db = await _dbHelper.database;
      final startDateStr = startDate.toIso8601String().split('T')[0];
      final endDateStr = endDate.toIso8601String().split('T')[0];
      
      final maps = await db.query(
        'lab_results',
        where: 'user_id = ? AND lab_date >= ? AND lab_date <= ?',
        whereArgs: [userId, startDateStr, endDateStr],
        orderBy: 'lab_date DESC',
      );
      return maps.map((map) => LabResultModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch local lab results by date range: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('lab_results');
    } catch (e) {
      throw Exception('Failed to clear local lab results: $e');
    }
  }

  Future<void> saveMultiple(List<LabResultModel> labResults) async {
    try {
      final db = await _dbHelper.database;
      final batch = db.batch();
      for (var labResult in labResults) {
        batch.insert('lab_results', labResult.toMap());
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save multiple lab results: $e');
    }
  }
}
