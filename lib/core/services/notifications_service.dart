import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Thin wrapper around `flutter_local_notifications` that exposes the few
/// operations the Gestanéa app actually needs: schedule a medicine reminder,
/// schedule an appointment alert, and cancel by id.
///
/// Notifications are LOCAL (device-only). There is no Firebase/push server.
class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // Android 13+ requires explicit runtime permission.
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.requestNotificationsPermission();

    _initialized = true;
  }

  NotificationDetails get _medicineDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      'gestanea_medicine',
      'Medicine reminders',
      channelDescription: 'Reminders to take prescribed medication',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  NotificationDetails get _appointmentDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      'gestanea_appointments',
      'Appointment alerts',
      channelDescription: 'Reminders about upcoming appointments',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Stable integer id derived from a string identifier (UUID, etc.) so the
  /// caller can later cancel/replace the same notification.
  int idFromString(String key) =>
      key.hashCode & 0x7fffffff; // Strip sign bit for plugin.

  Future<void> scheduleMedicineReminder({
    required String key,
    required String medicineName,
    required String dose,
    required DateTime when,
  }) async {
    await init();
    try {
      await _plugin.zonedSchedule(
        idFromString(key),
        'Time for $medicineName',
        'Take $dose',
        tz.TZDateTime.from(when, tz.local),
        _medicineDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      // Fall back to non-exact if the host denies SCHEDULE_EXACT_ALARM.
      debugPrint('Exact schedule failed, retrying inexact: $e');
      await _plugin.zonedSchedule(
        idFromString(key),
        'Time for $medicineName',
        'Take $dose',
        tz.TZDateTime.from(when, tz.local),
        _medicineDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleAppointmentAlert({
    required String key,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    await init();
    await _plugin.zonedSchedule(
      idFromString(key),
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      _appointmentDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(String key) async {
    await _plugin.cancel(idFromString(key));
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
