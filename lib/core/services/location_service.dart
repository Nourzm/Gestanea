import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permissions with proper flow
  Future<LocationPermissionResult> checkAndRequestPermissions() async {
    // First check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionResult.serviceDisabled;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // Handle denied permission - request it
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionResult.denied;
      }
    }

    // Handle permanently denied permission
    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult.deniedForever;
    }

    return LocationPermissionResult.granted;
  }

  /// Get current user location
  Future<Position?> getCurrentLocation() async {
    try {
      final permissionResult = await checkAndRequestPermissions();

      if (permissionResult != LocationPermissionResult.granted) {
        print('Location permission not granted: $permissionResult');
        return null;
      }

      // Get current position with high accuracy
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Calculate distance between two points using Haversine formula (in kilometers)
  double calculateDistance(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) {
    const double earthRadius = 6371; // km

    final dLat = _toRadians(endLat - startLat);
    final dLon = _toRadians(endLon - startLon);

    final a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_toRadians(startLat)) *
            cos(_toRadians(endLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Open device location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}

enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}
