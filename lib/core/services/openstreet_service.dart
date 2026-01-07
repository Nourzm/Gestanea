import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class OpenStreetMapService {
  final http.Client _client;
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  // Map configuration constants
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackageName = 'com.gestanea.app';
  static const String userAgentHeader = 'Gestanea/1.0 (com.gestanea.app)';
  static const double defaultZoom = 15.0;

  OpenStreetMapService({required http.Client client}) : _client = client;

  /// Search for places using OpenStreetMap Nominatim API
  Future<List<LocationResult>> searchLocation(String query) async {
    try {
      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': '10',
          'countrycodes': 'dz', // Restrict to Algeria
          'addressdetails': '1',
        },
      );

      final response = await _client.get(
        uri,
        headers: {
          'User-Agent': userAgentHeader, // Required by Nominatim
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LocationResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching location: $e');
    }
  }

  /// Reverse geocoding - get address from coordinates
  Future<LocationResult?> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl/reverse').replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'json',
          'addressdetails': '1',
        },
      );

      final response = await _client.get(
        uri,
        headers: {'User-Agent': userAgentHeader},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LocationResult.fromJson(data);
      } else {
        throw Exception('Failed to reverse geocode: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error reverse geocoding: $e');
    }
  }

  /// Get wilaya from coordinates
  Future<String?> getWilayaFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final result = await reverseGeocode(latitude, longitude);
      return result?.wilaya ?? result?.state;
    } catch (e) {
      print('Error getting wilaya: $e');
      return null;
    }
  }

  /// Create map options for flutter_map
  static MapOptions createMapOptions(double latitude, double longitude) {
    return MapOptions(
      initialCenter: LatLng(latitude, longitude),
      initialZoom: defaultZoom,
    );
  }

  /// Create tile layer for flutter_map
  static TileLayer createTileLayer() {
    return TileLayer(
      urlTemplate: tileUrlTemplate,
      userAgentPackageName: userAgentPackageName,
    );
  }

  /// Create marker for flutter_map
  static Marker createMarker({
    required double latitude,
    required double longitude,
    required Color color,
    double size = 50,
  }) {
    return Marker(
      point: LatLng(latitude, longitude),
      width: size,
      height: size,
      child: Icon(Icons.location_on, color: color, size: size),
    );
  }
}

/// Model for location search results
class LocationResult {
  final String displayName;
  final double latitude;
  final double longitude;
  final String? city;
  final String? state;
  final String? wilaya;
  final String? country;
  final String? postcode;

  LocationResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.city,
    this.state,
    this.wilaya,
    this.country,
    this.postcode,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>?;

    return LocationResult(
      displayName: json['display_name'] as String,
      latitude: double.parse(json['lat'].toString()),
      longitude: double.parse(json['lon'].toString()),
      city:
          address?['city'] as String? ??
          address?['town'] as String? ??
          address?['village'] as String?,
      state: address?['state'] as String?,
      wilaya: address?['state'] as String?, // In Algeria, state = wilaya
      country: address?['country'] as String?,
      postcode: address?['postcode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'display_name': displayName,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'wilaya': wilaya,
      'country': country,
      'postcode': postcode,
    };
  }

  /// Calculate distance to a doctor using Haversine formula
  double distanceTo(double doctorLat, double doctorLon) {
    const double earthRadius = 6371; // km

    final dLat = _toRadians(doctorLat - latitude);
    final dLon = _toRadians(doctorLon - longitude);

    final a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_toRadians(latitude)) *
            cos(_toRadians(doctorLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}
