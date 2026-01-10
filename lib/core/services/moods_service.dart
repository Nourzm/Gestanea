import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../database/models/mood_model.dart';
import '../database/db_helper.dart';

class MoodsService {
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

  /// Get all moods for the current user
  /// Uses Supabase when online, local database when offline
  Future<List<MoodModel>> getMoods() async {
    final hasConnection = await _hasConnectivity();
    print('DEBUG getMoods: hasConnection=$hasConnection');

    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        print('DEBUG getMoods: userId=$userId');
        if (userId == null) {
          print('DEBUG getMoods: No user ID, using local');
          return await getLocalMoods();
        }

        // Sync before fetching
        print('DEBUG getMoods: Starting sync to Supabase');
        await _syncLocalToSupabase();

        final response = await _supabase
            .from('moods')
            .select()
            .eq('user_id', userId)
            .order('recorded_at', ascending: false);

        final moods = (response as List)
            .map((map) => MoodModel.fromMap(map))
            .toList();

        // Update local cache
        await _updateLocalCache(moods);

        return moods;
      } catch (e) {
        print('Error fetching from Supabase, using local: $e');
        return await getLocalMoods();
      }
    } else {
      // Offline mode
      return await getLocalMoods();
    }
  }

  /// Get moods from local database
  Future<List<MoodModel>> getLocalMoods() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'moods',
      orderBy: 'recorded_at DESC',
    );
    return maps.map((map) => MoodModel.fromMap(map)).toList();
  }

  /// Update local cache with Supabase data
  Future<void> _updateLocalCache(List<MoodModel> moods) async {
    try {
      final db = await _dbHelper.database;
      
      // Get unsynced records
      final unsyncedMaps = await db.query('moods', where: 'synced = 0');
      final unsyncedIds = unsyncedMaps.map((m) => m['id'] as String).toSet();
      
      // Clear synced moods only
      await db.delete('moods', where: 'synced = 1');
      
      // Insert fresh data from Supabase (avoid overwriting unsynced)
      for (final mood in moods) {
        if (!unsyncedIds.contains(mood.id)) {
          await db.insert(
            'moods',
            {...mood.toMap(), 'synced': 1},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
      print('Error updating local cache: $e');
    }
  }

  /// Sync unsynced local moods to Supabase
  Future<void> _syncLocalToSupabase() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      print('DEBUG _syncLocalToSupabase: userId=$userId');
      if (userId == null) return;

      final db = await _dbHelper.database;
      final unsyncedMaps = await db.query(
        'moods',
        where: 'synced = 0',
      );
      
      print('DEBUG _syncLocalToSupabase: Found ${unsyncedMaps.length} unsynced moods');

      for (final map in unsyncedMaps) {
        try {
          final mood = MoodModel.fromMap(map);
          
          print('DEBUG _syncLocalToSupabase: Syncing mood ${mood.id}');
          // Upload to Supabase
          await _supabase.from('moods').upsert({
            'id': mood.id,
            'user_id': userId,
            'mood': mood.mood,
            'intensity': mood.intensity,
            'notes': mood.notes,
            'recorded_at': mood.recordedAt.toIso8601String(),
            'created_at': mood.createdAt.toIso8601String(),
          });

          // Mark as synced
          await db.update(
            'moods',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [mood.id],
          );
        } catch (e) {
          print('Error syncing mood ${map['id']}: $e');
        }
      }
    } catch (e) {
      print('Error syncing to Supabase: $e');
    }
  }

  /// Add a new mood
  /// Saves to both Supabase (if online) and local database
  Future<void> addMood(MoodModel mood) async {
    final hasConnection = await _hasConnectivity();
    final db = await _dbHelper.database;

    // Always save locally first with synced=0
    await db.insert(
      'moods',
      {...mood.toMap(), 'synced': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    print('DEBUG addMood: Saved locally with synced=0');

    // Try to save to Supabase if online
    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) {
          print('DEBUG addMood: No userId, staying unsynced');
          return;
        }

        final insertData = {
          'id': mood.id,
          'user_id': userId,
          'mood': mood.mood,
          'intensity': mood.intensity,
          'notes': mood.notes,
          'recorded_at': mood.recordedAt.toIso8601String(),
          'created_at': mood.createdAt.toIso8601String(),
        };
        
        print('DEBUG addMood: Inserting to Supabase: $insertData');
        await _supabase.from('moods').insert(insertData);
        print('DEBUG addMood: Successfully inserted to Supabase');

        // Mark as synced on success
        await db.update(
          'moods',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [mood.id],
        );
        print('DEBUG addMood: Marked as synced=1');
      } catch (e, stackTrace) {
        print('DEBUG addMood: Error adding to Supabase: $e');
        print('DEBUG addMood: Stack trace: $stackTrace');
        // Already saved with synced=0, so nothing to do
      }
    } else {
      print('DEBUG addMood: No connection, staying unsynced');
    }
  }

  /// Delete a mood
  /// Deletes from both Supabase (if online) and local database
  Future<void> deleteMood(String id) async {
    final hasConnection = await _hasConnectivity();
    final db = await _dbHelper.database;

    // Try to delete from Supabase first if online
    if (hasConnection) {
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId != null) {
          await _supabase
              .from('moods')
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
      'moods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get the latest mood
  Future<MoodModel?> getLatestMood() async {
    try {
      final moods = await getMoods();
      return moods.isNotEmpty ? moods.first : null;
    } catch (e) {
      print('Error fetching latest mood: $e');
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

  /// Get count of unsynced moods
  Future<int> getUnsyncedCount() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM moods WHERE synced = 0',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Start listening for connectivity changes and auto-sync
  void startConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        print('DEBUG: Connectivity restored, triggering mood sync');
        await syncNow();
      }
    });
  }
}
