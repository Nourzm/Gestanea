import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/milestone.dart';

class MilestoneRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<Milestone>>> getMilestones(String babyId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'milestones',
        where: 'baby_id = ?',
        whereArgs: [babyId],
        orderBy: 'expected_age_months ASC',
      );
      final milestones = maps.map((m) => Milestone.fromMap(m)).toList();
      return Result.success(milestones);
    } catch (e) {
      return Result.failure('Failed to get milestones: ${e.toString()}');
    }
  }

  Future<Result<Milestone>> addMilestone(Milestone milestone) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('milestones', milestone.toMap());
      return Result.success(milestone, 'Milestone added successfully');
    } catch (e) {
      return Result.failure('Failed to add milestone: ${e.toString()}');
    }
  }

  Future<Result<Milestone>> updateMilestone(Milestone milestone) async {
    try {
      final db = await _dbHelper.database;
      await db.update('milestones', milestone.toMap(), where: 'id = ?', whereArgs: [milestone.id]);
      return Result.success(milestone, 'Milestone updated successfully');
    } catch (e) {
      return Result.failure('Failed to update milestone: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteMilestone(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('milestones', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Milestone deleted successfully');
    } catch (e) {
      return Result.failure('Failed to delete milestone: ${e.toString()}');
    }
  }

  Future<Result<Milestone>> markMilestoneAchieved(String id, DateTime achievedDate) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('milestones', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.failure('Milestone not found');
      
      final milestone = Milestone.fromMap(maps.first);
      final updated = Milestone(
        id: milestone.id,
        babyId: milestone.babyId,
        title: milestone.title,
        description: milestone.description,
        category: milestone.category,
        expectedAgeMonths: milestone.expectedAgeMonths,
        achieved: true,
        achievedDate: achievedDate,
        notes: milestone.notes,
        createdAt: milestone.createdAt,
      );
      
      await db.update('milestones', updated.toMap(), where: 'id = ?', whereArgs: [id]);
      return Result.success(updated, 'Milestone marked as achieved');
    } catch (e) {
      return Result.failure('Failed to mark milestone as achieved: ${e.toString()}');
    }
  }
}
