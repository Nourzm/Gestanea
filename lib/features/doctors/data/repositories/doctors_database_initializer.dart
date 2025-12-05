import 'package:gestanea/features/doctors/data/repositories/doctors_local_data_source.dart';
import 'package:gestanea/features/doctors/data/datasources/mock_doctor_data.dart';

/// Helper class to initialize doctors database with mock data
class DoctorsDatabaseInitializer {
  final DoctorsLocalDataSource _dataSource = DoctorsLocalDataSource();

  /// Initialize database with mock data if it's empty
  Future<void> initializeWithMockData() async {
    try {
      final hasData = await _dataSource.hasDoctors();

      // Only add mock data if database is empty
      if (!hasData) {
        final mockDoctors = MockDoctorData.getDoctors();
        await _dataSource.insertDoctors(mockDoctors);
      }
    } catch (e) {
      print('Error initializing doctors database: $e');
      rethrow;
    }
  }

  /// Get all doctors from database
  Future<dynamic> getDoctors() async {
    try {
      return await _dataSource.getDoctors();
    } catch (e) {
      print('Error getting doctors: $e');
      rethrow;
    }
  }
}
