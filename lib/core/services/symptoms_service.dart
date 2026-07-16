import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../database/models/symptom_model.dart';
import '../database/db_helper.dart';

class SymptomsService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connectivity
  Future<bool> _hasConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Get all symptoms for the current user
  /// Uses Supabase when online, local database when offline
  Future<List<SymptomModel>> getSymptoms() async {
    final hasConnection = await _hasConnectivity();
    print('DEBUG getSymptoms: hasConnection=$hasConnection');

    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        print('DEBUG getSymptoms: userId=$userId');
        if (userId == null) {
          print('DEBUG getSymptoms: No user ID, using local');
          return await _getLocalSymptoms();
        }

        // Sync before fetching
        print('DEBUG getSymptoms: Starting sync to Supabase');
        await _syncLocalToSupabase();

        final response = await _supabase
            .from('symptoms')
            .select()
            .eq('user_id', userId)
            .order('recorded_at', ascending: false);

        final symptoms = (response as List)
            .map((map) => SymptomModel.fromMap(map))
            .toList();

        // Update local cache
        await _updateLocalCache(symptoms);

        return symptoms;
      } catch (e) {
        print('Error fetching from Supabase, using local: $e');
        return await _getLocalSymptoms();
      }
    } else {
      // Offline mode
      return await _getLocalSymptoms();
    }
  }

  /// Get symptoms from local database
  Future<List<SymptomModel>> _getLocalSymptoms() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'symptoms',
      orderBy: 'recorded_at DESC',
    );
    return maps.map((map) => SymptomModel.fromMap(map)).toList();
  }

  /// Update local cache with Supabase data
  Future<void> _updateLocalCache(List<SymptomModel> symptoms) async {
    try {
      final db = await _dbHelper.database;
      
      // Clear synced symptoms
      await db.delete('symptoms', where: 'synced = 1');
      
      // Insert fresh data from Supabase
      for (final symptom in symptoms) {
        await db.insert(
          'symptoms',
          {...symptom.toMap(), 'synced': 1},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print('Error updating local cache: $e');
    }
  }

  /// Sync unsynced local symptoms to Supabase
  Future<void> _syncLocalToSupabase() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      print('DEBUG _syncLocalToSupabase: userId=$userId');
      if (userId == null) return;

      final db = await _dbHelper.database;
      final unsyncedMaps = await db.query(
        'symptoms',
        where: 'synced = 0',
      );
      
      print('DEBUG _syncLocalToSupabase: Found ${unsyncedMaps.length} unsynced symptoms');

      for (final map in unsyncedMaps) {
        try {
          final symptom = SymptomModel.fromMap(map);
          
          print('DEBUG _syncLocalToSupabase: Syncing symptom ${symptom.id}');
          // Upload to Supabase
          await _supabase.from('symptoms').upsert({
            'id': symptom.id,
            'user_id': userId,
            'symptom_name': symptom.symptomName,
            'severity': symptom.severity,
            'notes': symptom.notes,
            'duration': symptom.duration,
            'recorded_at': symptom.recordedAt.toIso8601String(),
            'created_at': symptom.createdAt.toIso8601String(),
          });

          // Mark as synced
          await db.update(
            'symptoms',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [symptom.id],
          );
        } catch (e) {
          print('Error syncing symptom ${map['id']}: $e');
        }
      }
    } catch (e) {
      print('Error syncing to Supabase: $e');
    }
  }

  /// Add a new symptom
  /// Saves to both Supabase (if online) and local database
  Future<void> addSymptom(SymptomModel symptom) async {
    final hasConnection = await _hasConnectivity();
    final db = await _dbHelper.database;

    // Always save locally first with synced=0
    await db.insert(
      'symptoms',
      {...symptom.toMap(), 'synced': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    print('DEBUG addSymptom: Saved locally with synced=0');

    // Try to save to Supabase if online
    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) {
          print('DEBUG addSymptom: No userId, staying unsynced');
          return;
        }

        final insertData = {
          'id': symptom.id,
          'user_id': userId,
          'symptom_name': symptom.symptomName,
          'severity': symptom.severity,
          'notes': symptom.notes,
          'duration': symptom.duration,
          'recorded_at': symptom.recordedAt.toIso8601String(),
          'created_at': symptom.createdAt.toIso8601String(),
        };
        
        print('DEBUG addSymptom: Inserting to Supabase: $insertData');
        await _supabase.from('symptoms').insert(insertData);
        print('DEBUG addSymptom: Successfully inserted to Supabase');

        // Mark as synced on success
        await db.update(
          'symptoms',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [symptom.id],
        );
        print('DEBUG addSymptom: Marked as synced=1');
      } catch (e, stackTrace) {
        print('DEBUG addSymptom: Error adding to Supabase: $e');
        print('DEBUG addSymptom: Stack trace: $stackTrace');
        // Already saved with synced=0, so nothing to do
      }
    } else {
      print('DEBUG addSymptom: No connection, staying unsynced');
    }
  }

  /// Delete a symptom
  /// Deletes from both Supabase (if online) and local database
  Future<void> deleteSymptom(String id) async {
    final hasConnection = await _hasConnectivity();
    final db = await _dbHelper.database;

    // Try to delete from Supabase first if online
    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId != null) {
          await _supabase
              .from('symptoms')
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
      'symptoms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get the latest symptom
  Future<SymptomModel?> getLatestSymptom() async {
    try {
      final symptoms = await getSymptoms();
      return symptoms.isNotEmpty ? symptoms.first : null;
    } catch (e) {
      print('Error fetching latest symptom: $e');
      return null;
    }
  }

  /// Manually trigger sync of local data to Supabase
  Future<void> syncNow() async {
    final hasConnection = await _hasConnectivity();
    if (hasConnection) {
      await _syncLocalToSupabase();
    }
  }

  /// Get count of unsynced symptoms
  Future<int> getUnsyncedCount() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM symptoms WHERE synced = 0',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
