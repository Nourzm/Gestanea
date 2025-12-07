// lib/features/dashboard/data/datasources/dashboard_local_data_source.dart
import '../../../../core/database/db_helper.dart';

abstract class DashboardLocalDataSource {
  Future<Map<String, dynamic>?> getActivePregnancy(int userId);
  Future<Map<String, dynamic>?> getActiveBaby(int userId);
  Future<Map<String, dynamic>?> getUserById(int userId);
  Future<List<Map<String, dynamic>>> getUpcomingAppointments(int userId, int days);
  Future<List<Map<String, dynamic>>> getUpcomingReminders(int userId, int days);
  Future<List<Map<String, dynamic>>> getUnresolvedHealthAlerts(int userId);
  Future<Map<String, dynamic>?> getTipOfTheDay(String targetAudience, int? week);
  Future<List<Map<String, dynamic>>> getTodayFeedingLogs(int babyId);
  Future<Map<String, dynamic>?> getLatestBabyGrowth(int babyId);
  Future<List<Map<String, dynamic>>> getUpcomingMilestones(int babyId);
  Future<List<Map<String, dynamic>>> getMedicineReminders(int userId);
  
  // String-based methods for UUID user IDs
  Future<Map<String, dynamic>?> getActivePregnancyByStringId(String userId);
  Future<Map<String, dynamic>?> getActiveBabyByStringId(String userId);
  Future<Map<String, dynamic>?> getUserByStringId(String userId);
  Future<List<Map<String, dynamic>>> getUpcomingAppointmentsByStringId(String userId, int days);
  Future<List<Map<String, dynamic>>> getUpcomingRemindersByStringId(String userId, int days);
  Future<List<Map<String, dynamic>>> getUnresolvedHealthAlertsByStringId(String userId);
  Future<List<Map<String, dynamic>>> getMedicineRemindersByStringId(String userId);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final DatabaseHelper _dbHelper;

  DashboardLocalDataSourceImpl({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<Map<String, dynamic>?> getActivePregnancy(int userId) async {
    final db = await _dbHelper.database;
    // Query with string since user_id is stored as TEXT in pregnancies table
    final result = await db.query(
      'pregnancies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId.toString()],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<Map<String, dynamic>?> getActiveBaby(int userId) async {
    final db = await _dbHelper.database;
    // Query with string since user_id is stored as TEXT in babies table
    final result = await db.query(
      'babies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId.toString()],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await _dbHelper.database;
    // Query with string since id is stored as TEXT in users table
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId.toString()],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getUpcomingAppointments(int userId, int days) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    
    final result = await db.query(
      'appointments',
      where: 'user_id = ? AND appointment_date >= ? AND is_completed = 0',
      whereArgs: [
        userId.toString(),
        now.toIso8601String(),
      ],
      orderBy: 'appointment_date ASC',
    );
    
    // Filter in Dart to ensure we only get appointments within the specified days
    return result.where((apt) {
      try {
        final aptDate = DateTime.parse(apt['appointment_date'].toString());
        return aptDate.isBefore(futureDate);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getUpcomingReminders(int userId, int days) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    
    final result = await db.query(
      'reminders',
      where: 'user_id = ? AND reminder_time >= ? AND reminder_time <= ? AND is_completed = 0',
      whereArgs: [
        userId.toString(),
        now.toIso8601String(),
        futureDate.toIso8601String(),
      ],
      orderBy: 'reminder_time ASC',
    );
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getUnresolvedHealthAlerts(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'risk_alerts',
      where: 'user_id = ? AND is_resolved = 0',
      whereArgs: [userId.toString()],
      orderBy: 'created_at DESC',
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>?> getTipOfTheDay(String targetAudience, int? week) async {
    final db = await _dbHelper.database;
    
    // Try to get a tip matching the target audience and week
    String whereClause = 'is_active = 1 AND target_audience = ?';
    List<dynamic> whereArgs = [targetAudience];
    
    // If week is provided, try to match tips for that week
    if (week != null) {
      // First try to get week-specific tip
      final weekTips = await db.query(
        'tips',
        where: '$whereClause AND pregnancy_week = ?',
        whereArgs: [...whereArgs, week],
      );
      
      if (weekTips.isNotEmpty) {
        // Return random tip from week-specific tips
        weekTips.shuffle();
        return weekTips.first;
      }
    }
    
    // Fall back to general tips for the target audience
    final result = await db.query(
      'tips',
      where: whereClause,
      whereArgs: whereArgs,
    );
    
    if (result.isNotEmpty) {
      result.shuffle();
      return result.first;
    }
    
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getTodayFeedingLogs(int babyId) async {
    final db = await _dbHelper.database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final result = await db.query(
      'feeding_logs',
      where: 'baby_id = ? AND logged_at >= ? AND logged_at < ?',
      whereArgs: [
        babyId,
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
      orderBy: 'logged_at DESC',
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>?> getLatestBabyGrowth(int babyId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'baby_growth',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'recorded_at DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getUpcomingMilestones(int babyId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'milestones',
      where: 'baby_id = ? AND is_completed = 0',
      whereArgs: [babyId],
      orderBy: 'expected_date ASC',
      limit: 5,
    );
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getMedicineReminders(int userId) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Get medicines that have logged entries for today or upcoming
    final result = await db.rawQuery('''
      SELECT m.*, ml.logged_at as next_dose_time
      FROM medicines m
      LEFT JOIN medicine_logged ml ON m.id = ml.medicine_id
      WHERE m.user_id = ?
      AND (ml.logged_at IS NULL OR ml.logged_at >= ?)
      ORDER BY ml.logged_at ASC
      LIMIT 10
    ''', [userId.toString(), today.toIso8601String()]);
    
    return result;
  }

  // ============ String-based methods for UUID user IDs ============

  @override
  Future<Map<String, dynamic>?> getActivePregnancyByStringId(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'pregnancies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<Map<String, dynamic>?> getActiveBabyByStringId(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'babies',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<Map<String, dynamic>?> getUserByStringId(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getUpcomingAppointmentsByStringId(String userId, int days) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    
    final result = await db.query(
      'appointments',
      where: 'user_id = ? AND appointment_date >= ? AND is_completed = 0',
      whereArgs: [
        userId,
        now.toIso8601String(),
      ],
      orderBy: 'appointment_date ASC',
    );
    
    // Filter in Dart to ensure we only get appointments within the specified days
    final filtered = result.where((apt) {
      try {
        final aptDate = DateTime.parse(apt['appointment_date'].toString());
        return aptDate.isBefore(futureDate);
      } catch (e) {
        return false;
      }
    }).toList();
    return filtered;
  }

  @override
  Future<List<Map<String, dynamic>>> getUpcomingRemindersByStringId(String userId, int days) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    
    final result = await db.query(
      'reminders',
      where: 'user_id = ? AND reminder_time >= ? AND reminder_time <= ? AND is_completed = 0',
      whereArgs: [
        userId,
        now.toIso8601String(),
        futureDate.toIso8601String(),
      ],
      orderBy: 'reminder_time ASC',
    );
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getUnresolvedHealthAlertsByStringId(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'risk_alerts',
      where: 'user_id = ? AND is_resolved = 0',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getMedicineRemindersByStringId(String userId) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final result = await db.rawQuery('''
      SELECT m.*, ml.logged_at as next_dose_time
      FROM medicines m
      LEFT JOIN medicine_logged ml ON m.id = ml.medicine_id
      WHERE m.user_id = ?
      AND (ml.logged_at IS NULL OR ml.logged_at >= ?)
      ORDER BY ml.logged_at ASC
      LIMIT 10
    ''', [userId, today.toIso8601String()]);
    
    return result;
  }
}
