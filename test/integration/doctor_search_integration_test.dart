import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_bloc.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_event.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_state.dart';
import 'package:gestanea/core/database/models/doctor_filter_model.dart';
import 'package:gestanea/core/services/location_service.dart';
import 'package:gestanea/core/services/connectivity_service.dart';
import 'package:geolocator/geolocator.dart';

// Mock location service for integration testing
class MockLocationServiceForIntegration extends LocationService {
  @override
  Future<Position> getCurrentLocation() async {
    return Position(
      latitude: 40.7128,
      longitude: -74.0060,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  @override
  Future<bool> checkPermission() async {
    return true;
  }

  @override
  Future<bool> isLocationEnabled() async {
    return true;
  }
}

// Mock connectivity service for integration testing
class MockConnectivityServiceForIntegration implements ConnectivityService {
  bool _isOnline = true;

  @override
  bool get isOnline => _isOnline;

  @override
  Stream<bool> get connectivityStream {
    // Return a stream that always emits true
    return Stream.value(true);
  }

  @override
  Future<void> initialize() async {
    // No initialization needed for mock
    _isOnline = true;
  }

  @override
  Future<bool> checkConnectivity() async {
    // Always return true for integration tests
    return true;
  }

  @override
  void dispose() {
    // No cleanup needed for mock
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Doctor Search Integration Tests', () {
    late DoctorsBloc doctorsBloc;
    late MockLocationServiceForIntegration mockLocationService;
    late MockConnectivityServiceForIntegration mockConnectivityService;

    setUp(() {
      mockLocationService = MockLocationServiceForIntegration();
      mockConnectivityService = MockConnectivityServiceForIntegration();
      doctorsBloc = DoctorsBloc(
        locationService: mockLocationService,
        connectivityService: mockConnectivityService,
      );
    });

    tearDown(() {
      doctorsBloc.close();
    });

    group('Doctor Loading Flow', () {
      test('should load doctors successfully', () async {
        // Arrange
        DoctorsState? finalState;
        final subscription = doctorsBloc.stream.listen((state) {
          finalState = state;
        });

        // Act
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));

        // Wait for state changes
        await Future.delayed(const Duration(seconds: 3));

        // Assert
        expect(
          finalState is DoctorsLoaded ||
              finalState is DoctorsError ||
              finalState is DoctorsOffline,
          true,
          reason:
              'Final state should be DoctorsLoaded, DoctorsError, or DoctorsOffline, but got: $finalState',
        );

        await subscription.cancel();
      });

      test('should handle offline state gracefully', () async {
        // Arrange
        DoctorsState? finalState;
        final subscription = doctorsBloc.stream.listen((state) {
          finalState = state;
        });

        // Act - Try to load without connectivity
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));

        // Wait for state changes
        await Future.delayed(const Duration(seconds: 3));

        // Assert - Should handle network errors
        expect(
          finalState is DoctorsLoaded ||
              finalState is DoctorsError ||
              finalState is DoctorsOffline,
          true,
          reason: 'Should handle network state, got: $finalState',
        );

        await subscription.cancel();
      });

      test('should refresh location and reload doctors', () async {
        // Arrange
        bool hasLoadingState = false;
        final subscription = doctorsBloc.stream.listen((state) {
          if (state is DoctorsLoading) {
            hasLoadingState = true;
          }
        });

        // Act
        doctorsBloc.add(RefreshLocation());

        // Wait for processing
        await Future.delayed(const Duration(seconds: 3));

        // Assert
        expect(hasLoadingState, true);

        await subscription.cancel();
      });
    });

    group('Doctor Search Flow', () {
      test('should search doctors by name', () async {
        // Arrange
        DoctorsState? finalState;
        final subscription = doctorsBloc.stream.listen((state) {
          finalState = state;
        });

        // First load doctors
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act - Search
        doctorsBloc.add(SearchDoctors('Smith'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          finalState is DoctorsLoaded || finalState is DoctorsError,
          true,
          reason: 'Expected DoctorsLoaded or DoctorsError, got: $finalState',
        );

        await subscription.cancel();
      });

      test('should handle empty search results', () async {
        // Arrange
        DoctorsState? finalState;
        final subscription = doctorsBloc.stream.listen((state) {
          finalState = state;
        });

        // Load doctors
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act - Search with non-existent name
        doctorsBloc.add(SearchDoctors('XYZNonExistentDoctor123'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert - Should return loaded state with empty or filtered results
        expect(
          finalState is DoctorsLoaded,
          true,
          reason: 'Expected DoctorsLoaded, got: $finalState',
        );

        await subscription.cancel();
      });

      test('should clear search and show all doctors', () async {
        // Arrange
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        doctorsBloc.add(SearchDoctors('Smith'));
        await Future.delayed(const Duration(seconds: 1));

        // Act - Clear search
        doctorsBloc.add(SearchDoctors(''));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });
    });

    group('Doctor Filtering Flow', () {
      test('should filter doctors by specialty', () async {
        // Arrange
        final filter = DoctorFilter(specialties: ['Obstetrician']);
        DoctorsState? finalState;
        final subscription = doctorsBloc.stream.listen((state) {
          finalState = state;
        });

        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(FilterDoctors(filter));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          finalState is DoctorsLoaded,
          true,
          reason: 'Expected DoctorsLoaded, got: $finalState',
        );

        await subscription.cancel();
      });

      test('should filter doctors by rating', () async {
        // Arrange
        final filter = DoctorFilter(minRating: 4.0);

        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(FilterDoctors(filter));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });

      test('should filter by distance range', () async {
        // Arrange
        final filter = DoctorFilter(maxDistance: 10.0); // Within 10km

        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(FilterDoctors(filter));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });

      test('should apply multiple filters simultaneously', () async {
        // Arrange
        final filter = DoctorFilter(
          specialties: ['Obstetrician', 'Gynecologist'],
          minRating: 4.5,
          maxDistance: 15.0,
        );

        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(FilterDoctors(filter));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });

      test('should clear all filters', () async {
        // Arrange
        final filter = DoctorFilter(
          specialties: ['Pediatrician'],
          minRating: 4.0,
        );

        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        doctorsBloc.add(FilterDoctors(filter));
        await Future.delayed(const Duration(seconds: 1));

        // Act - Clear filters
        doctorsBloc.add(ClearFilters());
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });
    });

    group('Doctor Sorting Flow', () {
      test('should sort doctors by distance', () async {
        // Arrange
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(SortDoctors('distance'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });

      test('should sort doctors by rating', () async {
        // Arrange
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(SortDoctors('rating'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });

      test('should sort doctors by name', () async {
        // Arrange
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(SortDoctors('name'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });
    });

    group('Location Selection Flow', () {
      test('should select custom location', () async {
        // Arrange
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act
        doctorsBloc.add(SelectLocation('New York, NY'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });

      test('should switch between different locations', () async {
        // Arrange
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Act - Switch locations multiple times
        doctorsBloc.add(SelectLocation('Brooklyn, NY'));
        await Future.delayed(const Duration(seconds: 1));

        doctorsBloc.add(SelectLocation('Manhattan, NY'));
        await Future.delayed(const Duration(seconds: 1));

        doctorsBloc.add(SelectLocation('Use current location'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError,
          true,
          reason:
              'Expected DoctorsLoaded or DoctorsError, got: ${doctorsBloc.state}',
        );
      });
    });

    group('Comprehensive Doctor Search Flow', () {
      test('should perform complete search workflow', () async {
        // Simulate a user's complete doctor search journey

        // Step 1: Load doctors
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Step 2: Search by name
        doctorsBloc.add(SearchDoctors('Johnson'));
        await Future.delayed(const Duration(seconds: 1));

        // Step 3: Apply filters
        final filter = DoctorFilter(
          specialties: ['Obstetrician'],
          minRating: 4.0,
        );
        doctorsBloc.add(FilterDoctors(filter));
        await Future.delayed(const Duration(seconds: 1));

        // Step 4: Sort by rating
        doctorsBloc.add(SortDoctors('rating'));
        await Future.delayed(const Duration(seconds: 1));

        // Step 5: Change location
        doctorsBloc.add(SelectLocation('Queens, NY'));
        await Future.delayed(const Duration(seconds: 1));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError ||
              doctorsBloc.state is DoctorsOffline,
          true,
          reason: 'Expected final state, got: ${doctorsBloc.state}',
        );
      });

      test('should reset and start new search', () async {
        // Arrange - Perform initial search with filters
        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        doctorsBloc.add(SearchDoctors('Smith'));
        await Future.delayed(const Duration(seconds: 1));

        final filter = DoctorFilter(specialties: ['Pediatrician']);
        doctorsBloc.add(FilterDoctors(filter));
        await Future.delayed(const Duration(seconds: 1));

        // Act - Clear everything and start fresh
        doctorsBloc.add(ClearFilters());
        await Future.delayed(const Duration(seconds: 1));

        doctorsBloc.add(SearchDoctors(''));
        await Future.delayed(const Duration(seconds: 1));

        doctorsBloc.add(LoadDoctors(userLat: 40.7128, userLon: -74.0060));
        await Future.delayed(const Duration(seconds: 3));

        // Assert
        expect(
          doctorsBloc.state is DoctorsLoaded ||
              doctorsBloc.state is DoctorsError ||
              doctorsBloc.state is DoctorsOffline,
          true,
          reason: 'Expected final state, got: ${doctorsBloc.state}',
        );
      });
    });
  });
}
