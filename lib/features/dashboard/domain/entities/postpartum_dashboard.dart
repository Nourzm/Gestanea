// lib/features/dashboard/domain/entities/postpartum_dashboard.dart
class PostpartumDashboard {
  final String userName;
  final String babyName;
  final int babyAgeInMonths;
  final double babyWeight;
  final double babyHeight;
  final String growthStatus;
  final List<VaccineReminder> nextVaccines;
  final FeedingSchedule todayFeedingSchedule;
  final MotherHealthStatus motherHealthStatus;
  final String tipOfTheDay;

  const PostpartumDashboard({
    required this.userName,
    required this.babyName,
    required this.babyAgeInMonths,
    required this.babyWeight,
    required this.babyHeight,
    required this.growthStatus,
    required this.nextVaccines,
    required this.todayFeedingSchedule,
    required this.motherHealthStatus,
    required this.tipOfTheDay,
  });
}

class VaccineReminder {
  final String id;
  final String vaccineName;
  final DateTime dueDate;
  final bool isCompleted;

  const VaccineReminder({
    required this.id,
    required this.vaccineName,
    required this.dueDate,
    required this.isCompleted,
  });
}

class FeedingSchedule {
  final int totalFeedings;
  final int breastfeedCount;
  final int bottleCount;
  final DateTime lastFeedingTime;

  const FeedingSchedule({
    required this.totalFeedings,
    required this.breastfeedCount,
    required this.bottleCount,
    required this.lastFeedingTime,
  });
}

class MotherHealthStatus {
  final String overallStatus; // 'good', 'needs attention'
  final List<String> concerns;
  final DateTime lastCheckup;

  const MotherHealthStatus({
    required this.overallStatus,
    required this.concerns,
    required this.lastCheckup,
  });
}