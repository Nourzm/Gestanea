import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../database/models/risk_alert_model.dart';

class RiskAlertsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Save risk assessment to Supabase
  Future<void> saveRiskAssessment({
    required String userId,
    required Map<String, dynamic> assessment,
  }) async {
    try {
      final riskLevel = (assessment['riskLevel']?.toString() ?? 'none').isEmpty ? 'none' : assessment['riskLevel'].toString();
      final primaryConcern = (assessment['primaryConcern']?.toString() ?? 'No significant concerns').isEmpty ? 'No significant concerns' : assessment['primaryConcern'].toString();
      final patterns = assessment['detectedPatterns'] as List<dynamic>? ?? [];
      final recommendations = assessment['recommendations'] as List<dynamic>? ?? [];
      final urgency = (assessment['urgency']?.toString() ?? 'Monitor').isEmpty ? 'Monitor' : assessment['urgency'].toString();
      final reasoning = (assessment['reasoning']?.toString() ?? 'No reasoning provided').isEmpty ? 'No reasoning provided' : assessment['reasoning'].toString();

      final now = DateTime.now();
      final id = '${now.millisecondsSinceEpoch}_${userId.substring(0, 8)}';

      // Combine all recommendations into one string
      final allRecommendations = recommendations.join('\n• ');

      final riskAlert = {
        'id': id,
        'user_id': userId,
        'alert_type': primaryConcern,
        'severity': riskLevel,
        'message': primaryConcern,
        'recommendation': allRecommendations,
        'is_resolved': 0,
        'detected_patterns': json.encode(patterns),
        'urgency': urgency,
        'reasoning': reasoning,
        'detected_at': now.toIso8601String(),
        'created_at': now.toIso8601String(),
      };

      // Insert into Supabase
      await _supabase.from('risk_alerts').insert(riskAlert);

      print('✅ Risk assessment saved to Supabase: $id');
    } catch (e) {
      print('❌ Error saving risk assessment: $e');
      rethrow;
    }
  }

  /// Get all risk alerts for user
  Future<List<RiskAlertModel>> getRiskAlerts(String userId) async {
    try {
      final response = await _supabase
          .from('risk_alerts')
          .select()
          .eq('user_id', userId)
          .order('detected_at', ascending: false);

      final List<RiskAlertModel> alerts = [];
      for (final item in response as List) {
        alerts.add(RiskAlertModel.fromMap(item));
      }

      print('✅ Fetched ${alerts.length} risk alerts from Supabase');
      return alerts;
    } catch (e) {
      print('❌ Error fetching risk alerts: $e');
      return [];
    }
  }

  /// Get unresolved risk alerts
  Future<List<RiskAlertModel>> getUnresolvedAlerts(String userId) async {
    try {
      final response = await _supabase
          .from('risk_alerts')
          .select()
          .eq('user_id', userId)
          .eq('is_resolved', 0)
          .order('detected_at', ascending: false);

      final List<RiskAlertModel> alerts = [];
      for (final item in response as List) {
        alerts.add(RiskAlertModel.fromMap(item));
      }

      print('✅ Fetched ${alerts.length} unresolved alerts');
      return alerts;
    } catch (e) {
      print('❌ Error fetching unresolved alerts: $e');
      return [];
    }
  }

  /// Mark alert as resolved
  Future<void> resolveAlert(String alertId) async {
    try {
      await _supabase
          .from('risk_alerts')
          .update({
            'is_resolved': 1,
            'resolved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', alertId);

      print('✅ Alert resolved: $alertId');
    } catch (e) {
      print('❌ Error resolving alert: $e');
      rethrow;
    }
  }

  /// Delete old resolved alerts (older than 30 days)
  Future<void> cleanupOldAlerts(String userId) async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      
      await _supabase
          .from('risk_alerts')
          .delete()
          .eq('user_id', userId)
          .eq('is_resolved', 1)
          .lt('resolved_at', thirtyDaysAgo.toIso8601String());

      print('✅ Old resolved alerts cleaned up');
    } catch (e) {
      print('❌ Error cleaning up alerts: $e');
    }
  }

  /// Get alert history (last 10 assessments)
  Future<List<RiskAlertModel>> getAlertHistory(String userId, {int limit = 10}) async {
    try {
      final response = await _supabase
          .from('risk_alerts')
          .select()
          .eq('user_id', userId)
          .order('detected_at', ascending: false)
          .limit(limit);

      final List<RiskAlertModel> alerts = [];
      for (final item in response as List) {
        alerts.add(RiskAlertModel.fromMap(item));
      }

      return alerts;
    } catch (e) {
      print('❌ Error fetching alert history: $e');
      return [];
    }
  }
}
