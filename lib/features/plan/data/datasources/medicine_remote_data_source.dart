import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/config.dart';
import 'medicine_local_data_source.dart';

/// Remote API implementation of medicine data source
class MedicineRemoteDataSource implements MedicineDataSource {
  static String get baseUrl => Config.apiBaseUrl;
  static const String endpoint = '/medicines';

  @override
  Future<List<MedicineModel>> getMedicines(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint?user_id=$userId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MedicineModel.fromMap(json)).toList();
      } else {
        print('Failed to fetch medicines: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching medicines from API: $e');
      return [];
    }
  }

  @override
  Future<List<MedicineModel>> getMedicinesByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final uri = Uri.parse('$baseUrl$endpoint?user_id=$userId&date=$dateStr');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MedicineModel.fromMap(json)).toList();
      } else {
        print('Failed to fetch medicines by date: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching medicines by date from API: $e');
      return [];
    }
  }

  @override
  Future<List<MedicineLoggedModel>> getMedicineLogs(
    String userId,
    DateTime date,
  ) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final uri = Uri.parse(
        '$baseUrl$endpoint/logs/?user_id=$userId&date=$dateStr',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MedicineLoggedModel.fromMap(json)).toList();
      } else {
        print('Failed to fetch medicine logs: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching medicine logs from API: $e');
      return [];
    }
  }

  @override
  Future<bool> insertMedicine(MedicineModel medicine) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/');

      // Prepare data for backend - send the local ID to maintain consistency
      // between local and remote databases
      final medicineData = {
        'id': medicine.id, // Send the local ID
        'user_id': medicine.userId,
        'baby_id': medicine.babyId,
        'medicine_name': medicine.medicineName,
        'dosage': medicine.dosage,
        'type': medicine.type,
        'frequency_type': medicine.frequencyType,
        'frequency_value': medicine.frequencyValue,
        'scheduled_times': medicine.scheduledTimes, // Send as list
        'start_date': medicine.startDate.toIso8601String().split('T')[0],
        'end_date': medicine.endDate?.toIso8601String().split('T')[0],
        'medicine_image_url': medicine.medicineImageUrl,
        'is_active': medicine.isActive ? 1 : 0,
        'created_at': medicine.createdAt.toIso8601String(),
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(medicineData),
      );

      if (response.statusCode == 201) {
        print('✅ Medicine created successfully in Supabase');
        return true;
      } else {
        print('Failed to create medicine: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating medicine via API: $e');
      return false;
    }
  }

  @override
  Future<bool> updateMedicine(MedicineModel medicine) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/${medicine.id}');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(medicine.toMap()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update medicine: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating medicine via API: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteMedicine(String id) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/$id');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete medicine: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error deleting medicine via API: $e');
      return false;
    }
  }

  @override
  Future<bool> logMedicine(MedicineLoggedModel log) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/logs/');

      // Prepare log data for backend - only send fields that exist in Supabase table
      final logData = {
        'id': log.id,
        'medicine_id': log.medicineId,
        'user_id': log.userId,
        'logged_date': log.loggedDate.toIso8601String().split('T')[0],
        'logged_at': log.loggedAt.toIso8601String(),
        'status': log.status,
        'notes': log.notes,
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(logData),
      );

      if (response.statusCode == 201) {
        print('✅ Medicine log created successfully in Supabase');
        return true;
      } else {
        print('Failed to log medicine: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error logging medicine via API: $e');
      return false;
    }
  }
}
