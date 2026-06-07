import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/services/notifications_service.dart';

class ReturnResult {
  final bool state;
  final String message;

  ReturnResult({required this.state, required this.message});
}

abstract class AppointmentRepository {
  Future<List<AppointmentModel>> getAppointments(String userId);
  Future<List<AppointmentModel>> getAppointmentsByDate(
    String userId,
    DateTime date,
  );
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId);
  Future<ReturnResult> insertAppointment(AppointmentModel appointment);
  Future<ReturnResult> updateAppointment(AppointmentModel appointment);
  Future<ReturnResult> deleteAppointment(String id);
  Future<ReturnResult> updateAppointmentStatus(String id, bool isCompleted);

  // Singleton instance
  static AppointmentRepository? _instance;

  static AppointmentRepository getInstance() {
    if (_instance == null) {
      _instance = AppointmentDB();
    }
    return _instance!;
  }
}

class AppointmentDB extends AppointmentRepository {
  @override
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'appointments',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'appointment_date ASC',
      );
      return result.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final dateStr = date.toIso8601String().split('T')[0];

      final result = await db.query(
        'appointments',
        where: 'user_id = ? AND DATE(appointment_date) = ?',
        whereArgs: [userId, dateStr],
        orderBy: 'appointment_date ASC',
      );
      return result.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    try {
      final db = await DatabaseHelper.instance.database;
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
      return [];
    }
  }

  @override
  Future<ReturnResult> insertAppointment(AppointmentModel appointment) async {
    if (appointment.title.trim().isEmpty) {
      return ReturnResult(
        state: false,
        message: 'Appointment title is required',
      );
    }

    if (appointment.title.trim().length <= 2) {
      return ReturnResult(
        state: false,
        message: 'Appointment title length should be > 2',
      );
    }

    try {
      final dbHelper = DatabaseHelper.instance;
      final db = await dbHelper.database;
      await db.insert('appointments', appointment.toMap());

      // Fire-and-forget: schedule a heads-up 1 hour before the appointment.
      final reminderAt =
          appointment.appointmentDate.subtract(const Duration(hours: 1));
      if (reminderAt.isAfter(DateTime.now())) {
        try {
          await NotificationsService.instance.scheduleAppointmentAlert(
            key: 'appt-${appointment.id}',
            title: 'Upcoming: ${appointment.title}',
            body: appointment.doctorName == null
                ? 'Starts in 1 hour'
                : 'with ${appointment.doctorName} — starts in 1 hour',
            when: reminderAt,
          );
        } catch (_) {
          // Best-effort.
        }
      }

      return ReturnResult(
        state: true,
        message: 'Appointment added successfully',
      );
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Error adding appointment: $e',
      );
    }
  }

  @override
  Future<ReturnResult> updateAppointment(AppointmentModel appointment) async {
    if (appointment.id.isEmpty) {
      return ReturnResult(state: false, message: 'ID is required for update');
    }

    if (appointment.title.trim().isEmpty) {
      return ReturnResult(
        state: false,
        message: 'Appointment title is required',
      );
    }

    if (appointment.title.trim().length <= 2) {
      return ReturnResult(
        state: false,
        message: 'Appointment title length should be > 2',
      );
    }

    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.update(
        'appointments',
        appointment.toMap(),
        where: 'id = ?',
        whereArgs: [appointment.id],
      );

      if (count > 0) {
        return ReturnResult(
          state: true,
          message: 'Appointment updated successfully',
        );
      } else {
        return ReturnResult(state: false, message: 'Appointment not found');
      }
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Error updating appointment: $e',
      );
    }
  }

  @override
  Future<ReturnResult> deleteAppointment(String id) async {
    if (id.isEmpty) {
      return ReturnResult(state: false, message: 'ID is required for delete');
    }

    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.delete(
        'appointments',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count > 0) {
        return ReturnResult(
          state: true,
          message: 'Appointment deleted successfully',
        );
      } else {
        return ReturnResult(state: false, message: 'Appointment not found');
      }
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Error deleting appointment: $e',
      );
    }
  }

  @override
  Future<ReturnResult> updateAppointmentStatus(
    String id,
    bool isCompleted,
  ) async {
    if (id.isEmpty) {
      return ReturnResult(
        state: false,
        message: 'ID is required for status update',
      );
    }

    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.update(
        'appointments',
        {'is_completed': isCompleted ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count > 0) {
        return ReturnResult(
          state: true,
          message: 'Appointment status updated successfully',
        );
      } else {
        return ReturnResult(state: false, message: 'Appointment not found');
      }
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Error updating appointment status: $e',
      );
    }
  }
}
