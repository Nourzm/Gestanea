import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/pregnancy.dart';
import 'package:gestanea/core/models/kick_count.dart';

class PregnancyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Pregnancy CRUD
  Future<Result<Pregnancy>> getPregnancy(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('pregnancies', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.failure('Pregnancy not found');
      return Result.success(Pregnancy.fromMap(maps.first));
    } catch (e) {
      return Result.failure('Failed to get pregnancy: ${e.toString()}');
    }
  }

  Future<Result<List<Pregnancy>>> getUserPregnancies(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'pregnancies',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      final pregnancies = maps.map((m) => Pregnancy.fromMap(m)).toList();
      return Result.success(pregnancies);
    } catch (e) {
      return Result.failure('Failed to get pregnancies: ${e.toString()}');
    }
  }

  Future<Result<Pregnancy?>> getActivePregnancy(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'pregnancies',
        where: 'user_id = ? AND is_active = ?',
        whereArgs: [userId, 1],
      );
      if (maps.isEmpty) return Result.success(null);
      return Result.success(Pregnancy.fromMap(maps.first));
    } catch (e) {
      return Result.failure('Failed to get active pregnancy: ${e.toString()}');
    }
  }

  Future<Result<Pregnancy>> createPregnancy(Pregnancy pregnancy) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('pregnancies', pregnancy.toMap());
      return Result.success(pregnancy, 'Pregnancy created successfully');
    } catch (e) {
      return Result.failure('Failed to create pregnancy: ${e.toString()}');
    }
  }

  Future<Result<Pregnancy>> updatePregnancy(Pregnancy pregnancy) async {
    try {
      final db = await _dbHelper.database;
      final updated = Pregnancy(
        id: pregnancy.id,
        userId: pregnancy.userId,
        startDate: pregnancy.startDate,
        dueDate: pregnancy.dueDate,
        isActive: pregnancy.isActive,
        medicalConditions: pregnancy.medicalConditions,
        notes: pregnancy.notes,
        createdAt: pregnancy.createdAt,
        updatedAt: DateTime.now(),
      );
      await db.update('pregnancies', updated.toMap(), where: 'id = ?', whereArgs: [pregnancy.id]);
      return Result.success(updated, 'Pregnancy updated successfully');
    } catch (e) {
      return Result.failure('Failed to update pregnancy: ${e.toString()}');
    }
  }

  Future<Result<bool>> deletePregnancy(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('pregnancies', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Pregnancy deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete pregnancy: ${e.toString()}');
    }
  }

  // Kick Counts
  Future<Result<List<KickCount>>> getKickCounts(String pregnancyId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'kick_counts',
        where: 'pregnancy_id = ?',
        whereArgs: [pregnancyId],
        orderBy: 'date DESC, start_time DESC',
      );
      final kickCounts = maps.map((m) => KickCount.fromMap(m)).toList();
      return Result.success(kickCounts);
    } catch (e) {
      return Result.failure('Failed to get kick counts: ${e.toString()}');
    }
  }

  Future<Result<KickCount>> addKickCount(KickCount kickCount) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('kick_counts', kickCount.toMap());
      return Result.success(kickCount, 'Kick count added successfully');
    } catch (e) {
      return Result.failure('Failed to add kick count: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteKickCount(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('kick_counts', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Kick count deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete kick count: ${e.toString()}');
    }
  }
}
