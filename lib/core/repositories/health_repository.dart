import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/vital.dart';
import 'package:gestanea/core/models/symptom.dart';
import 'package:gestanea/core/models/mood.dart';
import 'package:gestanea/core/models/lab_result.dart';

class HealthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Vitals
  Future<Result<List<Vital>>> getVitals(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'vitals',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC, time DESC',
      );
      final vitals = maps.map((m) => Vital.fromMap(m)).toList();
      return Result.success(vitals);
    } catch (e) {
      return Result.failure('Failed to get vitals: ${e.toString()}');
    }
  }

  Future<Result<Vital>> addVital(Vital vital) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('vitals', vital.toMap());
      return Result.success(vital, 'Vital added successfully');
    } catch (e) {
      return Result.failure('Failed to add vital: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteVital(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('vitals', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Vital deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete vital: ${e.toString()}');
    }
  }

  // Symptoms
  Future<Result<List<Symptom>>> getSymptoms(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'symptoms',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC, time DESC',
      );
      final symptoms = maps.map((m) => Symptom.fromMap(m)).toList();
      return Result.success(symptoms);
    } catch (e) {
      return Result.failure('Failed to get symptoms: ${e.toString()}');
    }
  }

  Future<Result<Symptom>> addSymptom(Symptom symptom) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('symptoms', symptom.toMap());
      return Result.success(symptom, 'Symptom added successfully');
    } catch (e) {
      return Result.failure('Failed to add symptom: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteSymptom(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('symptoms', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Symptom deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete symptom: ${e.toString()}');
    }
  }

  // Moods
  Future<Result<List<Mood>>> getMoods(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'moods',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC, time DESC',
      );
      final moods = maps.map((m) => Mood.fromMap(m)).toList();
      return Result.success(moods);
    } catch (e) {
      return Result.failure('Failed to get moods: ${e.toString()}');
    }
  }

  Future<Result<Mood>> addMood(Mood mood) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('moods', mood.toMap());
      return Result.success(mood, 'Mood added successfully');
    } catch (e) {
      return Result.failure('Failed to add mood: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteMood(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('moods', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Mood deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete mood: ${e.toString()}');
    }
  }

  // Lab Results
  Future<Result<List<LabResult>>> getLabResults(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'lab_results',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
      );
      final labResults = maps.map((m) => LabResult.fromMap(m)).toList();
      return Result.success(labResults);
    } catch (e) {
      return Result.failure('Failed to get lab results: ${e.toString()}');
    }
  }

  Future<Result<LabResult>> addLabResult(LabResult labResult) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('lab_results', labResult.toMap());
      return Result.success(labResult, 'Lab result added successfully');
    } catch (e) {
      return Result.failure('Failed to add lab result: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteLabResult(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('lab_results', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Lab result deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete lab result: ${e.toString()}');
    }
  }
}
