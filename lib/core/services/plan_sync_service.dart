import 'package:gestanea/features/plan/data/datasources/medicine_local_data_source.dart';
import 'package:gestanea/features/plan/data/datasources/medicine_remote_data_source.dart';
import 'package:gestanea/features/plan/data/datasources/appointment_local_data_source.dart';
import 'package:gestanea/features/plan/data/datasources/appointment_remote_data_source.dart';
import 'package:gestanea/core/services/sync_service.dart';

/// Service to synchronize Plan feature data (medicines & appointments)
/// Uses the generic SyncService for common sync operations
class PlanSyncService {
  static final PlanSyncService _instance = PlanSyncService._internal();
  factory PlanSyncService() => _instance;
  PlanSyncService._internal();

  final SyncService _syncService = SyncService();
  final MedicineLocalDataSource _medicineLocalDataSource =
      MedicineLocalDataSource();
  final MedicineRemoteDataSource _medicineRemoteDataSource =
      MedicineRemoteDataSource();
  final AppointmentLocalDataSource _appointmentLocalDataSource =
      AppointmentLocalDataSource();
  final AppointmentRemoteDataSource _appointmentRemoteDataSource =
      AppointmentRemoteDataSource();

  /// Get last sync time
  DateTime? get lastSyncTime => _syncService.lastSyncTime;

  /// Check if currently syncing
  bool get isSyncing => _syncService.isSyncing;

  /// Initialize sync service and listen for connectivity changes
  void initialize() {
    _syncService.initialize(
      onConnectionRestored: () {
        print('Plan feature: Connection restored, ready to sync');
        // Note: Actual sync should be triggered with user context
      },
    );
  }

  /// Sync all plan data for a user from local to remote
  /// This should be called when transitioning from offline to online
  Future<PlanSyncResult> syncPlanData(String userId) async {
    // Use batch sync for all plan data
    final result = await _syncService.batchSync(
      syncOperations: [
        // Sync medicines
        () => _syncService.syncToRemote(
          itemType: 'medicines',
          getLocalItems: () => _medicineLocalDataSource.getMedicines(userId),
          syncItemToRemote: (medicine) =>
              _medicineRemoteDataSource.insertMedicine(medicine),
          getItemName: (medicine) => medicine.medicineName,
        ),

        // Sync medicine logs
        () => _syncService.syncToRemote(
          itemType: 'medicine logs',
          getLocalItems: () =>
              _medicineLocalDataSource.getMedicineLogs(userId, DateTime.now()),
          syncItemToRemote: (log) => _medicineRemoteDataSource.logMedicine(log),
          getItemName: (log) => 'log ${log.id}',
        ),

        // Sync appointments
        () => _syncService.syncToRemote(
          itemType: 'appointments',
          getLocalItems: () =>
              _appointmentLocalDataSource.getAppointments(userId),
          syncItemToRemote: (appointment) =>
              _appointmentRemoteDataSource.insertAppointment(appointment),
          getItemName: (appointment) => appointment.title,
        ),
      ],
    );

    return PlanSyncResult(
      success: result.success,
      message: result.message,
      itemsSynced: result.itemsSynced,
      errors: result.errors,
    );
  }

  /// Pull latest data from remote to local
  /// This can be used to fetch remote changes when online
  Future<PlanSyncResult> pullRemoteData(String userId) async {
    // Use batch sync for pulling all plan data
    final result = await _syncService.batchSync(
      syncOperations: [
        // Pull medicines
        () => _syncService.pullFromRemote(
          itemType: 'medicines',
          getRemoteItems: () => _medicineRemoteDataSource.getMedicines(userId),
          insertLocalItem: (medicine) =>
              _medicineLocalDataSource.insertMedicine(medicine),
          updateLocalItem: (medicine) =>
              _medicineLocalDataSource.updateMedicine(medicine),
          getItemName: (medicine) => medicine.medicineName,
        ),

        // Pull appointments
        () => _syncService.pullFromRemote(
          itemType: 'appointments',
          getRemoteItems: () =>
              _appointmentRemoteDataSource.getAppointments(userId),
          insertLocalItem: (appointment) =>
              _appointmentLocalDataSource.insertAppointment(appointment),
          updateLocalItem: (appointment) =>
              _appointmentLocalDataSource.updateAppointment(appointment),
          getItemName: (appointment) => appointment.title,
        ),
      ],
    );

    return PlanSyncResult(
      success: result.success,
      message: result.message,
      itemsSynced: result.itemsSynced,
      errors: result.errors,
    );
  }
}

/// Result of a plan sync operation
class PlanSyncResult {
  final bool success;
  final String message;
  final int itemsSynced;
  final List<String> errors;

  PlanSyncResult({
    required this.success,
    required this.message,
    this.itemsSynced = 0,
    this.errors = const [],
  });

  @override
  String toString() {
    return 'PlanSyncResult(success: $success, message: $message, itemsSynced: $itemsSynced, errors: ${errors.length})';
  }
}
