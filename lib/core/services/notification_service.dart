import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

/// Service to handle local notifications for medicines and appointments
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) {
      developer.log(
        '⚠️ Notification service already initialized',
        name: 'NotificationService',
      );
      return;
    }

    developer.log(
      '🚀 Initializing notification service...',
      name: 'NotificationService',
    );

    try {
      // Request notification permission for Android 13+
      final permissionStatus = await Permission.notification.request();
      developer.log(
        '📱 Notification permission: $permissionStatus',
        name: 'NotificationService',
      );

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initSettings = InitializationSettings(android: androidSettings);

      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
      developer.log(
        '✅ Notification service initialized: $initialized',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to initialize notification service: $e',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    developer.log(
      '👆 Notification tapped: ${response.payload}',
      name: 'NotificationService',
    );
    // Handle navigation based on payload if needed
  }

  /// Show a medicine reminder notification
  Future<void> showMedicineNotification({
    required int id,
    required String medicineName,
    required String dosage,
  }) async {
    developer.log(
      '💊 Showing medicine notification: $medicineName',
      name: 'NotificationService',
    );

    try {
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

      await _notifications.show(
        id,
        'Medicine Reminder',
        'Time to take $medicineName ($dosage)',
        notificationDetails,
        payload: 'medicine:$id',
      );

      developer.log(
        '✅ Medicine notification shown successfully',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to show medicine notification: $e',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Show an appointment reminder notification
  Future<void> showAppointmentNotification({
    required int id,
    required String title,
    required String? location,
  }) async {
    developer.log(
      '📅 Showing appointment notification: $title',
      name: 'NotificationService',
    );

    try {
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

      final locationText = location != null ? ' at $location' : '';
      await _notifications.show(
        id,
        'Appointment Reminder',
        'You have an appointment: $title$locationText',
        notificationDetails,
        payload: 'appointment:$id',
      );

      developer.log(
        '✅ Appointment notification shown successfully',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to show appointment notification: $e',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
