import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/core/database/db_helper.dart';

/// Abstract interface for appointment data operations
abstract class AppointmentDataSource {
  Future<List<AppointmentModel>> getAppointments(String userId);
  Future<List<AppointmentModel>> getAppointmentsByDate(
    String userId,
    DateTime date,
  );
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId);
  Future<bool> insertAppointment(AppointmentModel appointment);
  Future<bool> updateAppointment(AppointmentModel appointment);
  Future<bool> deleteAppointment(String id);
  Future<bool> updateAppointmentStatus(String id, bool isCompleted);
}

/// Local database implementation of appointment data source
class AppointmentLocalDataSource implements AppointmentDataSource {
  final DatabaseHelper _dbHelper;

  AppointmentLocalDataSource({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'appointments',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'appointment_date ASC',
      );
      return result.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      print('Error getting appointments: $e');
      return [];
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = date.toIso8601String().split('T')[0];

      final result = await db.query(
        'appointments',
        where: 'user_id = ? AND DATE(appointment_date) = ?',
        whereArgs: [userId, dateStr],
        orderBy: 'appointment_date ASC',
      );
      return result.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      print('Error getting appointments by date: $e');
      return [];
    }
  }

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    try {
      final db = await _dbHelper.database;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day).toIso8601String();

      final result = await db.query(
        'appointments',
        where:
            'user_id = ? AND DATE(appointment_date) >= DATE(?) AND is_completed = 0',
        whereArgs: [userId, today],
        orderBy: 'appointment_date ASC',
        limit: 10,
      );
      return result.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      print('Error getting upcoming appointments: $e');
      return [];
    }
  }

  @override
  Future<bool> insertAppointment(AppointmentModel appointment) async {
    if (appointment.title.trim().isEmpty) {
      print('Appointment title is required');
      return false;
    }

    if (appointment.title.trim().length <= 2) {
      print('Appointment title length should be > 2');
      return false;
    }

    try {
      final db = await _dbHelper.database;
      await db.insert('appointments', appointment.toMap());
      return true;
    } catch (e) {
      print('Error inserting appointment: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAppointment(AppointmentModel appointment) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.update(
        'appointments',
        appointment.toMap(),
        where: 'id = ?',
        whereArgs: [appointment.id],
      );
      return count > 0;
    } catch (e) {
      print('Error updating appointment: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteAppointment(String id) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.delete(
        'appointments',
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      print('Error deleting appointment: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAppointmentStatus(String id, bool isCompleted) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.update(
        'appointments',
        {'is_completed': isCompleted ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      print('Error updating appointment status: $e');
      return false;
    }
  }
}
