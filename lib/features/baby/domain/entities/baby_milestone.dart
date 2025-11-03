// lib/features/dashboard/domain/entities/pregnancy_dashboard.dart
class PregnancyDashboard {
  final String userName;
  final int currentWeek;
  final int currentDay;
  final String trimester;
  final int daysLeft;
  final double progressPercentage;
  final List<AppointmentReminder> upcomingAppointments;
  final List<MedicineReminder> medicineReminders;
  final List<HealthAlert> healthAlerts;
  final String tipOfTheDay;

  const PregnancyDashboard({
    required this.userName,
    required this.currentWeek,
    required this.currentDay,
    required this.trimester,
    required this.daysLeft,
    required this.progressPercentage,
    required this.upcomingAppointments,
    required this.medicineReminders,
    required this.healthAlerts,
    required this.tipOfTheDay,
  });
}

class AppointmentReminder {
  final String id;
  final String title;
  final DateTime dateTime;
  final String type; // 'doctor', 'ultrasound', 'test'

  const AppointmentReminder({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.type,
  });
}

class MedicineReminder {
  final String id;
  final String medicineName;
  final DateTime nextDoseTime;
  final String dosage;

  const MedicineReminder({
    required this.id,
    required this.medicineName,
    required this.nextDoseTime,
    required this.dosage,
  });
}

class HealthAlert {
  final String id;
  final String message;
  final String severity; // 'low', 'medium', 'high'
  final DateTime createdAt;

  const HealthAlert({
    required this.id,
    required this.message,
    required this.severity,
    required this.createdAt,
  });
}