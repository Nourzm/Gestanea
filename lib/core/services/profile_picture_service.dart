import 'dart:io';
import 'package:gestanea/core/config/supabase_config.dart';
import 'package:gestanea/core/services/connectivity_service.dart';
import 'package:gestanea/core/services/sync_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for managing user profile pictures with offline-first support
/// Handles upload to Supabase Storage, local caching, and sync integration
class ProfilePictureService {
  static final ProfilePictureService _instance = ProfilePictureService._internal();
  factory ProfilePictureService() => _instance;
  ProfilePictureService._internal();

  final SupabaseClient _client = SupabaseConfig.client;
  final ConnectivityService _connectivityService = ConnectivityService();
  final SyncService _syncService = SyncService();

  static const String _storageBucket = 'profile-pictures';
  static const String _cacheFolderName = 'profile_pictures';

  /// Get local cache directory for profile pictures
  Future<Directory> get _cacheDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/$_cacheFolderName');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  /// Get local file path for a user's profile picture
  Future<String> _getLocalPath(String userId) async {
    final cacheDir = await _cacheDirectory;
    return '${cacheDir.path}/$userId.jpg';
  }

  /// Upload profile picture to Supabase Storage
  /// Returns the public URL of the uploaded image
  Future<String> uploadProfilePicture({
    required String userId,
    required File imageFile,
  }) async {
    if (!_connectivityService.isOnline) {
      throw Exception('No internet connection. Cannot upload profile picture.');
    }

    try {
      final fileName = '$userId.jpg';
      
      // Upload to Supabase Storage (overwrites existing file)
      await _client.storage
          .from(_storageBucket)
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // Get public URL
      final publicUrl = _client.storage
          .from(_storageBucket)
          .getPublicUrl(fileName);

      // Cache locally for offline access
      final localPath = await _getLocalPath(userId);
      await imageFile.copy(localPath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  /// Download and cache profile picture from Supabase Storage
  Future<String?> downloadAndCacheProfilePicture({
    required String userId,
    required String imageUrl,
  }) async {
    if (!_connectivityService.isOnline) {
      return null;
    }

    try {
      final localPath = await _getLocalPath(userId);
      final localFile = File(localPath);

      // Download from URL
      final response = await _client.storage
          .from(_storageBucket)
          .download('$userId.jpg');

      // Save to local cache
      await localFile.writeAsBytes(response);

      return localPath;
    } catch (e) {
      print('Failed to download profile picture: $e');
      return null;
    }
  }

  /// Get local cached profile picture path
  /// Returns null if not cached locally
  Future<String?> getLocalCachedPath(String userId) async {
    try {
      final localPath = await _getLocalPath(userId);
      final file = File(localPath);
      if (await file.exists()) {
        return localPath;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get public URL for a user's profile picture
  String getPublicUrl(String userId) {
    return _client.storage
        .from(_storageBucket)
        .getPublicUrl('$userId.jpg');
  }

  /// Delete profile picture (both remote and local)
  Future<void> deleteProfilePicture(String userId) async {
    try {
      // Delete from Supabase Storage if online
      if (_connectivityService.isOnline) {
        try {
          await _client.storage
              .from(_storageBucket)
              .remove(['$userId.jpg']);
        } catch (e) {
          print('Failed to delete from storage (may not exist): $e');
        }
      }

      // Delete local cache
      final localPath = await _getLocalPath(userId);
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete profile picture: $e');
    }
  }

  /// Sync profile picture from remote to local
  /// Called when connection is restored or on app startup
  Future<bool> syncProfilePictureFromRemote({
    required String userId,
    String? remoteImageUrl,
  }) async {
    if (!_connectivityService.isOnline) {
      return false;
    }

    if (remoteImageUrl == null || remoteImageUrl.isEmpty) {
      return false;
    }

    try {
      final cachedPath = await downloadAndCacheProfilePicture(
        userId: userId,
        imageUrl: remoteImageUrl,
      );
      return cachedPath != null;
    } catch (e) {
      print('Failed to sync profile picture: $e');
      return false;
    }
  }

  /// Initialize sync service for profile pictures
  void initializeSync() {
    _syncService.initialize(
      onConnectionRestored: () {
        print('Connection restored - profile pictures ready to sync');
      },
    );
  }
}
