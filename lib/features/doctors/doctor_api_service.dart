import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/core/config.dart';

class DoctorApiService {
  static String get baseUrl => Config.apiBaseUrl;
  static const String endpoint = '/doctors';

  // ==================== DOCTORS ====================

  /// Get all doctors with optional filtering and sorting
  static Future<List<DoctorModel>> getDoctors({
    String? search,
    String? wilaya,
    String? specialty,
    String? gender,
    double? minRating,
    int? minReviews,
    double? maxDistance,
    double? userLat,
    double? userLon,
    String sortBy = 'distance',
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (wilaya != null && wilaya != 'Use current location') {
        queryParams['wilaya'] = wilaya;
      }
      if (specialty != null) {
        queryParams['specialty'] = specialty;
      }
      if (gender != null) {
        queryParams['gender'] = gender;
      }
      if (minRating != null) {
        queryParams['min_rating'] = minRating.toString();
      }
      if (minReviews != null) {
        queryParams['min_reviews'] = minReviews.toString();
      }
      if (maxDistance != null) {
        queryParams['max_distance'] = maxDistance.toString();
      }
      if (userLat != null) {
        queryParams['user_lat'] = userLat.toString();
      }
      if (userLon != null) {
        queryParams['user_lon'] = userLon.toString();
      }
      queryParams['sort_by'] = sortBy;

      // Build URI with query parameters
      final uri = Uri.parse(
        '$baseUrl$endpoint/',
      ).replace(queryParameters: queryParams);

      // Make GET request
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DoctorModel.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load doctors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }

  /// Get a single doctor by ID
  static Future<DoctorModel> getDoctorById(
    String id, {
    double? userLat,
    double? userLon,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (userLat != null) {
        queryParams['user_lat'] = userLat.toString();
      }
      if (userLon != null) {
        queryParams['user_lon'] = userLon.toString();
      }

      // Build URI
      final uri = Uri.parse(
        '$baseUrl$endpoint/$id',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      // Make GET request
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return DoctorModel.fromMap(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Doctor not found');
      } else {
        throw Exception('Failed to load doctor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching doctor: $e');
    }
  }

  // ==================== SPECIALTIES ====================

  /// Get all available specialties
  static Future<List<String>> getSpecialties() async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/specialties/list');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      } else {
        throw Exception('Failed to load specialties: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching specialties: $e');
    }
  }

  // ==================== WILAYAS ====================

  /// Get all available wilayas
  static Future<List<String>> getWilayas() async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint/wilayas/list');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      } else {
        throw Exception('Failed to load wilayas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching wilayas: $e');
    }
  }
}
