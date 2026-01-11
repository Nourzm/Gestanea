// lib/features/dashboard/data/repositories/dashboard_repository.dart
import '../../domain/entities/pregnancy_dashboard.dart';
import '../../domain/entities/postpartum_dashboard.dart';

abstract class DashboardRepository {
  Future<PregnancyDashboard> getPregnancyDashboard(int userId);
  Future<PostpartumDashboard> getPostpartumDashboard(int userId);
  Future<bool> isUserPregnant(int userId);
  Future<bool> hasActiveBaby(int userId);
  
  // String-based methods for UUID user IDs
  Future<PregnancyDashboard> getPregnancyDashboardByStringId(String userId);
  Future<PostpartumDashboard> getPostpartumDashboardByStringId(String userId);
  Future<bool> isUserPregnantByStringId(String userId);
  Future<bool> hasActiveBabyByStringId(String userId);
  
  // Sync tips from remote (non-blocking, works offline)
  Future<void> syncTips();
  
  // Get tips with filtering
  Future<List<Map<String, dynamic>>> getTips({
    String? category,
    String? targetAudience,
    int? currentWeek,
    int? currentMonth,
    bool isPostpartum = false,
    int? postpartumWeek,
    int limit = 50,
  });
  
  // Get saved tip IDs for a user
  Future<List<String>> getSavedTipIds(String userId);
  
  // Save/unsave tip for user
  Future<void> saveTipForUser(String userId, String tipId);
  Future<void> removeSavedTipForUser(String userId, String tipId);
}
