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
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(medicine.toMap()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create medicine: ${response.statusCode}');
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
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(log.toMap()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to log medicine: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error logging medicine via API: $e');
      return false;
    }
  }
}
