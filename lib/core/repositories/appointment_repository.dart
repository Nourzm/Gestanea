import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/appointment.dart';

class AppointmentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<Appointment>>> getAppointments(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'appointments',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC, time DESC',
      );
      final appointments = maps.map((m) => Appointment.fromMap(m)).toList();
      return Result.success(appointments);
    } catch (e) {
      return Result.failure('Failed to get appointments: ${e.toString()}');
    }
  }

  Future<Result<Appointment>> addAppointment(Appointment appointment) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('appointments', appointment.toMap());
      return Result.success(appointment, 'Appointment added successfully');
    } catch (e) {
      return Result.failure('Failed to add appointment: ${e.toString()}');
    }
  }

  Future<Result<Appointment>> updateAppointment(Appointment appointment) async {
    try {
      final db = await _dbHelper.database;
      await db.update('appointments', appointment.toMap(), where: 'id = ?', whereArgs: [appointment.id]);
      return Result.success(appointment, 'Appointment updated successfully');
    } catch (e) {
      return Result.failure('Failed to update appointment: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteAppointment(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Appointment deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete appointment: ${e.toString()}');
    }
  }
}
