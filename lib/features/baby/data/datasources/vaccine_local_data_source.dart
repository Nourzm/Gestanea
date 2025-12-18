import 'package:sqflite/sqflite.dart';
import 'package:gestanea/core/database/db_helper.dart';

class VaccineLocalDataSource {
  /// Returns the next user-scheduled (not completed) vaccines for a baby, ordered by scheduled_date.
  Future<List<Map<String, dynamic>>> getUpcomingVaccinesForBaby(String babyId, {int limit = 10}) async {
    final db = await _dbHelper.database;
    return await db.query(
      'vaccines',
      where: 'baby_id = ? AND is_completed = 0 AND scheduled_date IS NOT NULL AND scheduled_date != ""',
      whereArgs: [babyId],
      orderBy: 'scheduled_date ASC',
      limit: limit,
    );
  }

    /// Seeds the national vaccine schedule for a given babyId
    Future<void> seedNationalVaccinesForBaby(String babyId) async {
      print('Seeding vaccines for baby: $babyId');
      final db = await _dbHelper.database;
      final now = DateTime.now().toIso8601String();
      final vaccines = [
        {
          'id': '${babyId}_birth',
          'baby_id': babyId,
          'vaccine_name': 'BCG + HBV',
          'scheduled_age': 'Naissance',
          'scheduled_months': 0,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_2m',
          'baby_id': babyId,
          'vaccine_name': 'DTCaVPI-Hib-HBV + VPC + VPO',
          'scheduled_age': '02 mois',
          'scheduled_months': 2,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_4m',
          'baby_id': babyId,
          'vaccine_name': 'DTCaVPI-Hib-HBV + VPC + VPO',
          'scheduled_age': '04 mois',
          'scheduled_months': 4,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_11m',
          'baby_id': babyId,
          'vaccine_name': 'ROR',
          'scheduled_age': '11 mois',
          'scheduled_months': 11,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_12m',
          'baby_id': babyId,
          'vaccine_name': 'DTCaVPI-Hib-HBV + VPC + VPO',
          'scheduled_age': '12 mois',
          'scheduled_months': 12,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_18m',
          'baby_id': babyId,
          'vaccine_name': 'ROR',
          'scheduled_age': '18 mois',
          'scheduled_months': 18,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_6y',
          'baby_id': babyId,
          'vaccine_name': 'DTCaVPI',
          'scheduled_age': '06 ans',
          'scheduled_months': 72,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_11y',
          'baby_id': babyId,
          'vaccine_name': 'dT',
          'scheduled_age': '11-13 ans',
          'scheduled_months': 132,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_16y',
          'baby_id': babyId,
          'vaccine_name': 'dT',
          'scheduled_age': '16-18 ans',
          'scheduled_months': 192,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
        {
          'id': '${babyId}_10y_repeat',
          'baby_id': babyId,
          'vaccine_name': 'dT',
          'scheduled_age': 'Tous les 10 ans',
          'scheduled_months': 120,
          'scheduled_date': null,
          'is_completed': 0,
          'completed_date': null,
          'created_at': now,
          'updated_at': now,
        },
      ];
      for (final v in vaccines) {
        try {
          await db.insert('vaccines', v, conflictAlgorithm: ConflictAlgorithm.ignore);
          print('Inserted vaccine: \'${v['vaccine_name']}\' for baby $babyId');
        } catch (e) {
          print('Error inserting vaccine for baby $babyId: $e');
        }
      }
      print('Finished seeding vaccines for baby: $babyId');
    }
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
