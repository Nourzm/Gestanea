import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/doctor.dart';

class DoctorRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<Doctor>>> getAllDoctors() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('doctors', orderBy: 'rating DESC');
      final doctors = maps.map((m) => Doctor.fromMap(m)).toList();
      return Result.success(doctors);
    } catch (e) {
      return Result.failure('Failed to get doctors: ${e.toString()}');
    }
  }

  Future<Result<List<Doctor>>> getDoctorsBySpecialty(String specialty) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'doctors',
        where: 'specialty = ?',
        whereArgs: [specialty],
        orderBy: 'rating DESC',
      );
      final doctors = maps.map((m) => Doctor.fromMap(m)).toList();
      return Result.success(doctors);
    } catch (e) {
      return Result.failure('Failed to get doctors by specialty: ${e.toString()}');
    }
  }

  Future<Result<List<Doctor>>> searchDoctors(String query) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'doctors',
        where: 'name LIKE ? OR specialty LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'rating DESC',
      );
      final doctors = maps.map((m) => Doctor.fromMap(m)).toList();
      return Result.success(doctors);
    } catch (e) {
      return Result.failure('Failed to search doctors: ${e.toString()}');
    }
  }

  Future<Result<List<Doctor>>> getFavoriteDoctors(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.rawQuery('''
        SELECT d.* FROM doctors d
        INNER JOIN user_favorite_doctors ufd ON d.id = ufd.doctor_id
        WHERE ufd.user_id = ?
        ORDER BY d.rating DESC
      ''', [userId]);
      final doctors = maps.map((m) => Doctor.fromMap(m)).toList();
      return Result.success(doctors);
    } catch (e) {
      return Result.failure('Failed to get favorite doctors: ${e.toString()}');
    }
  }

  Future<Result<bool>> toggleFavorite(String userId, String doctorId) async {
    try {
      final db = await _dbHelper.database;
      
      // Check if already favorited
      final existing = await db.query(
        'user_favorite_doctors',
        where: 'user_id = ? AND doctor_id = ?',
        whereArgs: [userId, doctorId],
      );

      if (existing.isNotEmpty) {
        // Remove from favorites
        await db.delete(
          'user_favorite_doctors',
          where: 'user_id = ? AND doctor_id = ?',
          whereArgs: [userId, doctorId],
        );
        return Result.success(false, 'Removed from favorites');
      } else {
        // Add to favorites
        await db.insert('user_favorite_doctors', {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'user_id': userId,
          'doctor_id': doctorId,
          'favorited_at': DateTime.now().toIso8601String(),
        });
        return Result.success(true, 'Added to favorites');
      }
    } catch (e) {
      return Result.failure('Failed to toggle favorite: ${e.toString()}');
    }
  }

  Future<Result<bool>> isFavorite(String userId, String doctorId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'user_favorite_doctors',
        where: 'user_id = ? AND doctor_id = ?',
        whereArgs: [userId, doctorId],
      );
      return Result.success(maps.isNotEmpty);
    } catch (e) {
      return Result.failure('Failed to check favorite status: ${e.toString()}');
    }
  }
}
