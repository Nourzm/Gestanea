import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/models/result.dart';
import 'package:gestanea/core/models/risk_alert.dart';

class RiskRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Result<List<RiskAlert>>> getRiskAlerts(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'risk_alerts',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      final alerts = maps.map((m) => RiskAlert.fromMap(m)).toList();
      return Result.success(alerts);
    } catch (e) {
      return Result.failure('Failed to get risk alerts: ${e.toString()}');
    }
  }

  Future<Result<List<RiskAlert>>> getActiveRiskAlerts(String userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'risk_alerts',
        where: 'user_id = ? AND is_resolved = ?',
        whereArgs: [userId, 0],
        orderBy: 'created_at DESC',
      );
      final alerts = maps.map((m) => RiskAlert.fromMap(m)).toList();
      return Result.success(alerts);
    } catch (e) {
      return Result.failure('Failed to get active risk alerts: ${e.toString()}');
    }
  }

  Future<Result<RiskAlert>> addRiskAlert(RiskAlert alert) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('risk_alerts', alert.toMap());
      return Result.success(alert, 'Risk alert added');
    } catch (e) {
      return Result.failure('Failed to add risk alert: ${e.toString()}');
    }
  }

  Future<Result<RiskAlert>> resolveAlert(String id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('risk_alerts', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.failure('Risk alert not found');
      
      final alert = RiskAlert.fromMap(maps.first);
      final updated = RiskAlert(
        id: alert.id,
        userId: alert.userId,
        pregnancyId: alert.pregnancyId,
        alertType: alert.alertType,
        severity: alert.severity,
        message: alert.message,
        recommendations: alert.recommendations,
        isResolved: true,
        createdAt: alert.createdAt,
        resolvedAt: DateTime.now(),
      );
      
      await db.update('risk_alerts', updated.toMap(), where: 'id = ?', whereArgs: [id]);
      return Result.success(updated, 'Risk alert resolved');
    } catch (e) {
      return Result.failure('Failed to resolve alert: ${e.toString()}');
    }
  }

  Future<Result<bool>> deleteRiskAlert(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('risk_alerts', where: 'id = ?', whereArgs: [id]);
      return Result.success(true, 'Risk alert deleted');
    } catch (e) {
      return Result.failure('Failed to delete risk alert: ${e.toString()}');
    }
  }
}
