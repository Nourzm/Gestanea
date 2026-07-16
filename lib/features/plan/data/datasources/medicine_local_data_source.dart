import 'dart:convert';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/db_helper.dart';

/// Abstract interface for medicine data operations
abstract class MedicineDataSource {
  Future<List<MedicineModel>> getMedicines(String userId);
  Future<List<MedicineModel>> getMedicinesByDate(String userId, DateTime date);
  Future<List<MedicineLoggedModel>> getMedicineLogs(
    String userId,
    DateTime date,
  );
  Future<bool> insertMedicine(MedicineModel medicine);
  Future<bool> updateMedicine(MedicineModel medicine);
  Future<bool> deleteMedicine(String id);
  Future<bool> logMedicine(MedicineLoggedModel log);
}

/// Local database implementation of medicine data source
class MedicineLocalDataSource implements MedicineDataSource {
  final DatabaseHelper _dbHelper;

  MedicineLocalDataSource({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<List<MedicineModel>> getMedicines(String userId) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'medicines',
        where: 'user_id = ? AND is_active = 1',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => MedicineModel.fromMap(map)).toList();
    } catch (e) {
      print('Error getting medicines: $e');
      return [];
    }
  }

  @override
  Future<List<MedicineModel>> getMedicinesByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = date.toIso8601String().split('T')[0];

      final result = await db.query(
        'medicines',
        where:
            'user_id = ? AND is_active = 1 AND start_date <= ? AND (end_date IS NULL OR end_date >= ?)',
        whereArgs: [userId, dateStr, dateStr],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => MedicineModel.fromMap(map)).toList();
    } catch (e) {
      print('Error getting medicines by date: $e');
      return [];
    }
  }

  @override
  Future<List<MedicineLoggedModel>> getMedicineLogs(
    String userId,
    DateTime date,
  ) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = date.toIso8601String().split('T')[0];

      final result = await db.query(
        'medicine_logged',
        where: 'user_id = ? AND logged_date = ?',
        whereArgs: [userId, dateStr],
        orderBy: 'logged_at DESC',
      );
      return result.map((map) => MedicineLoggedModel.fromMap(map)).toList();
    } catch (e) {
      print('Error getting medicine logs: $e');
      return [];
    }
  }

  @override
  Future<bool> insertMedicine(MedicineModel medicine) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('medicines', medicine.toMap());
      return true;
    } catch (e) {
      print('Error inserting medicine: $e');
      return false;
    }
  }

  @override
  Future<bool> updateMedicine(MedicineModel medicine) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.update(
        'medicines',
        medicine.toMap(),
        where: 'id = ?',
        whereArgs: [medicine.id],
      );
      return count > 0;
    } catch (e) {
      print('Error updating medicine: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteMedicine(String id) async {
    try {
      final db = await _dbHelper.database;
      // Soft delete by setting is_active to 0
      final count = await db.update(
        'medicines',
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      print('Error deleting medicine: $e');
      return false;
    }
  }

  @override
  Future<bool> logMedicine(MedicineLoggedModel log) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('medicine_logged', log.toMap());
      return true;
    } catch (e) {
      print('Error logging medicine: $e');
      return false;
    }
  }
}
