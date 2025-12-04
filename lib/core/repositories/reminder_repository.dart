import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/reminder.dart';

class ReminderRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<Reminder>>> getReminders(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'reminders',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date ASC, time ASC',
      );
      final reminders = maps.map((m) => Reminder.fromMap(m)).toList();
      return Result.success(reminders);
    } catch (e) {
      return Result.failure('Failed to get reminders: ${e.toString()}');
    }
  }

  Future<Result<List<Reminder>>> getActiveReminders(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'reminders',
        where: 'user_id = ? AND is_completed = ?',
        whereArgs: [userId, 0],
        orderBy: 'date ASC, time ASC',
      );
      final reminders = maps.map((m) => Reminder.fromMap(m)).toList();
      return Result.success(reminders);
    } catch (e) {
      return Result.failure('Failed to get active reminders: ${e.toString()}');
    }
  }

  Future<Result<Reminder>> addReminder(Reminder reminder) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('reminders', reminder.toMap());
      return Result.success(reminder, 'Reminder added successfully');
    } catch (e) {
      return Result.failure('Failed to add reminder: ${e.toString()}');
    }
  }

  Future<Result<Reminder>> updateReminder(Reminder reminder) async {
    try {
      final db = await _dbHelper.database;
      await db.update('reminders', reminder.toMap(), where: 'id = ?', whereArgs: [reminder.id]);
      return Result.success(reminder, 'Reminder updated successfully');
    } catch (e) {
      return Result.failure('Failed to update reminder: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteReminder(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Reminder deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete reminder: ${e.toString()}');
    }
  }

  Future<Result<Reminder>> markAsCompleted(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('reminders', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.failure('Reminder not found');
      
      final reminder = Reminder.fromMap(maps.first);
      final updated = Reminder(
        id: reminder.id,
        userId: reminder.userId,
        title: reminder.title,
        description: reminder.description,
        date: reminder.date,
        time: reminder.time,
        type: reminder.type,
        isCompleted: true,
        createdAt: reminder.createdAt,
      );
      
      await db.update('reminders', updated.toMap(), where: 'id = ?', whereArgs: [id]);
      return Result.success(updated, 'Reminder marked as completed');
    } catch (e) {
      return Result.failure('Failed to mark reminder as completed: ${e.toString()}');
    }
  }
}
