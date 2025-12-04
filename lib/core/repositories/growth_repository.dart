import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/baby_growth.dart';

class GrowthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<BabyGrowth>>> getGrowthRecords(String babyId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'baby_growth',
        where: 'baby_id = ?',
        whereArgs: [babyId],
        orderBy: 'date DESC',
      );
      final records = maps.map((m) => BabyGrowth.fromMap(m)).toList();
      return Result.success(records);
    } catch (e) {
      return Result.failure('Failed to get growth records: ${e.toString()}');
    }
  }

  Future<Result<BabyGrowth>> addGrowthRecord(BabyGrowth record) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('baby_growth', record.toMap());
      return Result.success(record, 'Growth record added successfully');
    } catch (e) {
      return Result.failure('Failed to add growth record: ${e.toString()}');
    }
  }

  Future<Result<BabyGrowth>> updateGrowthRecord(BabyGrowth record) async {
    try {
      final db = await _dbHelper.database;
      await db.update('baby_growth', record.toMap(), where: 'id = ?', whereArgs: [record.id]);
      return Result.success(record, 'Growth record updated successfully');
    } catch (e) {
      return Result.failure('Failed to update growth record: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteGrowthRecord(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('baby_growth', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Growth record deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete growth record: ${e.toString()}');
    }
  }
}
