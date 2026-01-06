// lib/features/dashboard/data/repositories/dashboard_repository_impl.dart
import '../../domain/entities/pregnancy_dashboard.dart';
import '../../domain/entities/postpartum_dashboard.dart';
import '../datasources/dashboard_local_data_source.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _localDataSource;

  DashboardRepositoryImpl({DashboardLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? DashboardLocalDataSourceImpl();

  @override
  Future<bool> isUserPregnant(int userId) async {
    final pregnancy = await _localDataSource.getActivePregnancy(userId);
    return pregnancy != null;
  }

  @override
  Future<bool> hasActiveBaby(int userId) async {
    final baby = await _localDataSource.getActiveBaby(userId);
    return baby != null;
  }

  @override
  Future<PregnancyDashboard> getPregnancyDashboard(int userId) async {
    // Get user info
    final user = await _localDataSource.getUserById(userId);
    final userName = user?['name'] ?? 'User';

    // Get active pregnancy
    final pregnancy = await _localDataSource.getActivePregnancy(userId);

    int currentWeek = 1;
    int currentDay = 0;
    String trimester = '1st Trimester';
    int daysLeft = 280;
    double progressPercentage = 0;

    if (pregnancy != null) {
      // Calculate week from LMP date
      final lmpDateStr = pregnancy['lmp_date'] as String?;
      if (lmpDateStr != null) {
        final lmpDate = DateTime.parse(lmpDateStr);
        final now = DateTime.now();
        final daysSinceLmp = now.difference(lmpDate).inDays;

        currentWeek = (daysSinceLmp ~/ 7) + 1;
        currentDay = daysSinceLmp % 7;

        // Calculate trimester
        if (currentWeek <= 12) {
          trimester = '1st Trimester';
        } else if (currentWeek <= 27) {
          trimester = '2nd Trimester';
        } else {
          trimester = '3rd Trimester';
        }

        // Calculate days left (40 weeks = 280 days)
        daysLeft = 280 - daysSinceLmp;
        if (daysLeft < 0) daysLeft = 0;

        // Calculate progress percentage
        progressPercentage = (daysSinceLmp / 280) * 100;
        if (progressPercentage > 100) progressPercentage = 100;
      }
    }

    // Get upcoming appointments (7 days)
    final appointmentsData = await _localDataSource.getUpcomingAppointments(
      userId,
      7,
    );
    final appointments = appointmentsData
        .map(
          (a) => AppointmentReminder(
            id: a['id'].toString(),
            title: a['title'] ?? 'Appointment',
            dateTime: DateTime.parse(a['appointment_date']),
            type: a['type'] ?? 'general',
          ),
        )
        .toList();

    // Get upcoming reminders and convert to appointments format
    final remindersData = await _localDataSource.getUpcomingReminders(
      userId,
      7,
    );
    for (final r in remindersData) {
      appointments.add(
        AppointmentReminder(
          id: 'reminder_${r['id']}',
          title: r['title'] ?? 'Reminder',
          dateTime: DateTime.parse(r['reminder_time']),
          type: 'reminder',
        ),
      );
    }

    // Sort all by date
    appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Get medicine reminders
    final medicinesData = await _localDataSource.getMedicineReminders(userId);
    final medicineReminders = medicinesData
        .map(
          (m) => MedicineReminder(
            id: m['id'].toString(),
            medicineName: m['name'] ?? 'Medicine',
            nextDoseTime: m['next_dose_time'] != null
                ? DateTime.parse(m['next_dose_time'])
                : DateTime.now(),
            dosage: m['dosage'] ?? '',
          ),
        )
        .toList();

    // Get unresolved health alerts
    final alertsData = await _localDataSource.getUnresolvedHealthAlerts(userId);
    final healthAlerts = alertsData
        .map(
          (a) => HealthAlert(
            id: a['id'].toString(),
            message: a['alert_message'] ?? a['message'] ?? 'Health Alert',
            severity: a['severity'] ?? 'medium',
            createdAt: a['created_at'] != null
                ? DateTime.parse(a['created_at'])
                : DateTime.now(),
          ),
        )
        .toList();

    // Get tip of the day for pregnant users
    final tipData = await _localDataSource.getTipOfTheDay(
      'pregnant',
      currentWeek,
    );
    final tipOfTheDay =
        tipData?['content'] ??
        'Stay hydrated! Drink at least 8 glasses of water daily.';

    return PregnancyDashboard(
      userName: userName,
      currentWeek: currentWeek,
      currentDay: currentDay,
      trimester: trimester,
      daysLeft: daysLeft,
      progressPercentage: progressPercentage,
      upcomingAppointments: appointments,
      medicineReminders: medicineReminders,
      healthAlerts: healthAlerts,
      tipOfTheDay: tipOfTheDay,
    );
  }

  @override
  Future<PostpartumDashboard> getPostpartumDashboard(int userId) async {
    // Get user info
    final user = await _localDataSource.getUserById(userId);
    final userName = user?['name'] ?? 'User';

    // Get active baby
    final baby = await _localDataSource.getActiveBaby(userId);

    String babyName = 'Baby';
    String babyGender = 'girl'; // Default to girl
    int babyAgeInMonths = 0;
    double babyWeight = 0;
    double babyHeight = 0;
    int babyId = 0;

    if (baby != null) {
      babyId = baby['id'] as int;
      babyName = baby['name'] ?? 'Baby';
      babyGender = (baby['gender'] as String?)?.toLowerCase() ?? 'girl';

      // Calculate age in months
      final dobStr = baby['date_of_birth'] as String?;
      if (dobStr != null) {
        final dob = DateTime.parse(dobStr);
        final now = DateTime.now();
        babyAgeInMonths = ((now.difference(dob).inDays) / 30).floor();
      }

      // Get latest growth data
      final growth = await _localDataSource.getLatestBabyGrowth(babyId);
      if (growth != null) {
        babyWeight = (growth['weight'] as num?)?.toDouble() ?? 0;
        babyHeight = (growth['height'] as num?)?.toDouble() ?? 0;
      } else {
        // Fall back to birth weight/height
        babyWeight = (baby['birth_weight'] as num?)?.toDouble() ?? 0;
        babyHeight = (baby['birth_height'] as num?)?.toDouble() ?? 0;
      }
    }

    // Get growth status based on age and weight (simplified)
    String growthStatus = 'On track';

    // Get upcoming milestones as vaccine reminders
    final milestonesData = babyId > 0
        ? await _localDataSource.getUpcomingMilestones(babyId)
        : <Map<String, dynamic>>[];
    final nextVaccines = milestonesData
        .map(
          (m) => VaccineReminder(
            id: m['id'].toString(),
            vaccineName: m['title'] ?? m['name'] ?? 'Milestone',
            dueDate: m['expected_date'] != null
                ? DateTime.parse(m['expected_date'])
                : DateTime.now(),
            isCompleted: (m['is_completed'] ?? 0) == 1,
          ),
        )
        .toList();

    // Get today's feeding schedule
    final feedingData = babyId > 0
        ? await _localDataSource.getTodayFeedingLogs(babyId)
        : <Map<String, dynamic>>[];

    int totalFeedings = feedingData.length;
    int breastfeedCount = 0;
    int bottleCount = 0;
    DateTime lastFeedingTime = DateTime.now();

    for (final f in feedingData) {
      final type = f['type'] ?? f['feeding_type'] ?? '';
      if (type.toString().toLowerCase().contains('breast')) {
        breastfeedCount++;
      } else {
        bottleCount++;
      }
    }

    if (feedingData.isNotEmpty) {
      lastFeedingTime = DateTime.parse(feedingData.first['logged_at']);
    }

    final todayFeedingSchedule = FeedingSchedule(
      totalFeedings: totalFeedings,
      breastfeedCount: breastfeedCount,
      bottleCount: bottleCount,
      lastFeedingTime: lastFeedingTime,
    );

    // Get mother health status (from user's latest vitals/symptoms)
    final motherHealthStatus = MotherHealthStatus(
      overallStatus: 'good',
      concerns: [],
      lastCheckup: DateTime.now().subtract(const Duration(days: 7)),
    );

    // Get tip of the day for postpartum
    final tipData = await _localDataSource.getTipOfTheDay('postpartum', null);
    final tipOfTheDay =
        tipData?['content'] ??
        'Tummy time helps strengthen baby\'s neck and back muscles. Start with 3-5 minutes.';

    return PostpartumDashboard(
      userName: userName,
      babyName: babyName,
      babyGender: babyGender,
      babyAgeInMonths: babyAgeInMonths,
      babyWeight: babyWeight,
      babyHeight: babyHeight,
      growthStatus: growthStatus,
      nextVaccines: nextVaccines,
      todayFeedingSchedule: todayFeedingSchedule,
      motherHealthStatus: motherHealthStatus,
      tipOfTheDay: tipOfTheDay,
    );
  }

  // ============ String-based methods for UUID user IDs ============

  @override
  Future<bool> isUserPregnantByStringId(String userId) async {
    final pregnancy = await _localDataSource.getActivePregnancyByStringId(
      userId,
    );
    return pregnancy != null;
  }

  @override
  Future<bool> hasActiveBabyByStringId(String userId) async {
    final baby = await _localDataSource.getActiveBabyByStringId(userId);
    return baby != null;
  }

  @override
  Future<PregnancyDashboard> getPregnancyDashboardByStringId(
    String userId,
  ) async {
    final user = await _localDataSource.getUserByStringId(userId);
    final userName = user?['name'] ?? 'User';

    final pregnancy = await _localDataSource.getActivePregnancyByStringId(
      userId,
    );

    int currentWeek = 1;
    int currentDay = 0;
    String trimester = '1st Trimester';
    int daysLeft = 280;
    double progressPercentage = 0;

    if (pregnancy != null) {
      final lmpDateStr = pregnancy['lmp_date'] as String?;
      if (lmpDateStr != null) {
        final lmpDate = DateTime.parse(lmpDateStr);
        final now = DateTime.now();
        final daysSinceLmp = now.difference(lmpDate).inDays;

        currentWeek = (daysSinceLmp ~/ 7) + 1;
        currentDay = daysSinceLmp % 7;

        if (currentWeek <= 12) {
          trimester = '1st Trimester';
        } else if (currentWeek <= 27) {
          trimester = '2nd Trimester';
        } else {
          trimester = '3rd Trimester';
        }

        daysLeft = 280 - daysSinceLmp;
        if (daysLeft < 0) daysLeft = 0;

        progressPercentage = (daysSinceLmp / 280) * 100;
        if (progressPercentage > 100) progressPercentage = 100;
      }
    }

    final appointmentsData = await _localDataSource
        .getUpcomingAppointmentsByStringId(userId, 7);
    final appointments = appointmentsData
        .map(
          (a) => AppointmentReminder(
            id: a['id'].toString(),
            title: a['title'] ?? 'Appointment',
            dateTime: DateTime.parse(a['appointment_date']),
            type: a['type'] ?? 'general',
          ),
        )
        .toList();

    final remindersData = await _localDataSource.getUpcomingRemindersByStringId(
      userId,
      7,
    );
    for (final r in remindersData) {
      appointments.add(
        AppointmentReminder(
          id: 'reminder_${r['id']}',
          title: r['title'] ?? 'Reminder',
          dateTime: DateTime.parse(r['reminder_time']),
          type: 'reminder',
        ),
      );
    }

    appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final medicinesData = await _localDataSource.getMedicineRemindersByStringId(
      userId,
    );
    final medicineReminders = medicinesData
        .map(
          (m) => MedicineReminder(
            id: m['id'].toString(),
            medicineName: m['name'] ?? 'Medicine',
            nextDoseTime: m['next_dose_time'] != null
                ? DateTime.parse(m['next_dose_time'])
                : DateTime.now(),
            dosage: m['dosage'] ?? '',
          ),
        )
        .toList();

    final alertsData = await _localDataSource
        .getUnresolvedHealthAlertsByStringId(userId);
    final healthAlerts = alertsData
        .map(
          (a) => HealthAlert(
            id: a['id'].toString(),
            message: a['alert_message'] ?? a['message'] ?? 'Health Alert',
            severity: a['severity'] ?? 'medium',
            createdAt: a['created_at'] != null
                ? DateTime.parse(a['created_at'])
                : DateTime.now(),
          ),
        )
        .toList();

    final tipData = await _localDataSource.getTipOfTheDay(
      'pregnant',
      currentWeek,
    );
    final tipOfTheDay =
        tipData?['content'] ??
        'Stay hydrated! Drink at least 8 glasses of water daily.';

    return PregnancyDashboard(
      userName: userName,
      currentWeek: currentWeek,
      currentDay: currentDay,
      trimester: trimester,
      daysLeft: daysLeft,
      progressPercentage: progressPercentage,
      upcomingAppointments: appointments,
      medicineReminders: medicineReminders,
      healthAlerts: healthAlerts,
      tipOfTheDay: tipOfTheDay,
    );
  }

  @override
  Future<PostpartumDashboard> getPostpartumDashboardByStringId(
    String userId,
  ) async {
    final user = await _localDataSource.getUserByStringId(userId);
    final userName = user?['name'] ?? 'User';

    final baby = await _localDataSource.getActiveBabyByStringId(userId);

    String babyName = 'Baby';
    String babyGender = 'girl'; // Default to girl
    int babyAgeInMonths = 0;
    double? babyWeight;
    double? babyHeight;

    if (baby != null) {
      babyName = baby['name'] ?? 'Baby';
      babyGender = (baby['gender'] as String?)?.toLowerCase() ?? 'girl';
      final dobStr = baby['date_of_birth'] as String?;
      if (dobStr != null) {
        final dob = DateTime.parse(dobStr);
        final now = DateTime.now();
        babyAgeInMonths = (now.difference(dob).inDays / 30).floor();
      }

      babyWeight = baby['birth_weight'] as double?;
      babyHeight = baby['birth_height'] as double?;
    }

    const growthStatus = 'On Track';
    final nextVaccines = <VaccineReminder>[];
    final todayFeedingSchedule = FeedingSchedule(
      totalFeedings: 0,
      breastfeedCount: 0,
      bottleCount: 0,
      lastFeedingTime: DateTime.now(),
    );

    final motherHealthStatus = MotherHealthStatus(
      overallStatus: 'good',
      concerns: [],
      lastCheckup: DateTime.now().subtract(const Duration(days: 7)),
    );

    final tipData = await _localDataSource.getTipOfTheDay('postpartum', null);
    final tipOfTheDay =
        tipData?['content'] ??
        'Tummy time helps strengthen baby\'s neck and back muscles. Start with 3-5 minutes.';

    return PostpartumDashboard(
      userName: userName,
      babyName: babyName,
      babyGender: babyGender,
      babyAgeInMonths: babyAgeInMonths,
      babyWeight: babyWeight ?? 0.0,
      babyHeight: babyHeight ?? 0.0,
      growthStatus: growthStatus,
      nextVaccines: nextVaccines,
      todayFeedingSchedule: todayFeedingSchedule,
      motherHealthStatus: motherHealthStatus,
      tipOfTheDay: tipOfTheDay,
    );
  }
}
