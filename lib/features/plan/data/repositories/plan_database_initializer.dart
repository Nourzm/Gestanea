import 'package:gestanea/features/plan/data/repositories/plan_local_data_source.dart';
import 'package:gestanea/features/plan/data/mock_data/plan_mock_data.dart';
import 'package:gestanea/core/database/database_utils.dart';

/// Helper class to initialize plan database with mock data
class PlanDatabaseInitializer {
  final PlanLocalDataSource _dataSource = PlanLocalDataSource();

  /// Initialize database with mock data if it's empty
  Future<void> initializeWithMockData(String userId) async {
    try {
      // Ensure the user exists before inserting related data
      await DatabaseUtils.ensureUserExists(userId);

      // Check if there's already data
      final existingMedicines = await _dataSource.getMedicines(userId);
      final existingAppointments = await _dataSource.getAppointments(userId);

      // Only add mock data if database is empty
      if (existingMedicines.isEmpty) {
        final mockMedicines = PlanMockData.getMockMedicines();
        for (var medicine in mockMedicines) {
          await _dataSource.insertMedicine(medicine);
        }

        // Add medicine logs
        final mockLogs = PlanMockData.getMockMedicineLogs(mockMedicines);
        for (var log in mockLogs) {
          await _dataSource.logMedicine(log);
        }
      }

      if (existingAppointments.isEmpty) {
        final mockAppointments = PlanMockData.getMockAppointments();
        for (var appointment in mockAppointments) {
          await _dataSource.insertAppointment(appointment);
        }
      }
    } catch (e) {
      print('Error initializing plan database: $e');
      rethrow;
    }
  }

  /// Clear all data and reinitialize with mock data
  Future<void> resetWithMockData(String userId) async {
    try {
      // Ensure the user exists
      await DatabaseUtils.ensureUserExists(userId);

      // Get all existing data
      final medicines = await _dataSource.getMedicines(userId);
      final appointments = await _dataSource.getAppointments(userId);

      // Delete existing data
      for (var medicine in medicines) {
        await _dataSource.deleteMedicine(medicine.id);
      }
      for (var appointment in appointments) {
        await _dataSource.deleteAppointment(appointment.id);
      }

      // Reinitialize with mock data
      await initializeWithMockData(userId);
    } catch (e) {
      print('Error resetting plan database: $e');
      rethrow;
    }
  }
}
