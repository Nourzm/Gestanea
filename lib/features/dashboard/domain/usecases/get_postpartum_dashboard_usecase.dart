// lib/features/dashboard/domain/usecases/get_postpartum_dashboard_usecase.dart
import '../entities/postpartum_dashboard.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

class GetPostpartumDashboardUseCase {
  final DashboardRepository _repository;

  GetPostpartumDashboardUseCase({DashboardRepository? repository})
    : _repository = repository ?? DashboardRepositoryImpl();

  Future<PostpartumDashboard> call(int userId) async {
    return await _repository.getPostpartumDashboard(userId);
  }

  Future<PostpartumDashboard> callByStringId(String userId) async {
    return await _repository.getPostpartumDashboardByStringId(userId);
  }
}
