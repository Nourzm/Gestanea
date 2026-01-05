// lib/features/pregnancy/domain/entities/pregnancy.dart
class Pregnancy {
  final String id;
  final DateTime lastMenstrualPeriod;
  final DateTime estimatedDueDate;
  final int currentWeek;
  final int currentDay;
  final int daysLeft;
  final String trimester;
  final double progressPercentage;

  const Pregnancy({
    required this.id,
    required this.lastMenstrualPeriod,
    required this.estimatedDueDate,
    required this.currentWeek,
    required this.currentDay,
    required this.daysLeft,
    required this.trimester,
    required this.progressPercentage,
  });

  String get trimesterDisplay {
    if (currentWeek <= 13) return '1st Trimester';
    if (currentWeek <= 26) return '2nd Trimester';
    return '3rd Trimester';
  }
}