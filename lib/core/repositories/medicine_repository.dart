import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/medicine.dart';
import 'package:gestanea/core/models/medicine_log.dart';

class MedicineRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Medicines
  Future<Result<List<Medicine>>> getMedicines(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'medicines',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      final medicines = maps.map((m) => Medicine.fromMap(m)).toList();
      return Result.success(medicines);
    } catch (e) {
      return Result.failure('Failed to get medicines: ${e.toString()}');
    }
  }

  Future<Result<List<Medicine>>> getActiveMedicines(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'medicines',
        where: 'user_id = ? AND is_active = ?',
        whereArgs: [userId, 1],
        orderBy: 'created_at DESC',
      );
      final medicines = maps.map((m) => Medicine.fromMap(m)).toList();
      return Result.success(medicines);
    } catch (e) {
      return Result.failure('Failed to get active medicines: ${e.toString()}');
    }
  }

  Future<Result<Medicine>> addMedicine(Medicine medicine) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('medicines', medicine.toMap());
      return Result.success(medicine, 'Medicine added successfully');
    } catch (e) {
      return Result.failure('Failed to add medicine: ${e.toString()}');
    }
  }

  Future<Result<Medicine>> updateMedicine(Medicine medicine) async {
    try {
      final db = await _dbHelper.database;
      await db.update('medicines', medicine.toMap(), where: 'id = ?', whereArgs: [medicine.id]);
      return Result.success(medicine, 'Medicine updated successfully');
    } catch (e) {
      return Result.failure('Failed to update medicine: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteMedicine(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Medicine deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete medicine: ${e.toString()}');
    }
  }

  // Medicine Logs
  Future<Result<List<MedicineLog>>> getMedicineLogs(String medicineId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'medicine_logs',
        where: 'medicine_id = ?',
        whereArgs: [medicineId],
        orderBy: 'scheduled_time DESC',
      );
      final logs = maps.map((m) => MedicineLog.fromMap(m)).toList();
      return Result.success(logs);
    } catch (e) {
      return Result.failure('Failed to get medicine logs: ${e.toString()}');
    }
  }

  Future<Result<MedicineLog>> addMedicineLog(MedicineLog log) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('medicine_logs', log.toMap());
      return Result.success(log, 'Medicine log added successfully');
    } catch (e) {
      return Result.failure('Failed to add medicine log: ${e.toString()}');
    }
  }

  Future<Result<MedicineLog>> updateMedicineLog(MedicineLog log) async {
    try {
      final db = await _dbHelper.database;
      await db.update('medicine_logs', log.toMap(), where: 'id = ?', whereArgs: [log.id]);
      return Result.success(log, 'Medicine log updated successfully');
    } catch (e) {
      return Result.failure('Failed to update medicine log: ${e.toString()}');
    }
  }
}
