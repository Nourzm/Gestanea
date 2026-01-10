import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/features/plan/data/datasources/medicine_local_data_source.dart';
import 'package:gestanea/features/plan/data/datasources/medicine_remote_data_source.dart';
import 'package:gestanea/core/services/connectivity_service.dart';

class ReturnResult {
  final bool state;
  final String message;

  ReturnResult({required this.state, required this.message});
}

/// Enhanced Medicine Repository with offline/online support
class MedicineRepository {
  final MedicineLocalDataSource _localDataSource;
  final MedicineRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  MedicineRepository({
    MedicineLocalDataSource? localDataSource,
    MedicineRemoteDataSource? remoteDataSource,
    ConnectivityService? connectivityService,
  }) : _localDataSource = localDataSource ?? MedicineLocalDataSource(),
       _remoteDataSource = remoteDataSource ?? MedicineRemoteDataSource(),
       _connectivityService = connectivityService ?? ConnectivityService();

  // Singleton instance
  static MedicineRepository? _instance;

  static MedicineRepository getInstance() {
    _instance ??= MedicineRepository();
    return _instance!;
  }

  /// Get medicines - tries remote first if online, falls back to local
  Future<List<MedicineModel>> getMedicines(String userId) async {
    if (_connectivityService.isOnline) {
      try {
        // Try to fetch from remote
        final remoteMedicines = await _remoteDataSource.getMedicines(userId);

        // If remote returns empty, check if we have local data
        if (remoteMedicines.isEmpty) {
          final localMedicines = await _localDataSource.getMedicines(userId);
          if (localMedicines.isNotEmpty) {
            print(
              'Remote empty, using local data (${localMedicines.length} items)',
            );
            return localMedicines;
          }
        }

        // Update local cache with remote data
        for (final medicine in remoteMedicines) {
          try {
            await _localDataSource.updateMedicine(medicine);
          } catch (e) {
            // If update fails, try insert (might be new)
            await _localDataSource.insertMedicine(medicine);
          }
        }

        return remoteMedicines;
      } catch (e) {
        print('Failed to fetch from remote, using local: $e');
        // Fallback to local on error
        return _localDataSource.getMedicines(userId);
      }
    } else {
      // Offline mode - use local database
      return _localDataSource.getMedicines(userId);
    }
  }

  /// Get medicines by date - tries remote first if online, falls back to local
  Future<List<MedicineModel>> getMedicinesByDate(
    String userId,
    DateTime date,
  ) async {
    if (_connectivityService.isOnline) {
      try {
        // Try to fetch from remote
        final remoteMedicines = await _remoteDataSource.getMedicinesByDate(
          userId,
          date,
        );

        // If remote returns empty, check if we have local data
        if (remoteMedicines.isEmpty) {
          final localMedicines = await _localDataSource.getMedicinesByDate(
            userId,
            date,
          );
          if (localMedicines.isNotEmpty) {
            print(
              'Remote empty, using local data (${localMedicines.length} items)',
            );
            return localMedicines;
          }
        }

        // Update local cache with remote data
        for (final medicine in remoteMedicines) {
          try {
            await _localDataSource.updateMedicine(medicine);
          } catch (e) {
            await _localDataSource.insertMedicine(medicine);
          }
        }

        return remoteMedicines;
      } catch (e) {
        print('Failed to fetch from remote, using local: $e');
        return _localDataSource.getMedicinesByDate(userId, date);
      }
    } else {
      return _localDataSource.getMedicinesByDate(userId, date);
    }
  }

  /// Get medicine logs - tries remote first if online, falls back to local
  Future<List<MedicineLoggedModel>> getMedicineLogs(
    String userId,
    DateTime date,
  ) async {
    if (_connectivityService.isOnline) {
      try {
        final remoteLogs = await _remoteDataSource.getMedicineLogs(
          userId,
          date,
        );

        // If remote returns empty, check if we have local data
        if (remoteLogs.isEmpty) {
          final localLogs = await _localDataSource.getMedicineLogs(
            userId,
            date,
          );
          if (localLogs.isNotEmpty) {
            print('Remote empty, using local data (${localLogs.length} logs)');
            return localLogs;
          }
        }

        return remoteLogs;
      } catch (e) {
        print('Failed to fetch logs from remote, using local: $e');
        return _localDataSource.getMedicineLogs(userId, date);
      }
    } else {
      return _localDataSource.getMedicineLogs(userId, date);
    }
  }

  /// Insert medicine - saves locally first, then syncs to remote if online
  Future<ReturnResult> insertMedicine(MedicineModel medicine) async {
    // Always save to local first for offline support
    final localSuccess = await _localDataSource.insertMedicine(medicine);

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to save medicine locally',
      );
    }

    // If online, also save to remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.insertMedicine(medicine);
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Medicine added successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Medicine added locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Medicine added locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Medicine added locally (offline mode)',
      );
    }
  }

  /// Update medicine - updates locally first, then syncs to remote if online
  Future<ReturnResult> updateMedicine(MedicineModel medicine) async {
    // Always update local first
    final localSuccess = await _localDataSource.updateMedicine(medicine);

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to update medicine locally',
      );
    }

    // If online, also update remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.updateMedicine(medicine);
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Medicine updated successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Medicine updated locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync update to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Medicine updated locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Medicine updated locally (offline mode)',
      );
    }
  }

  /// Delete medicine - deletes locally first, then syncs to remote if online
  Future<ReturnResult> deleteMedicine(String id) async {
    // Always delete from local first
    final localSuccess = await _localDataSource.deleteMedicine(id);

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to delete medicine locally',
      );
    }

    // If online, also delete from remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.deleteMedicine(id);
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Medicine deleted successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Medicine deleted locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync deletion to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Medicine deleted locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Medicine deleted locally (offline mode)',
      );
    }
  }

  /// Log medicine - logs locally first, then syncs to remote if online
  Future<ReturnResult> logMedicine(MedicineLoggedModel log) async {
    // Always log locally first
    final localSuccess = await _localDataSource.logMedicine(log);

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to log medicine locally',
      );
    }

    // If online, also log to remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.logMedicine(log);
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Medicine logged successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Medicine logged locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync log to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Medicine logged locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Medicine logged locally (offline mode)',
      );
    }
  }
}
