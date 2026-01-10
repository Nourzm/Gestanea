import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/database/models/lab_result_model.dart';
import '../datasources/lab_results_local_data_source.dart';
import '../datasources/lab_results_remote_data_source.dart';

class LabResultsRepository {
  final LabResultsLocalDataSource _localDataSource;
  final LabResultsRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity = Connectivity();

  LabResultsRepository({
    LabResultsLocalDataSource? localDataSource,
    LabResultsRemoteDataSource? remoteDataSource,
  })  : _localDataSource = localDataSource ?? LabResultsLocalDataSource(),
        _remoteDataSource = remoteDataSource ?? LabResultsRemoteDataSource();

  /// Check if device has internet connection
  Future<bool> _hasConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Get lab results - tries remote first, falls back to local
  Future<List<LabResultModel>> getLabResults(String userId) async {
    final hasConnection = await _hasConnection();

    if (hasConnection) {
      try {
        // Fetch from remote
        final remoteResults = await _remoteDataSource.getLabResults(userId);
        
        // Save to local for offline access
        await _syncLocalWithRemote(remoteResults);
        
        return remoteResults;
      } catch (e) {
        print('Remote fetch failed, falling back to local: $e');
        // Fallback to local if remote fails
        return await _localDataSource.getLabResults(userId);
      }
    } else {
      // No connection, use local data
      return await _localDataSource.getLabResults(userId);
    }
  }

  /// Add lab result - saves to both local and remote
  Future<void> addLabResult(LabResultModel labResult) async {
    print('Repository: Adding lab result to local storage');
    // Always save to local first
    await _localDataSource.addLabResult(labResult);
    print('Repository: Lab result saved to local storage');

    // Try to sync to remote if connected
    final hasConnection = await _hasConnection();
    print('Repository: Has connection: $hasConnection');
    if (hasConnection) {
      try {
        print('Repository: Syncing to Supabase');
        await _remoteDataSource.addLabResult(labResult);
        print('Repository: Successfully synced to Supabase');
      } catch (e) {
        print('Failed to sync to remote, will retry later: $e');
        // TODO: Add to pending sync queue
      }
    }
  }

  /// Update lab result
  Future<void> updateLabResult(LabResultModel labResult) async {
    await _localDataSource.updateLabResult(labResult);

    final hasConnection = await _hasConnection();
    if (hasConnection) {
      try {
        await _remoteDataSource.updateLabResult(labResult);
      } catch (e) {
        print('Failed to sync update to remote: $e');
      }
    }
  }

  /// Delete lab result
  Future<void> deleteLabResult(String id) async {
    await _localDataSource.deleteLabResult(id);

    final hasConnection = await _hasConnection();
    if (hasConnection) {
      try {
        await _remoteDataSource.deleteLabResult(id);
      } catch (e) {
        print('Failed to sync deletion to remote: $e');
      }
    }
  }

  /// Get single lab result by ID
  Future<LabResultModel?> getLabResultById(String id) async {
    final hasConnection = await _hasConnection();

    if (hasConnection) {
      try {
        return await _remoteDataSource.getLabResultById(id);
      } catch (e) {
        print('Remote fetch failed, using local: $e');
        return await _localDataSource.getLabResultById(id);
      }
    } else {
      return await _localDataSource.getLabResultById(id);
    }
  }

  /// Get lab results by date range
  Future<List<LabResultModel>> getLabResultsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final hasConnection = await _hasConnection();

    if (hasConnection) {
      try {
        return await _remoteDataSource.getLabResultsByDateRange(
          userId,
          startDate,
          endDate,
        );
      } catch (e) {
        print('Remote fetch failed, using local: $e');
        return await _localDataSource.getLabResultsByDateRange(
          userId,
          startDate,
          endDate,
        );
      }
    } else {
      return await _localDataSource.getLabResultsByDateRange(
        userId,
        startDate,
        endDate,
      );
    }
  }

  /// Sync local data with remote data
  Future<void> _syncLocalWithRemote(List<LabResultModel> remoteResults) async {
    try {
      // Clear local and replace with remote data
      await _localDataSource.clearAll();
      await _localDataSource.saveMultiple(remoteResults);
    } catch (e) {
      print('Failed to sync local with remote: $e');
    }
  }

  /// Force sync - pull from remote and update local
  Future<void> forceSync(String userId) async {
    final hasConnection = await _hasConnection();
    if (!hasConnection) {
      throw Exception('No internet connection');
    }

    final remoteResults = await _remoteDataSource.getLabResults(userId);
    await _syncLocalWithRemote(remoteResults);
  }
}
