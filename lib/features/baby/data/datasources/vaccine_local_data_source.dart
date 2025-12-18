import 'package:sqflite/sqflite.dart';
import 'package:gestanea/core/database/db_helper.dart';

class VaccineLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getVaccinesForBaby(String babyId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'vaccines',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'scheduled_months ASC',
    );
  }

  Future<void> insertVaccine(Map<String, dynamic> vaccine) async {
    final db = await _dbHelper.database;
    await db.insert('vaccines', vaccine);
  }

  Future<void> scheduleVaccine(String vaccineId, String scheduledDate) async {
    final db = await _dbHelper.database;
    await db.update(
      'vaccines',
      {'scheduled_date': scheduledDate, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [vaccineId],
    );
  }

  Future<void> markVaccineAsDone(String vaccineId, String completedDate) async {
    final db = await _dbHelper.database;
    await db.update(
      'vaccines',
      {'is_completed': 1, 'completed_date': completedDate, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [vaccineId],
    );
  }

  Future<void> rescheduleVaccine(String vaccineId, String newDate) async {
    final db = await _dbHelper.database;
    await db.update(
      'vaccines',
      {'scheduled_date': newDate, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [vaccineId],
    );
  }

  Future<Map<String, dynamic>?> getVaccineById(String vaccineId) async {
    final db = await _dbHelper.database;
    final result = await db.query('vaccines', where: 'id = ?', whereArgs: [vaccineId]);
    return result.isNotEmpty ? result.first : null;
  }
}
