import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/db_helper.dart';

class ReturnResult {
  final bool state;
  final String message;

  ReturnResult({required this.state, required this.message});
}

abstract class MedicineRepository {
  Future<List<MedicineModel>> getMedicines(String userId);
  Future<List<MedicineModel>> getMedicinesByDate(String userId, DateTime date);
  Future<List<MedicineLoggedModel>> getMedicineLogs(
    String userId,
    DateTime date,
  );
  Future<ReturnResult> insertMedicine(MedicineModel medicine);
  Future<ReturnResult> updateMedicine(MedicineModel medicine);
  Future<ReturnResult> deleteMedicine(String id);
  Future<ReturnResult> logMedicine(MedicineLoggedModel log);

  // Singleton instance
  static MedicineRepository? _instance;

  static MedicineRepository getInstance() {
    if (_instance == null) {
      _instance = MedicineDB();
    }
    return _instance!;
  }
}

class MedicineDB extends MedicineRepository {
  @override
  Future<List<MedicineModel>> getMedicines(String userId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'medicines',
        where: 'user_id = ? AND is_active = 1',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => MedicineModel.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<MedicineModel>> getMedicinesByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final db = await DatabaseHelper.instance.database;
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
      return [];
    }
  }

  @override
  Future<List<MedicineLoggedModel>> getMedicineLogs(
    String userId,
    DateTime date,
  ) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final dateStr = date.toIso8601String().split('T')[0];

      final result = await db.query(
        'medicine_logged',
        where: 'user_id = ? AND logged_date = ?',
        whereArgs: [userId, dateStr],
        orderBy: 'logged_at DESC',
      );
      return result.map((map) => MedicineLoggedModel.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ReturnResult> insertMedicine(MedicineModel medicine) async {
    if (medicine.medicineName.trim().isEmpty) {
      return ReturnResult(state: false, message: 'Medicine name is required');
    }

    if (medicine.medicineName.trim().length <= 2) {
      return ReturnResult(
        state: false,
        message: 'Medicine name length should be > 2',
      );
    }

    if (medicine.dosage.trim().isEmpty) {
      return ReturnResult(state: false, message: 'Dosage is required');
    }

    if (medicine.frequencyType.trim().isEmpty) {
      return ReturnResult(state: false, message: 'Frequency type is required');
    }

    try {
      final dbHelper = DatabaseHelper.instance;
      final db = await dbHelper.database;
      await db.insert('medicines', medicine.toMap());

      return ReturnResult(state: true, message: 'Medicine added successfully');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error adding medicine: $e');
    }
  }

  @override
  Future<ReturnResult> updateMedicine(MedicineModel medicine) async {
    if (medicine.id.isEmpty) {
      return ReturnResult(state: false, message: 'ID is required for update');
    }

    if (medicine.medicineName.trim().isEmpty) {
      return ReturnResult(state: false, message: 'Medicine name is required');
    }

    if (medicine.medicineName.trim().length <= 2) {
      return ReturnResult(
        state: false,
        message: 'Medicine name length should be > 2',
      );
    }

    if (medicine.dosage.trim().isEmpty) {
      return ReturnResult(state: false, message: 'Dosage is required');
    }

    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.update(
        'medicines',
        medicine.toMap(),
        where: 'id = ?',
        whereArgs: [medicine.id],
      );

      if (count > 0) {
        return ReturnResult(
          state: true,
          message: 'Medicine updated successfully',
        );
      } else {
        return ReturnResult(state: false, message: 'Medicine not found');
      }
    } catch (e) {
      return ReturnResult(state: false, message: 'Error updating medicine: $e');
    }
  }

  @override
  Future<ReturnResult> deleteMedicine(String id) async {
    if (id.isEmpty) {
      return ReturnResult(state: false, message: 'ID is required for delete');
    }

    try {
      final db = await DatabaseHelper.instance.database;

      // Soft delete by setting is_active to 0
      final count = await db.update(
        'medicines',
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count > 0) {
        return ReturnResult(
          state: true,
          message: 'Medicine deleted successfully',
        );
      } else {
        return ReturnResult(state: false, message: 'Medicine not found');
      }
    } catch (e) {
      return ReturnResult(state: false, message: 'Error deleting medicine: $e');
    }
  }

  @override
  Future<ReturnResult> logMedicine(MedicineLoggedModel log) async {
    if (log.medicineId.isEmpty) {
      return ReturnResult(state: false, message: 'Medicine ID is required');
    }

    if (log.userId.isEmpty) {
      return ReturnResult(state: false, message: 'User ID is required');
    }

    if (log.status.trim().isEmpty) {
      return ReturnResult(state: false, message: 'Status is required');
    }

    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('medicine_logged', log.toMap());

      return ReturnResult(
        state: true,
        message: 'Medicine log recorded successfully',
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'Error logging medicine: $e');
    }
  }
}
