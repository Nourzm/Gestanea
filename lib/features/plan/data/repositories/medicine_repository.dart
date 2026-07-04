import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/services/notifications_service.dart';

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
  // (No interface change — notifications are an internal side-effect of insert.)
  Future<ReturnResult> insertMedicine(MedicineModel medicine);
  Future<ReturnResult> updateMedicine(MedicineModel medicine);
  Future<ReturnResult> deleteMedicine(String id);
  Future<ReturnResult> logMedicine(MedicineLoggedModel log);

  // Singleton instance
  static MedicineRepository? _instance;

  static MedicineRepository getInstance() {
    _instance ??= MedicineDB();
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
      await _scheduleNotificationsFor(medicine);
      return ReturnResult(state: true, message: 'Medicine added successfully');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error adding medicine: $e');
    }
  }

  /// Schedule one local-notification per `scheduled_times` entry, anchored to
  /// today (or `startDate` if it's in the future). The plugin's
  /// `matchDateTimeComponents: time` makes it recur daily.
  Future<void> _scheduleNotificationsFor(MedicineModel medicine) async {
    final times = medicine.scheduledTimes;
    if (times == null || times.isEmpty) return;
    final now = DateTime.now();
    final base = medicine.startDate.isAfter(now) ? medicine.startDate : now;
    for (var i = 0; i < times.length; i++) {
      final parsed = _parseTimeOfDay(times[i]);
      if (parsed == null) continue;
      final when = DateTime(
        base.year,
        base.month,
        base.day,
        parsed.hour,
        parsed.minute,
      );
      // If today's time already passed, push to tomorrow.
      final fireAt = when.isAfter(now)
          ? when
          : when.add(const Duration(days: 1));
      try {
        await NotificationsService.instance.scheduleMedicineReminder(
          key: '${medicine.id}#$i',
          medicineName: medicine.medicineName,
          dose: medicine.dosage,
          when: fireAt,
        );
      } catch (_) {
        // Best-effort — never block a DB insert on notification failures.
      }
    }
  }

  ({int hour, int minute})? _parseTimeOfDay(String raw) {
    final parts = raw.trim().split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1].split(' ').first);
    if (h == null || m == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59) return null;
    return (hour: h, minute: m);
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
