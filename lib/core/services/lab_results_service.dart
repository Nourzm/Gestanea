import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../database/models/lab_result_model.dart';
import '../database/db_helper.dart';

class LabResultsService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Connectivity _connectivity = Connectivity();
  
  bool _isListeningToConnectivity = false;

  /// Check if device has internet connectivity
  Future<bool> _hasConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Get all lab results for the current user
  /// Uses Supabase when online, local database when offline
  Future<List<LabResultModel>> getLabResults() async {
    final hasConnection = await _hasConnectivity();
    print('DEBUG getLabResults: hasConnection=$hasConnection');

    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        print('DEBUG getLabResults: userId=$userId');
        if (userId == null) {
          // If not authenticated, fallback to local
          print('DEBUG getLabResults: No user ID, using local');
          return await _getLocalLabResults();
        }

        // Sync before fetching
        print('DEBUG getLabResults: Starting sync to Supabase');
        await _syncLocalToSupabase();

        print('DEBUG getLabResults: Querying Supabase with user_id=$userId');
        final response = await _supabase
            .from('lab_results')
            .select()
            .eq('user_id', userId.toString())
            .order('lab_date', ascending: false);

        print('DEBUG getLabResults: Got ${(response as List).length} lab results from Supabase');
        final labResults = (response as List)
            .map((map) => LabResultModel.fromMap(map))
            .toList();

        // Update local cache
        await _updateLocalCache(labResults);

        return labResults;
      } catch (e) {
        print('Error fetching from Supabase, using local: $e');
        return await _getLocalLabResults();
      }
    } else {
      // Offline mode
      return await _getLocalLabResults();
    }
  }

  /// Get lab results from local database
  Future<List<LabResultModel>> _getLocalLabResults() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'lab_results',
      orderBy: 'lab_date DESC',
    );
    return maps.map((map) => LabResultModel.fromMap(map)).toList();
  }

  /// Update local cache with Supabase data
  Future<void> _updateLocalCache(List<LabResultModel> labResults) async {
    try {
      final db = await _dbHelper.database;
      
      // Get IDs of unsynced records to preserve them
      final unsyncedMaps = await db.query(
        'lab_results',
        columns: ['id'],
        where: 'synced = 0',
      );
      final unsyncedIds = unsyncedMaps.map((m) => m['id'] as String).toSet();
      
      // Clear only synced lab results (keep unsynced ones)
      await db.delete('lab_results', where: 'synced = 1');
      
      // Insert fresh data from Supabase, but skip any that are unsynced locally
      for (final labResult in labResults) {
        if (!unsyncedIds.contains(labResult.id)) {
          await db.insert(
            'lab_results',
            {...labResult.toMap(), 'synced': 1},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
      print('Error updating local cache: $e');
    }
  }

  /// Sync unsynced local lab results to Supabase
  Future<void> _syncLocalToSupabase() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      print('DEBUG _syncLocalToSupabase: userId=$userId');
      if (userId == null) return;

      final db = await _dbHelper.database;
      final unsyncedMaps = await db.query(
        'lab_results',
        where: 'synced = 0',
      );
      
      print('DEBUG _syncLocalToSupabase: Found ${unsyncedMaps.length} unsynced lab results');

      for (final map in unsyncedMaps) {
        try {
          final labResult = LabResultModel.fromMap(map);
          
          print('DEBUG _syncLocalToSupabase: Syncing lab result ${labResult.id}');
          // Upload to Supabase
          await _supabase.from('lab_results').upsert({
            'id': labResult.id,
            'user_id': userId,
            'test_name': labResult.testName,
            'value': labResult.value,
            'unit': labResult.unit,
            'normal_range_min': labResult.normalRangeMin,
            'normal_range_max': labResult.normalRangeMax,
            'interpretation': labResult.interpretation,
            'lab_date': labResult.labDate.toIso8601String().split('T')[0],
            'report_image_url': labResult.reportImageUrl,
            'extracted_by_ocr': labResult.extractedByOcr ? 1 : 0,
            'created_at': labResult.createdAt.toIso8601String(),
          });

          // Mark as synced
          await db.update(
            'lab_results',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [labResult.id],
          );
        } catch (e) {
          print('Error syncing lab result ${map['id']}: $e');
        }
      }
    } catch (e) {
      print('Error syncing to Supabase: $e');
    }
  }

  /// Add a new lab result
  /// Saves to both Supabase (if online) and local database
  Future<void> addLabResult(LabResultModel labResult) async {
    final db = await _dbHelper.database;
    
    // Always save to local first (as unsynced if user is authenticated)
    final userId = _supabase.auth.currentUser?.id;
    final syncValue = userId != null ? 0 : 1; // 0 = needs sync, 1 = no user to sync
    
    await db.insert(
      'lab_results',
      {...labResult.toMap(), 'synced': syncValue},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Try to sync to Supabase if online and authenticated
    final hasConnection = await _hasConnectivity();
    if (hasConnection && userId != null) {
      try {
        await _supabase.from('lab_results').insert({
          'id': labResult.id,
          'user_id': userId,
          'test_name': labResult.testName,
          'value': labResult.value,
          'unit': labResult.unit,
          'normal_range_min': labResult.normalRangeMin,
          'normal_range_max': labResult.normalRangeMax,
          'interpretation': labResult.interpretation,
          'lab_date': labResult.labDate.toIso8601String().split('T')[0],
          'report_image_url': labResult.reportImageUrl,
          'extracted_by_ocr': labResult.extractedByOcr ? 1 : 0,
          'created_at': labResult.createdAt.toIso8601String(),
        });

        // Mark as synced
        await db.update(
          'lab_results',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [labResult.id],
        );
      } catch (e) {
        print('Failed to sync lab result to Supabase: $e');
        // Will retry on next getMeasurements call
      }
    }
  }

  /// Update a lab result
  /// Updates both Supabase (if online) and local database
  Future<void> updateLabResult(LabResultModel labResult) async {
    final db = await _dbHelper.database;
    
    // Update local (mark as unsynced)
    await db.update(
      'lab_results',
      {...labResult.toMap(), 'synced': 0},
      where: 'id = ?',
      whereArgs: [labResult.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Try to sync to Supabase if online
    final hasConnection = await _hasConnectivity();
    final userId = _supabase.auth.currentUser?.id;
    
    if (hasConnection && userId != null) {
      try {
        await _supabase
            .from('lab_results')
            .update({
              'test_name': labResult.testName,
              'value': labResult.value,
              'unit': labResult.unit,
              'normal_range_min': labResult.normalRangeMin,
              'normal_range_max': labResult.normalRangeMax,
              'interpretation': labResult.interpretation,
              'lab_date': labResult.labDate.toIso8601String().split('T')[0],
              'report_image_url': labResult.reportImageUrl,
              'extracted_by_ocr': labResult.extractedByOcr ? 1 : 0,
            })
            .eq('id', labResult.id);

        // Mark as synced
        await db.update(
          'lab_results',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [labResult.id],
        );
      } catch (e) {
        print('Failed to sync update to Supabase: $e');
        // Will retry on next getLabResults call
      }
    }
  }

  /// Delete a lab result
  /// Deletes from both Supabase (if online) and local database
  Future<void> deleteLabResult(String id) async {
    final db = await _dbHelper.database;
    
    // Delete from local
    await db.delete(
      'lab_results',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Try to delete from Supabase if online
    final hasConnection = await _hasConnectivity();
    if (hasConnection) {
      try {
        await _supabase
            .from('lab_results')
            .delete()
            .eq('id', id);
      } catch (e) {
        print('Failed to delete from Supabase: $e');
        // Local delete still succeeded
      }
    }
  }

  /// Get a single lab result by ID
  Future<LabResultModel?> getLabResultById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'lab_results',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return LabResultModel.fromMap(maps.first);
  }

  /// Get lab results by date range
  Future<List<LabResultModel>> getLabResultsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'lab_results',
      where: 'lab_date BETWEEN ? AND ?',
      whereArgs: [
        startDate.toIso8601String().split('T')[0],
        endDate.toIso8601String().split('T')[0],
      ],
      orderBy: 'lab_date DESC',
    );
    
    return maps.map((map) => LabResultModel.fromMap(map)).toList();
  }

  /// Start listening to connectivity changes and auto-sync when online
  void startConnectivityListener() {
    if (_isListeningToConnectivity) return;
    _isListeningToConnectivity = true;

    _connectivity.onConnectivityChanged.listen((result) async {
      print('DEBUG Connectivity changed: $result');
      if (result != ConnectivityResult.none) {
        print('DEBUG Connection restored, syncing lab results...');
        try {
          await _syncLocalToSupabase();
          print('DEBUG Auto-sync completed');
        } catch (e) {
          print('DEBUG Auto-sync failed: $e');
        }
      }
    });
  }
}
