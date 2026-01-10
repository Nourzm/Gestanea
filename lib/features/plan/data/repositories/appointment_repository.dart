import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/features/plan/data/datasources/appointment_local_data_source.dart';
import 'package:gestanea/features/plan/data/datasources/appointment_remote_data_source.dart';
import 'package:gestanea/core/services/connectivity_service.dart';
import 'dart:async';

class ReturnResult {
  final bool state;
  final String message;

  ReturnResult({required this.state, required this.message});
}

/// Enhanced Appointment Repository with offline/online support
class AppointmentRepository {
  final AppointmentLocalDataSource _localDataSource;
  final AppointmentRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _connectivitySubscription;

  AppointmentRepository({
    AppointmentLocalDataSource? localDataSource,
    AppointmentRemoteDataSource? remoteDataSource,
    ConnectivityService? connectivityService,
  }) : _localDataSource = localDataSource ?? AppointmentLocalDataSource(),
       _remoteDataSource = remoteDataSource ?? AppointmentRemoteDataSource(),
       _connectivityService = connectivityService ?? ConnectivityService() {
    // Listen for connectivity changes and sync when coming online
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      isOnline,
    ) {
      if (isOnline) {
        print(
          '📶 Connectivity restored - will sync pending appointments on next fetch',
        );
      }
    });
  }

  // Singleton instance
  static AppointmentRepository? _instance;

  static AppointmentRepository getInstance() {
    _instance ??= AppointmentRepository();
    return _instance!;
  }

  /// Get appointments - tries remote first if online, falls back to local
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    if (_connectivityService.isOnline) {
      try {
        // Try to fetch from remote
        final remoteAppointments = await _remoteDataSource.getAppointments(
          userId,
        );

        // If remote returns empty, check if we have local data
        if (remoteAppointments.isEmpty) {
          final localAppointments = await _localDataSource.getAppointments(
            userId,
          );
          if (localAppointments.isNotEmpty) {
            print(
              'Remote empty, using local data (${localAppointments.length} items)',
            );
            return localAppointments;
          }
        }

        // Update local cache with remote data
        for (final appointment in remoteAppointments) {
          try {
            await _localDataSource.updateAppointment(appointment);
          } catch (e) {
            // If update fails, try insert (might be new)
            await _localDataSource.insertAppointment(appointment);
          }
        }

        // Merge with local appointments that don't exist in remote
        // (these are appointments created offline that haven't synced yet)
        final localAppointments = await _localDataSource.getAppointments(
          userId,
        );
        final remoteIds = remoteAppointments.map((a) => a.id).toSet();
        final localOnlyAppointments = localAppointments
            .where((a) => !remoteIds.contains(a.id))
            .toList();

        if (localOnlyAppointments.isNotEmpty) {
          print(
            'Found ${localOnlyAppointments.length} local appointments not in remote - syncing now...',
          );

          // Try to sync these local-only appointments to remote
          for (final appointment in localOnlyAppointments) {
            try {
              final success = await _remoteDataSource.insertAppointment(
                appointment,
              );
              if (success) {
                print('✅ Synced appointment: ${appointment.title}');
              } else {
                print('⚠️ Failed to sync appointment: ${appointment.title}');
              }
            } catch (e) {
              print('⚠️ Error syncing appointment ${appointment.title}: $e');
            }
          }
        }

        return [...remoteAppointments, ...localOnlyAppointments];
      } catch (e) {
        print('Failed to fetch from remote, using local: $e');
        // Fallback to local on error
        return _localDataSource.getAppointments(userId);
      }
    } else {
      // Offline mode - use local database
      return _localDataSource.getAppointments(userId);
    }
  }

  /// Get appointments by date - tries remote first if online, falls back to local
  Future<List<AppointmentModel>> getAppointmentsByDate(
    String userId,
    DateTime date,
  ) async {
    if (_connectivityService.isOnline) {
      try {
        // Try to fetch from remote
        final remoteAppointments = await _remoteDataSource
            .getAppointmentsByDate(userId, date);

        // If remote returns empty, check if we have local data
        if (remoteAppointments.isEmpty) {
          final localAppointments = await _localDataSource
              .getAppointmentsByDate(userId, date);
          if (localAppointments.isNotEmpty) {
            print(
              'Remote empty, using local data (${localAppointments.length} items)',
            );
            return localAppointments;
          }
        }

        // Update local cache with remote data
        for (final appointment in remoteAppointments) {
          try {
            await _localDataSource.updateAppointment(appointment);
          } catch (e) {
            await _localDataSource.insertAppointment(appointment);
          }
        }

        // Merge with local appointments that don't exist in remote
        final localAppointments = await _localDataSource.getAppointmentsByDate(
          userId,
          date,
        );
        final remoteIds = remoteAppointments.map((a) => a.id).toSet();
        final localOnlyAppointments = localAppointments
            .where((a) => !remoteIds.contains(a.id))
            .toList();

        if (localOnlyAppointments.isNotEmpty) {
          print(
            'Found ${localOnlyAppointments.length} local appointments not in remote (by date) - syncing now...',
          );

          // Try to sync these local-only appointments to remote
          for (final appointment in localOnlyAppointments) {
            try {
              final success = await _remoteDataSource.insertAppointment(
                appointment,
              );
              if (success) {
                print('✅ Synced appointment: ${appointment.title}');
              }
            } catch (e) {
              print('⚠️ Error syncing appointment ${appointment.title}: $e');
            }
          }
        }

        return [...remoteAppointments, ...localOnlyAppointments];
      } catch (e) {
        print('Failed to fetch from remote, using local: $e');
        return _localDataSource.getAppointmentsByDate(userId, date);
      }
    } else {
      return _localDataSource.getAppointmentsByDate(userId, date);
    }
  }

  /// Get upcoming appointments - tries remote first if online, falls back to local
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    if (_connectivityService.isOnline) {
      try {
        final remoteAppointments = await _remoteDataSource
            .getUpcomingAppointments(userId);

        // If remote returns empty, check if we have local data
        if (remoteAppointments.isEmpty) {
          final localAppointments = await _localDataSource
              .getUpcomingAppointments(userId);
          if (localAppointments.isNotEmpty) {
            print(
              'Remote empty, using local data (${localAppointments.length} items)',
            );
            return localAppointments;
          }
        }

        // Merge with local appointments that don't exist in remote
        final localAppointments = await _localDataSource
            .getUpcomingAppointments(userId);
        final remoteIds = remoteAppointments.map((a) => a.id).toSet();
        final localOnlyAppointments = localAppointments
            .where((a) => !remoteIds.contains(a.id))
            .toList();

        if (localOnlyAppointments.isNotEmpty) {
          print(
            'Found ${localOnlyAppointments.length} local appointments not in remote (upcoming) - syncing now...',
          );

          // Try to sync these local-only appointments to remote
          for (final appointment in localOnlyAppointments) {
            try {
              final success = await _remoteDataSource.insertAppointment(
                appointment,
              );
              if (success) {
                print('✅ Synced appointment: ${appointment.title}');
              }
            } catch (e) {
              print('⚠️ Error syncing appointment ${appointment.title}: $e');
            }
          }
        }

        return [...remoteAppointments, ...localOnlyAppointments];
      } catch (e) {
        print(
          'Failed to fetch upcoming appointments from remote, using local: $e',
        );
        return _localDataSource.getUpcomingAppointments(userId);
      }
    } else {
      return _localDataSource.getUpcomingAppointments(userId);
    }
  }

  /// Insert appointment - saves locally first, then syncs to remote if online
  Future<ReturnResult> insertAppointment(AppointmentModel appointment) async {
    // Always save to local first for offline support
    final localSuccess = await _localDataSource.insertAppointment(appointment);

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to save appointment locally',
      );
    }

    // If online, also save to remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.insertAppointment(
          appointment,
        );
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Appointment added successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Appointment added locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Appointment added locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Appointment added locally (offline mode)',
      );
    }
  }

  /// Update appointment - updates locally first, then syncs to remote if online
  Future<ReturnResult> updateAppointment(AppointmentModel appointment) async {
    // Always update local first
    final localSuccess = await _localDataSource.updateAppointment(appointment);

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to update appointment locally',
      );
    }

    // If online, also update remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.updateAppointment(
          appointment,
        );
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Appointment updated successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Appointment updated locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync update to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Appointment updated locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Appointment updated locally (offline mode)',
      );
    }
  }

  /// Delete appointment - deletes locally first, then syncs to remote if online
  Future<ReturnResult> deleteAppointment(String id) async {
    // Always delete from local first
    final localSuccess = await _localDataSource.deleteAppointment(id);

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to delete appointment locally',
      );
    }

    // If online, also delete from remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.deleteAppointment(id);
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Appointment deleted successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Appointment deleted locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync deletion to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Appointment deleted locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Appointment deleted locally (offline mode)',
      );
    }
  }

  /// Update appointment status - updates locally first, then syncs to remote if online
  Future<ReturnResult> updateAppointmentStatus(
    String id,
    bool isCompleted,
  ) async {
    // Always update local first
    final localSuccess = await _localDataSource.updateAppointmentStatus(
      id,
      isCompleted,
    );

    if (!localSuccess) {
      return ReturnResult(
        state: false,
        message: 'Failed to update appointment status locally',
      );
    }

    // If online, also update remote
    if (_connectivityService.isOnline) {
      try {
        final remoteSuccess = await _remoteDataSource.updateAppointmentStatus(
          id,
          isCompleted,
        );
        if (remoteSuccess) {
          return ReturnResult(
            state: true,
            message: 'Appointment status updated successfully (synced)',
          );
        } else {
          return ReturnResult(
            state: true,
            message: 'Appointment status updated locally (sync pending)',
          );
        }
      } catch (e) {
        print('Failed to sync status update to remote: $e');
        return ReturnResult(
          state: true,
          message: 'Appointment status updated locally (sync pending)',
        );
      }
    } else {
      return ReturnResult(
        state: true,
        message: 'Appointment status updated locally (offline mode)',
      );
    }
  }
}
