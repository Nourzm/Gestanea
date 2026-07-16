import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../database/models/measurement_model.dart';
import '../database/db_helper.dart';

class MeasurementsService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connectivity
  Future<bool> _hasConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      // For connectivity_plus 5.x, checkConnectivity() returns ConnectivityResult directly
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Get all measurements for the current user
  /// Uses Supabase when online, local database when offline
  Future<List<MeasurementModel>> getMeasurements() async {
    final hasConnection = await _hasConnectivity();
    print('DEBUG getMeasurements: hasConnection=$hasConnection');

    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        print('DEBUG getMeasurements: userId=$userId');
        if (userId == null) {
          // If not authenticated, fallback to local
          print('DEBUG getMeasurements: No user ID, using local');
          return await _getLocalMeasurements();
        }

        // Sync before fetching
        print('DEBUG getMeasurements: Starting sync to Supabase');
        await _syncLocalToSupabase();

        print('DEBUG getMeasurements: Querying Supabase with user_id=$userId');
        final response = await _supabase
            .from('measurements')
            .select()
            .eq('user_id', userId.toString())
            .order('recorded_at', ascending: false);

        print('DEBUG getMeasurements: Got ${(response as List).length} measurements from Supabase');
        final measurements = (response as List)
            .map((map) => MeasurementModel.fromMap(map))
            .toList();

        // Update local cache
        await _updateLocalCache(measurements);

        return measurements;
      } catch (e) {
        print('Error fetching from Supabase, using local: $e');
        return await _getLocalMeasurements();
      }
    } else {
      // Offline mode
      return await _getLocalMeasurements();
    }
  }

  /// Get measurements from local database
  Future<List<MeasurementModel>> _getLocalMeasurements() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'measurements',
      orderBy: 'recorded_at DESC',
    );
    return maps.map((map) => MeasurementModel.fromMap(map)).toList();
  }

  /// Update local cache with Supabase data
  Future<void> _updateLocalCache(List<MeasurementModel> measurements) async {
    try {
      final db = await _dbHelper.database;
      
      // Clear synced measurements
      await db.delete('measurements', where: 'synced = 1');
      
      // Insert fresh data from Supabase
      for (final measurement in measurements) {
        await db.insert(
          'measurements',
          {...measurement.toMap(), 'synced': 1},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print('Error updating local cache: $e');
    }
  }

  /// Sync unsynced local measurements to Supabase
  Future<void> _syncLocalToSupabase() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      print('DEBUG _syncLocalToSupabase: userId=$userId');
      if (userId == null) return;

      final db = await _dbHelper.database;
      final unsyncedMaps = await db.query(
        'measurements',
        where: 'synced = 0',
      );
      
      print('DEBUG _syncLocalToSupabase: Found ${unsyncedMaps.length} unsynced measurements');

      for (final map in unsyncedMaps) {
        try {
          final measurement = MeasurementModel.fromMap(map);
          
          print('DEBUG _syncLocalToSupabase: Syncing measurement ${measurement.id}');
          // Upload to Supabase
          await _supabase.from('measurements').upsert({
            'id': measurement.id,
            'user_id': userId,
            'weight': measurement.weight,
            'heart_rate': measurement.heartRate,
            'systolic': measurement.systolic,
            'diastolic': measurement.diastolic,
            'recorded_at': measurement.recordedAt.toIso8601String(),
            'notes': measurement.notes,
            'created_at': measurement.createdAt.toIso8601String(),
          });

          // Mark as synced
          await db.update(
            'measurements',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [measurement.id],
          );
        } catch (e) {
          print('Error syncing measurement ${map['id']}: $e');
        }
      }
    } catch (e) {
      print('Error syncing to Supabase: $e');
    }
  }

  /// Add a new measurement
  /// Saves to both Supabase (if online) and local database
  Future<void> addMeasurement(MeasurementModel measurement) async {
    final hasConnection = await _hasConnectivity();
    final db = await _dbHelper.database;

    // Always save locally first
    await db.insert(
      'measurements',
      {...measurement.toMap(), 'synced': hasConnection ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Try to save to Supabase if online
    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) {
          // Mark as unsynced if no user
          await db.update(
            'measurements',
            {'synced': 0},
            where: 'id = ?',
            whereArgs: [measurement.id],
          );
          return;
        }

        final insertData = {
          'id': measurement.id,
          'user_id': userId,
          'weight': measurement.weight,
          'heart_rate': measurement.heartRate,
          'systolic': measurement.systolic,
          'diastolic': measurement.diastolic,
          'recorded_at': measurement.recordedAt.toIso8601String(),
          'notes': measurement.notes,
          'created_at': measurement.createdAt.toIso8601String(),
        };
        
        print('DEBUG: Inserting measurement to Supabase: $insertData');
        await _supabase.from('measurements').insert(insertData);
        print('DEBUG: Successfully inserted measurement to Supabase');

        // Mark as synced on success
        await db.update(
          'measurements',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [measurement.id],
        );
      } catch (e, stackTrace) {
        print('Error adding to Supabase: $e');
        print('Stack trace: $stackTrace');
        // Mark as unsynced
        await db.update(
          'measurements',
          {'synced': 0},
          where: 'id = ?',
          whereArgs: [measurement.id],
        );
      }
    }
  }

  /// Update an existing measurement
  /// Updates both Supabase (if online) and local database
  Future<void> updateMeasurement(MeasurementModel measurement) async {
    final hasConnection = await _hasConnectivity();
    final db = await _dbHelper.database;

    // Always update locally first
    await db.update(
      'measurements',
      {...measurement.toMap(), 'synced': hasConnection ? 1 : 0},
      where: 'id = ?',
      whereArgs: [measurement.id],
    );

    // Try to update in Supabase if online
    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) {
          await db.update(
            'measurements',
            {'synced': 0},
            where: 'id = ?',
            whereArgs: [measurement.id],
          );
          return;
        }

        await _supabase
            .from('measurements')
            .update({
              'weight': measurement.weight,
              'heart_rate': measurement.heartRate,
              'systolic': measurement.systolic,
              'diastolic': measurement.diastolic,
              'recorded_at': measurement.recordedAt.toIso8601String(),
              'notes': measurement.notes,
            })
            .eq('id', measurement.id)
            .eq('user_id', userId);

        // Mark as synced
        await db.update(
          'measurements',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [measurement.id],
        );
      } catch (e) {
        print('Error updating in Supabase: $e');
        await db.update(
          'measurements',
          {'synced': 0},
          where: 'id = ?',
          whereArgs: [measurement.id],
        );
      }
    }
  }

  /// Delete a measurement
  /// Deletes from both Supabase (if online) and local database
  Future<void> deleteMeasurement(String id) async {
    final hasConnection = await _hasConnectivity();
    final db = await _dbHelper.database;

    // Try to delete from Supabase first if online
    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId != null) {
          await _supabase
              .from('measurements')
              .delete()
              .eq('id', id)
              .eq('user_id', userId);
        }
      } catch (e) {
        print('Error deleting from Supabase: $e');
        // Continue to delete locally anyway
      }
    }

    // Always delete locally
    await db.delete(
      'measurements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get the latest measurement
  Future<MeasurementModel?> getLatestMeasurement() async {
    try {
      final measurements = await getMeasurements();
      return measurements.isNotEmpty ? measurements.first : null;
    } catch (e) {
      print('Error fetching latest measurement: $e');
      return null;
    }
  }

  /// Get measurements within a date range
  Future<List<MeasurementModel>> getMeasurementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final measurements = await getMeasurements();
    return measurements.where((m) {
      return m.recordedAt.isAfter(startDate) &&
          m.recordedAt.isBefore(endDate);
    }).toList();
  }

  /// Manually trigger sync of local data to Supabase
  Future<void> syncNow() async {
    final hasConnection = await _hasConnectivity();
    if (hasConnection) {
      await _syncLocalToSupabase();
    }
  }

  /// Get count of unsynced measurements
  Future<int> getUnsyncedCount() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM measurements WHERE synced = 0',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
