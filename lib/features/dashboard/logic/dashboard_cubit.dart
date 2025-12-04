import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/repositories/pregnancy_repository.dart';
import 'package:gestanea/core/repositories/baby_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final UserRepository _userRepository;
  final PregnancyRepository _pregnancyRepository;
  final BabyRepository _babyRepository;

  DashboardCubit({
    UserRepository? userRepository,
    PregnancyRepository? pregnancyRepository,
    BabyRepository? babyRepository,
  })  : _userRepository = userRepository ?? getIt<UserRepository>(),
        _pregnancyRepository = pregnancyRepository ?? getIt<PregnancyRepository>(),
        _babyRepository = babyRepository ?? getIt<BabyRepository>(),
        super(DashboardInitial()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(DashboardError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final user = userResult.data!;
    final pregnancyResult = await _pregnancyRepository.getActivePregnancy(user.id);
    final babiesResult = await _babyRepository.getUserBabies(user.id);

    emit(DashboardLoaded(
      user: user,
      activePregnancy: pregnancyResult.data,
      babies: babiesResult.data ?? [],
    ));
  }
}
