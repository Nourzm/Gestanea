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
}
