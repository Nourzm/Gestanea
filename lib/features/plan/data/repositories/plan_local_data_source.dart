import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/core/database/db_helper.dart';

class PlanLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // MEDICINES

  /// Get all active medicines for a user
  Future<List<MedicineModel>> getMedicines(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'medicines',
      where: 'user_id = ? AND is_active = ?',
      whereArgs: [userId, 1],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => MedicineModel.fromMap(map)).toList();
  }

  /// Get active medicines for a specific date
  Future<List<MedicineModel>> getMedicinesByDate(
    String userId,
    DateTime date,
  ) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.query(
      'medicines',
      where:
          'user_id = ? AND is_active = ? AND start_date <= ? AND (end_date IS NULL OR end_date >= ?)',
      whereArgs: [userId, 1, dateStr, dateStr],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => MedicineModel.fromMap(map)).toList();
  }

  /// Insert a new medicine
  Future<void> insertMedicine(MedicineModel medicine) async {
    final db = await _dbHelper.database;
    await db.insert('medicines', medicine.toMap());
  }

  /// Update medicine
  Future<void> updateMedicine(MedicineModel medicine) async {
    final db = await _dbHelper.database;
    await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  /// Delete medicine
  Future<void> deleteMedicine(String medicineId) async {
    final db = await _dbHelper.database;
    await db.delete('medicines', where: 'id = ?', whereArgs: [medicineId]);
  }

  /// Update medicine active status
  Future<void> updateMedicineStatus(String medicineId, bool isActive) async {
    final db = await _dbHelper.database;
    await db.update(
      'medicines',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [medicineId],
    );
  }

  // MEDICINE LOGS

  /// Get medicine logs for a specific date
  Future<List<MedicineLoggedModel>> getMedicineLogs(
    String userId,
    DateTime date,
  ) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.query(
      'medicine_logged',
      where: 'user_id = ? AND logged_date = ?',
      whereArgs: [userId, dateStr],
      orderBy: 'logged_at DESC',
    );
    return result.map((map) => MedicineLoggedModel.fromMap(map)).toList();
  }

  /// Get medicine logs for a specific medicine
  Future<List<MedicineLoggedModel>> getMedicineLogsByMedicineId(
    String medicineId,
  ) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'medicine_logged',
      where: 'medicine_id = ?',
      whereArgs: [medicineId],
      orderBy: 'logged_at DESC',
    );
    return result.map((map) => MedicineLoggedModel.fromMap(map)).toList();
  }

  /// Log medicine intake
  Future<void> logMedicine(MedicineLoggedModel log) async {
    final db = await _dbHelper.database;
    await db.insert('medicine_logged', log.toMap());
  }

  /// Update medicine log
  Future<void> updateMedicineLog(MedicineLoggedModel log) async {
    final db = await _dbHelper.database;
    await db.update(
      'medicine_logged',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  /// Delete medicine log
  Future<void> deleteMedicineLog(String logId) async {
    final db = await _dbHelper.database;
    await db.delete('medicine_logged', where: 'id = ?', whereArgs: [logId]);
  }

  /// Get medicine statistics for today
  Future<Map<String, int>> getTodayMedicineStats(String userId) async {
    final today = DateTime.now();
    final medicines = await getMedicinesByDate(userId, today);
    final logs = await getMedicineLogs(userId, today);

    final total = medicines.length;
    final taken = logs.where((l) => l.status == 'taken').length;
    final missed = logs.where((l) => l.status == 'missed').length;

    return {'total': total, 'taken': taken, 'missed': missed};
  }

  // APPOINTMENTS

  /// Get all appointments for a user
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'appointments',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'appointment_date ASC',
    );
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  /// Get appointments for a specific date
  Future<List<AppointmentModel>> getAppointmentsByDate(
    String userId,
    DateTime date,
  ) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.query(
      'appointments',
      where: 'user_id = ? AND DATE(appointment_date) = ?',
      whereArgs: [userId, dateStr],
      orderBy: 'appointment_date ASC',
    );
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  /// Get upcoming appointments
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final result = await db.query(
      'appointments',
      where: 'user_id = ? AND appointment_date >= ? AND is_completed = ?',
      whereArgs: [userId, now, 0],
      orderBy: 'appointment_date ASC',
      limit: 10,
    );
    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  /// Insert a new appointment
  Future<void> insertAppointment(AppointmentModel appointment) async {
    final db = await _dbHelper.database;
    await db.insert('appointments', appointment.toMap());
  }

  /// Update appointment
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final db = await _dbHelper.database;
    await db.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  /// Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [appointmentId],
    );
  }

  /// Update appointment completion status
  Future<void> updateAppointmentStatus(
    String appointmentId,
    bool isCompleted,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      'appointments',
      {'is_completed': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [appointmentId],
    );
  }

  /// Get upcoming appointment count
  Future<int> getUpcomingAppointmentsCount(String userId) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM appointments WHERE user_id = ? AND appointment_date >= ? AND is_completed = ?',
      [userId, now, 0],
    );
    return result.first['count'] as int;
  }
}
