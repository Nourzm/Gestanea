import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/baby.dart';

class BabyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<Baby>> getBaby(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('babies', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.failure('Baby not found');
      return Result.success(Baby.fromMap(maps.first));
    } catch (e) {
      return Result.failure('Failed to get baby: ${e.toString()}');
    }
  }

  Future<Result<List<Baby>>> getUserBabies(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'babies',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'birth_date DESC',
      );
      final babies = maps.map((m) => Baby.fromMap(m)).toList();
      return Result.success(babies);
    } catch (e) {
      return Result.failure('Failed to get babies: ${e.toString()}');
    }
  }

  Future<Result<Baby>> createBaby(Baby baby) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('babies', baby.toMap());
      return Result.success(baby, 'Baby profile created successfully');
    } catch (e) {
      return Result.failure('Failed to create baby: ${e.toString()}');
    }
  }

  Future<Result<Baby>> updateBaby(Baby baby) async {
    try {
      final db = await _dbHelper.database;
      final updated = baby.copyWith(updatedAt: DateTime.now());
      await db.update('babies', updated.toMap(), where: 'id = ?', whereArgs: [baby.id]);
      return Result.success(updated, 'Baby updated successfully');
    } catch (e) {
      return Result.failure('Failed to update baby: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteBaby(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('babies', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Baby deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete baby: ${e.toString()}');
    }
  }
}
