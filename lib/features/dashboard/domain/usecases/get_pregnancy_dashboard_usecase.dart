// lib/features/dashboard/domain/usecases/get_pregnancy_dashboard_usecase.dart
import '../entities/pregnancy_dashboard.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

class GetPregnancyDashboardUseCase {
  final DashboardRepository _repository;

  GetPregnancyDashboardUseCase({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepositoryImpl();

  Future<PregnancyDashboard> call(int userId) async {
    return await _repository.getPregnancyDashboard(userId);
  }

  Future<PregnancyDashboard> callByStringId(String userId) async {
    return await _repository.getPregnancyDashboardByStringId(userId);
  }
}