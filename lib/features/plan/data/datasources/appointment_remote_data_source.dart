import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/core/config.dart';
import 'appointment_local_data_source.dart';

/// Remote API implementation of appointment data source
class AppointmentRemoteDataSource implements AppointmentDataSource {
  static String get baseUrl => Config.apiBaseUrl;
  static const String endpoint = '/appointments';

  @override
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint?user_id=$userId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AppointmentModel.fromMap(json)).toList();
      } else {
        print('Failed to fetch appointments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching appointments from API: $e');
      return [];
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final uri = Uri.parse('$baseUrl$endpoint?user_id=$userId&date=$dateStr');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AppointmentModel.fromMap(json)).toList();
      } else {
        print('Failed to fetch appointments by date: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching appointments by date from API: $e');
      return [];
    }
  }

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint?user_id=$userId&upcoming=true');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AppointmentModel.fromMap(json)).toList();
      } else {
        print('Failed to fetch upcoming appointments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching upcoming appointments from API: $e');
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
      final uri = Uri.parse('$baseUrl$endpoint/');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointment.toMap()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create appointment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error creating appointment via API: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAppointment(AppointmentModel appointment) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/${appointment.id}');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointment.toMap()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update appointment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating appointment via API: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteAppointment(String id) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/$id');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete appointment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error deleting appointment via API: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAppointmentStatus(String id, bool isCompleted) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint/$id/status?is_completed=$isCompleted',
      );
      final response = await http.patch(uri);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update appointment status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating appointment status via API: $e');
      return false;
    }
  }
}
