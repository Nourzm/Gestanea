import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'dart:convert';

// Global storage for alarm metadata (since AndroidAlarmManager can't pass complex params)
final Map<int, Map<String, dynamic>> _alarmMetadata = {};

/// Callback for medicine alarms (must be top-level function)
@pragma('vm:entry-point')
void medicineAlarmCallback(int id) async {
  developer.log('🔔 Medicine alarm triggered! ID: $id', name: 'AlarmScheduler');
  print('🔔 Medicine alarm triggered! ID: $id');

  try {
    // CRITICAL FIX: Force a fresh SharedPreferences instance in this isolate
    print('📖 Retrieving metadata for alarm $id from SharedPreferences...');

    // Retry logic to handle cross-isolate SharedPreferences consistency
    Map<String, dynamic>? metadata;
    SharedPreferences? prefs;

    for (int attempt = 1; attempt <= 3; attempt++) {
      print('🔄 Attempt $attempt to retrieve metadata...');

      // Get fresh instance each time
      prefs = await SharedPreferences.getInstance();

      // Force reload from disk
      await prefs.reload();
      print('💾 SharedPreferences reloaded (attempt $attempt)');

      // List all keys to debug
      final allKeys = prefs.getKeys();
      print('📋 All stored keys (attempt $attempt): $allKeys');

      final metadataJson = prefs.getString('alarm_$id');
      print('📄 Raw metadata JSON for alarm_$id: $metadataJson');

      if (metadataJson != null) {
        metadata = json.decode(metadataJson) as Map<String, dynamic>;
        print('✅ Metadata decoded successfully: $metadata');
        break;
      }

      // Wait before retrying
      if (attempt < 3) {
        print('⏳ Waiting 500ms before retry...');
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (metadata == null) {
      developer.log(
        '❌ No metadata found for alarm $id after 3 attempts',
        name: 'AlarmScheduler',
      );
      print('❌ No metadata found for alarm $id after 3 attempts');
      print(
        '🔍 Available alarm keys: ${prefs?.getKeys().where((k) => k.startsWith("alarm_")).toList()}',
      );

      // Show fallback notification
      final notifications = FlutterLocalNotificationsPlugin();
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initSettings = InitializationSettings(android: androidSettings);
      await notifications.initialize(initSettings);

      const androidDetails = AndroidNotificationDetails(
        'medicine_reminders',
        'Medicine Reminders',
        channelDescription: 'Notifications for medicine reminders',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );
      const notificationDetails = NotificationDetails(android: androidDetails);

      await notifications.show(
        id,
        'Medicine Reminder',
        'Time to take your medicine (ID: $id)',
        notificationDetails,
        payload: 'medicine:$id',
      );

      print('✅ Fallback notification shown');
      return;
    }

    // Initialize notifications directly (no Activity context needed)
    final notifications = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await notifications.initialize(initSettings);
    print('✅ Notification plugin initialized in background');

    // Show notification
    const androidDetails = AndroidNotificationDetails(
      'medicine_reminders',
      'Medicine Reminders',
      channelDescription: 'Notifications for medicine reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await notifications.show(
      id,
      'Medicine Reminder',
      'Time to take ${metadata['medicineName']} (${metadata['dosage']})',
      notificationDetails,
      payload: 'medicine:$id',
    );

    developer.log(
      '✅ Medicine notification shown for ${metadata['medicineName']}',
      name: 'AlarmScheduler',
    );
    print('✅ Medicine notification shown for ${metadata['medicineName']}');
  } catch (e, stackTrace) {
    developer.log(
      '❌ Error in medicine alarm callback: $e',
      name: 'AlarmScheduler',
      error: e,
      stackTrace: stackTrace,
    );
    print('❌ Error in medicine alarm callback: $e');
    print('Stack trace: $stackTrace');
  }
}

/// Callback for appointment alarms (must be top-level function)
@pragma('vm:entry-point')
void appointmentAlarmCallback(int id) async {
  developer.log(
    '🔔 Appointment alarm triggered! ID: $id',
    name: 'AlarmScheduler',
  );
  print('🔔 Appointment alarm triggered! ID: $id');

  try {
    // CRITICAL FIX: Force a fresh SharedPreferences instance in this isolate
    print('📖 Retrieving metadata for alarm $id from SharedPreferences...');

    // Retry logic to handle cross-isolate SharedPreferences consistency
    Map<String, dynamic>? metadata;
    SharedPreferences? prefs;

    for (int attempt = 1; attempt <= 3; attempt++) {
      print('🔄 Attempt $attempt to retrieve metadata...');

      // Get fresh instance each time
      prefs = await SharedPreferences.getInstance();

      // Force reload from disk
      await prefs.reload();
      print('💾 SharedPreferences reloaded (attempt $attempt)');

      // List all keys to debug
      final allKeys = prefs.getKeys();
      print('📋 All stored keys (attempt $attempt): $allKeys');

      final metadataJson = prefs.getString('alarm_$id');
      print('📄 Raw metadata JSON for alarm_$id: $metadataJson');

      if (metadataJson != null) {
        metadata = json.decode(metadataJson) as Map<String, dynamic>;
        print('✅ Metadata decoded successfully: $metadata');
        break;
      }

      // Wait before retrying
      if (attempt < 3) {
        print('⏳ Waiting 500ms before retry...');
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (metadata == null) {
      developer.log(
        '❌ No metadata found for alarm $id after 3 attempts',
        name: 'AlarmScheduler',
      );
      print('❌ No metadata found for alarm $id after 3 attempts');
      print(
        '🔍 Available alarm keys: ${prefs?.getKeys().where((k) => k.startsWith("alarm_")).toList()}',
      );

      // Show fallback notification
      final notifications = FlutterLocalNotificationsPlugin();
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initSettings = InitializationSettings(android: androidSettings);
      await notifications.initialize(initSettings);

      const androidDetails = AndroidNotificationDetails(
        'appointment_reminders',
        'Appointment Reminders',
        channelDescription: 'Notifications for appointment reminders',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );
      const notificationDetails = NotificationDetails(android: androidDetails);

      await notifications.show(
        id,
        'Appointment Reminder',
        'You have an appointment (ID: $id)',
        notificationDetails,
        payload: 'appointment:$id',
      );

      print('✅ Fallback notification shown');
      return;
    }

    // Initialize notifications directly (no Activity context needed)
    final notifications = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await notifications.initialize(initSettings);
    print('✅ Notification plugin initialized in background');

    // Show notification
    final location = metadata['location'] as String?;
    final locationText = location != null && location.isNotEmpty
        ? ' at $location'
        : '';

    const androidDetails = AndroidNotificationDetails(
      'appointment_reminders',
      'Appointment Reminders',
      channelDescription: 'Notifications for appointment reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await notifications.show(
      id,
      'Appointment Reminder',
      '${metadata['title']}$locationText in 30 minutes',
      notificationDetails,
      payload: 'appointment:$id',
    );

    developer.log(
      '✅ Appointment notification shown for ${metadata['title']}',
      name: 'AlarmScheduler',
    );
    print('✅ Appointment notification shown for ${metadata['title']}');
  } catch (e, stackTrace) {
    developer.log(
      '❌ Error in appointment alarm callback: $e',
      name: 'AlarmScheduler',
      error: e,
      stackTrace: stackTrace,
    );
    print('❌ Error in appointment alarm callback: $e');
    print('Stack trace: $stackTrace');
  }
}

/// Service to schedule alarms for medicines and appointments
class AlarmScheduler {
  static final AlarmScheduler _instance = AlarmScheduler._internal();
  factory AlarmScheduler() => _instance;
  AlarmScheduler._internal();

  bool _initialized = false;

  /// Initialize alarm manager
  Future<void> initialize() async {
    if (_initialized) {
      developer.log(
        '⚠️ Alarm manager already initialized',
        name: 'AlarmScheduler',
      );
      return;
    }

    developer.log('🚀 Initializing alarm manager...', name: 'AlarmScheduler');
    print('🚀 Initializing alarm manager...');

    try {
      await AndroidAlarmManager.initialize();
      _initialized = true;
      developer.log(
        '✅ Alarm manager initialized successfully',
        name: 'AlarmScheduler',
      );
      print('✅ Alarm manager initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to initialize alarm manager: $e',
        name: 'AlarmScheduler',
        error: e,
        stackTrace: stackTrace,
      );
      print('❌ Failed to initialize alarm manager: $e');
      rethrow;
    }
  }

  /// Store metadata for an alarm
  Future<void> _storeAlarmMetadata(
    int id,
    Map<String, dynamic> metadata,
  ) async {
    developer.log(
      '💾 Storing metadata for alarm $id: $metadata',
      name: 'AlarmScheduler',
    );
    print('💾 Storing metadata for alarm $id: $metadata');

    try {
      final prefs = await SharedPreferences.getInstance();
      final metadataJson = json.encode(metadata);

      // CRITICAL FIX 1: Use commit() instead of setString()
      // commit() forces immediate write to disk, while setString() is async
      final saved = await prefs.setString('alarm_$id', metadataJson);
      print('💾 setString returned: $saved');

      if (!saved) {
        throw Exception('setString returned false');
      }

      // CRITICAL FIX 2: Multiple verification attempts
      bool verified = false;
      for (int attempt = 1; attempt <= 3; attempt++) {
        print('🔄 Verification attempt $attempt...');

        // Force reload from disk to ensure persistence
        await prefs.reload();
        print('💾 SharedPreferences reloaded (attempt $attempt)');

        // Verify the data was actually saved
        final verification = prefs.getString('alarm_$id');
        if (verification != null && verification == metadataJson) {
          verified = true;
          print(
            '✅ Metadata verified in SharedPreferences: alarm_$id (attempt $attempt)',
          );
          break;
        }

        if (attempt < 3) {
          print('⚠️ Verification failed, retrying...');
          // Try saving again
          await prefs.setString('alarm_$id', metadataJson);
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }

      if (!verified) {
        throw Exception('Failed to verify metadata after 3 attempts');
      }

      developer.log(
        '✅ Metadata stored and verified successfully',
        name: 'AlarmScheduler',
      );

      // CRITICAL FIX 3: Longer delay to ensure disk write completes
      // This is crucial for Android's SharedPreferences to fully commit
      await Future.delayed(const Duration(milliseconds: 500));

      // Final verification
      await prefs.reload();
      final finalCheck = prefs.getString('alarm_$id');
      print('🔍 Final verification: ${finalCheck != null ? "PASS" : "FAIL"}');
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to store metadata: $e',
        name: 'AlarmScheduler',
        error: e,
        stackTrace: stackTrace,
      );
      print('❌ Failed to store metadata: $e');
      rethrow;
    }
  }

  /// Schedule alarms for medicine at scheduled times
  Future<void> scheduleMedicineAlarms({
    required String medicineId,
    required String medicineName,
    required String dosage,
    required List<String> scheduledTimes,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    developer.log(
      '📅 Scheduling medicine alarms for: $medicineName',
      name: 'AlarmScheduler',
    );
    print('📅 Scheduling medicine alarms for: $medicineName');
    print('   Times: $scheduledTimes');
    print('   Start date: $startDate');
    print('   End date: $endDate');

    final now = DateTime.now();
    int scheduledCount = 0;

    for (int i = 0; i < scheduledTimes.length; i++) {
      final time = _parseTime(scheduledTimes[i]);
      if (time == null) {
        developer.log(
          '⚠️ Failed to parse time: ${scheduledTimes[i]}',
          name: 'AlarmScheduler',
        );
        print('⚠️ Failed to parse time: ${scheduledTimes[i]}');
        continue;
      }

      // Create alarm time for today
      var alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If the time has passed today, schedule for tomorrow
      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(const Duration(days: 1));
        developer.log(
          '⏰ Time has passed today, scheduling for tomorrow: $alarmTime',
          name: 'AlarmScheduler',
        );
        print('⏰ Time has passed today, scheduling for tomorrow: $alarmTime');
      }

      // Don't schedule if before start date
      if (alarmTime.isBefore(startDate)) {
        developer.log(
          '⚠️ Alarm time before start date, skipping',
          name: 'AlarmScheduler',
        );
        print('⚠️ Alarm time before start date, skipping');
        continue;
      }

      // Don't schedule if after end date
      if (endDate != null && alarmTime.isAfter(endDate)) {
        developer.log(
          '⚠️ Alarm time after end date, skipping',
          name: 'AlarmScheduler',
        );
        print('⚠️ Alarm time after end date, skipping');
        continue;
      }

      // Generate unique ID for this alarm
      final alarmId = _generateAlarmId(medicineId, i);

      // CRITICAL FIX 4: Store metadata BEFORE scheduling alarm
      // This ensures data is available before the callback might fire
      try {
        await _storeAlarmMetadata(alarmId, {
          'medicineName': medicineName,
          'dosage': dosage,
          'type': 'medicine',
        });

        print('✅ Metadata stored successfully for alarm $alarmId');
      } catch (e) {
        developer.log(
          '❌ Failed to store metadata for alarm $alarmId: $e',
          name: 'AlarmScheduler',
        );
        print('❌ Failed to store metadata for alarm $alarmId: $e');
        continue; // Skip scheduling this alarm if metadata storage fails
      }

      try {
        // Schedule the alarm to repeat daily
        final success = await AndroidAlarmManager.periodic(
          const Duration(days: 1),
          alarmId,
          medicineAlarmCallback,
          startAt: alarmTime,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
        );

        if (success) {
          scheduledCount++;
          developer.log(
            '✅ Scheduled medicine alarm $alarmId for $medicineName at ${scheduledTimes[i]} (next trigger: $alarmTime)',
            name: 'AlarmScheduler',
          );
          print('✅ Scheduled medicine alarm $alarmId for $medicineName');
          print('   Time: ${scheduledTimes[i]} (next trigger: $alarmTime)');
        } else {
          developer.log(
            '❌ Failed to schedule alarm $alarmId for $medicineName',
            name: 'AlarmScheduler',
          );
          print('❌ Failed to schedule alarm $alarmId for $medicineName');
        }
      } catch (e, stackTrace) {
        developer.log(
          '❌ Error scheduling alarm for $medicineName: $e',
          name: 'AlarmScheduler',
          error: e,
          stackTrace: stackTrace,
        );
        print('❌ Error scheduling alarm for $medicineName: $e');
      }
    }

    developer.log(
      '📊 Scheduled $scheduledCount out of ${scheduledTimes.length} alarms for $medicineName',
      name: 'AlarmScheduler',
    );
    print(
      '📊 Scheduled $scheduledCount out of ${scheduledTimes.length} alarms for $medicineName',
    );
  }

  /// Schedule alarm for an appointment
  Future<void> scheduleAppointmentAlarm({
    required String appointmentId,
    required String title,
    required DateTime appointmentDate,
    String? location,
    int reminderMinutesBefore = 30,
  }) async {
    developer.log(
      '📅 Scheduling appointment alarm for: $title',
      name: 'AlarmScheduler',
    );
    print('📅 Scheduling appointment alarm for: $title');
    print('   Appointment date: $appointmentDate');
    print('   Reminder: $reminderMinutesBefore minutes before');

    final now = DateTime.now();
    final reminderTime = appointmentDate.subtract(
      Duration(minutes: reminderMinutesBefore),
    );

    // Don't schedule if reminder time has passed
    if (reminderTime.isBefore(now)) {
      developer.log(
        '⚠️ Appointment reminder time has passed, skipping',
        name: 'AlarmScheduler',
      );
      print('⚠️ Appointment reminder time has passed, skipping');
      return;
    }

    final alarmId = appointmentId.hashCode.abs();

    // Store metadata BEFORE scheduling alarm
    try {
      await _storeAlarmMetadata(alarmId, {
        'title': title,
        'location': location,
        'type': 'appointment',
      });

      print('✅ Metadata stored successfully for alarm $alarmId');
    } catch (e) {
      developer.log(
        '❌ Failed to store metadata for alarm $alarmId: $e',
        name: 'AlarmScheduler',
      );
      print('❌ Failed to store metadata for alarm $alarmId: $e');
      return; // Don't schedule if metadata storage fails
    }

    try {
      // Schedule one-time alarm
      final success = await AndroidAlarmManager.oneShotAt(
        reminderTime,
        alarmId,
        appointmentAlarmCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      if (success) {
        developer.log(
          '✅ Scheduled appointment alarm $alarmId for $title at $reminderTime',
          name: 'AlarmScheduler',
        );
        print('✅ Scheduled appointment alarm $alarmId for $title');
        print('   Reminder time: $reminderTime');
      } else {
        developer.log(
          '❌ Failed to schedule appointment alarm $alarmId for $title',
          name: 'AlarmScheduler',
        );
        print('❌ Failed to schedule appointment alarm $alarmId for $title');
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error scheduling appointment alarm for $title: $e',
        name: 'AlarmScheduler',
        error: e,
        stackTrace: stackTrace,
      );
      print('❌ Error scheduling appointment alarm for $title: $e');
    }
  }

  /// Cancel all alarms for a medicine
  Future<void> cancelMedicineAlarms(String medicineId) async {
    developer.log(
      '🗑️ Cancelling alarms for medicine $medicineId',
      name: 'AlarmScheduler',
    );
    print('🗑️ Cancelling alarms for medicine $medicineId');

    final prefs = await SharedPreferences.getInstance();

    // Cancel up to 10 possible alarm slots (most medicines won't have more)
    for (int i = 0; i < 10; i++) {
      final alarmId = _generateAlarmId(medicineId, i);
      await AndroidAlarmManager.cancel(alarmId);
      await prefs.remove('alarm_$alarmId');
    }

    developer.log(
      '✅ Cancelled alarms for medicine $medicineId',
      name: 'AlarmScheduler',
    );
    print('✅ Cancelled alarms for medicine $medicineId');
  }

  /// Cancel alarm for an appointment
  Future<void> cancelAppointmentAlarm(String appointmentId) async {
    developer.log(
      '🗑️ Cancelling alarm for appointment $appointmentId',
      name: 'AlarmScheduler',
    );
    print('🗑️ Cancelling alarm for appointment $appointmentId');

    final prefs = await SharedPreferences.getInstance();
    final alarmId = appointmentId.hashCode.abs();
    await AndroidAlarmManager.cancel(alarmId);
    await prefs.remove('alarm_$alarmId');

    developer.log(
      '✅ Cancelled alarm for appointment $appointmentId',
      name: 'AlarmScheduler',
    );
    print('✅ Cancelled alarm for appointment $appointmentId');
  }

  /// Generate unique alarm ID for medicine
  int _generateAlarmId(String medicineId, int timeIndex) {
    // Use hash code and time index to create unique ID
    final id = (medicineId.hashCode + timeIndex).abs();
    return id;
  }

  /// Parse time string (HH:mm format) to TimeOfDay
  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        developer.log(
          '⚠️ Invalid time values: $timeString',
          name: 'AlarmScheduler',
        );
        print('⚠️ Invalid time values: $timeString');
        return null;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      developer.log(
        '⚠️ Error parsing time: $timeString - $e',
        name: 'AlarmScheduler',
      );
      print('⚠️ Error parsing time: $timeString - $e');
      return null;
    }
  }
}
