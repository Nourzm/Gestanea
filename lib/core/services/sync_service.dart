import 'package:gestanea/core/services/connectivity_service.dart';

/// Generic sync service for synchronizing local data with remote backend
/// Can be extended by any feature that needs offline/online sync capabilities
class SyncService {
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  /// Get last sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;

  /// Initialize sync service and listen for connectivity changes
  void initialize({Function()? onConnectionRestored}) {
    _connectivityService.connectivityStream.listen((isOnline) {
      if (isOnline) {
        print('Device is online, connection restored');
        onConnectionRestored?.call();
      }
    });
  }

  /// Generic sync operation
  /// Executes the provided sync operation and handles common sync logic
  Future<SyncResult> performSync({
    required String operation,
    required Future<SyncResult> Function() syncOperation,
    bool requiresOnline = true,
  }) async {
    if (_isSyncing) {
      return SyncResult(success: false, message: 'Sync already in progress');
    }

    if (requiresOnline && !_connectivityService.isOnline) {
      return SyncResult(success: false, message: 'No internet connection');
    }

    _isSyncing = true;

    try {
      final result = await syncOperation();
      if (result.success) {
        _lastSyncTime = DateTime.now();
      }
      return result;
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Sync failed: $e',
        errors: ['Error in $operation: $e'],
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync items from local to remote
  Future<SyncResult> syncToRemote<T>({
    required String itemType,
    required Future<List<T>> Function() getLocalItems,
    required Future<bool> Function(T item) syncItemToRemote,
    String Function(T item)? getItemName,
  }) async {
    return performSync(
      operation: 'sync $itemType to remote',
      syncOperation: () async {
        int synced = 0;
        List<String> errors = [];

        try {
          final items = await getLocalItems();

          for (final item in items) {
            try {
              final success = await syncItemToRemote(item);
              if (success) {
                synced++;
              } else {
                final name = getItemName?.call(item) ?? 'item';
                errors.add('$itemType $name: Failed to sync');
              }
            } catch (e) {
              final name = getItemName?.call(item) ?? 'item';
              errors.add('$itemType $name: $e');
            }
          }

          return SyncResult(
            success: errors.isEmpty,
            message: errors.isEmpty
                ? 'Synced $synced $itemType successfully'
                : 'Synced $synced $itemType with ${errors.length} errors',
            itemsSynced: synced,
            errors: errors,
          );
        } catch (e) {
          return SyncResult(
            success: false,
            message: 'Failed to sync $itemType: $e',
            errors: ['General error: $e'],
          );
        }
      },
    );
  }

  /// Pull items from remote to local
  Future<SyncResult> pullFromRemote<T>({
    required String itemType,
    required Future<List<T>> Function() getRemoteItems,
    required Future<bool> Function(T item) insertLocalItem,
    required Future<bool> Function(T item) updateLocalItem,
    String Function(T item)? getItemName,
  }) async {
    return performSync(
      operation: 'pull $itemType from remote',
      syncOperation: () async {
        int pulled = 0;
        List<String> errors = [];

        try {
          final items = await getRemoteItems();

          for (final item in items) {
            try {
              // Try insert first
              final inserted = await insertLocalItem(item);
              if (inserted) {
                pulled++;
              }
            } catch (e) {
              // If insert fails, try update (item might already exist)
              try {
                final updated = await updateLocalItem(item);
                if (updated) {
                  pulled++;
                }
              } catch (updateError) {
                final name = getItemName?.call(item) ?? 'item';
                errors.add('$itemType $name: $updateError');
              }
            }
          }

          return SyncResult(
            success: errors.isEmpty,
            message: errors.isEmpty
                ? 'Pulled $pulled $itemType successfully'
                : 'Pulled $pulled $itemType with ${errors.length} errors',
            itemsSynced: pulled,
            errors: errors,
          );
        } catch (e) {
          return SyncResult(
            success: false,
            message: 'Failed to pull $itemType: $e',
            errors: ['General error: $e'],
          );
        }
      },
    );
  }

  /// Batch sync multiple item types
  Future<SyncResult> batchSync({
    required List<Future<SyncResult> Function()> syncOperations,
  }) async {
    return performSync(
      operation: 'batch sync',
      syncOperation: () async {
        int totalSynced = 0;
        List<String> allErrors = [];
        bool allSuccessful = true;

        for (final operation in syncOperations) {
          try {
            final result = await operation();
            totalSynced += result.itemsSynced;
            allErrors.addAll(result.errors);
            if (!result.success) {
              allSuccessful = false;
            }
          } catch (e) {
            allSuccessful = false;
            allErrors.add('Operation failed: $e');
          }
        }

        return SyncResult(
          success: allSuccessful,
          message: allSuccessful
              ? 'Synced $totalSynced items successfully'
              : 'Synced $totalSynced items with ${allErrors.length} errors',
          itemsSynced: totalSynced,
          errors: allErrors,
        );
      },
      requiresOnline: true,
    );
  }
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String message;
  final int itemsSynced;
  final List<String> errors;

  SyncResult({
    required this.success,
    required this.message,
    this.itemsSynced = 0,
    this.errors = const [],
  });

  @override
  String toString() {
    return 'SyncResult(success: $success, message: $message, itemsSynced: $itemsSynced, errors: ${errors.length})';
  }
}
