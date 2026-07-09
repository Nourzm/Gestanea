import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import '../../domain/usecases/get_pregnancy_dashboard_usecase.dart';
import '../../domain/usecases/get_postpartum_dashboard_usecase.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetPregnancyDashboardUseCase _getPregnancyDashboardUseCase;
  final GetPostpartumDashboardUseCase _getPostpartumDashboardUseCase;
  final DashboardRepository _repository;

  DashboardCubit({
    GetPregnancyDashboardUseCase? getPregnancyDashboardUseCase,
    GetPostpartumDashboardUseCase? getPostpartumDashboardUseCase,
    DashboardRepository? repository,
  }) : _getPregnancyDashboardUseCase =
           getPregnancyDashboardUseCase ?? GetPregnancyDashboardUseCase(),
       _getPostpartumDashboardUseCase =
           getPostpartumDashboardUseCase ?? GetPostpartumDashboardUseCase(),
       _repository = repository ?? DashboardRepositoryImpl(),
       super(DashboardInitial());

  Future<void> loadDashboard(int userId) async {
    emit(DashboardLoading());
    try {
      final isPregnant = await _repository.isUserPregnant(userId);
      if (isPregnant) {
        await loadPregnancyDashboard(userId);
      } else {
        // Check if user has a baby (postpartum mode)
        final hasBaby = await _repository.hasActiveBaby(userId);
        if (hasBaby) {
          await loadPostpartumDashboard(userId);
        } else {
          // No pregnancy and no baby - default to pregnancy dashboard with default values
          await loadPregnancyDashboard(userId);
        }
      }
    } catch (e) {
      // On error, emit pregnancy dashboard with default values
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> loadPregnancyDashboard(int userId) async {
    emit(DashboardLoading());
    try {
      final dashboard = await _getPregnancyDashboardUseCase.call(userId);
      emit(PregnancyDashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> loadPostpartumDashboard(int userId) async {
    emit(DashboardLoading());
    try {
      final dashboard = await _getPostpartumDashboardUseCase.call(userId);
      emit(PostpartumDashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  /// Load dashboard using string user ID (for UUID-based user IDs)
  Future<void> loadDashboardByStringId(String userIdString) async {
    emit(DashboardLoading());
    try {
      final isPregnant = await _repository.isUserPregnantByStringId(
        userIdString,
      );
      if (isPregnant) {
        final dashboard = await _getPregnancyDashboardUseCase.callByStringId(
          userIdString,
        );
        emit(PregnancyDashboardLoaded(dashboard));
      } else {
        final hasBaby = await _repository.hasActiveBabyByStringId(userIdString);
        if (hasBaby) {
          final dashboard = await _getPostpartumDashboardUseCase.callByStringId(
            userIdString,
          );
          emit(PostpartumDashboardLoaded(dashboard));
        } else {
          final dashboard = await _getPregnancyDashboardUseCase.callByStringId(
            userIdString,
          );
          emit(PregnancyDashboardLoaded(dashboard));
        }
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> refreshDashboard(int userId) async {
    await loadDashboard(userId);
  }

  void reset() {
    emit(DashboardInitial());
  }
}
