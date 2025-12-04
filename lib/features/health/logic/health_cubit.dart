import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/repositories/health_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final HealthRepository _healthRepository;
  final UserRepository _userRepository;

  HealthCubit({
    HealthRepository? healthRepository,
    UserRepository? userRepository,
  })  : _healthRepository = healthRepository ?? getIt<HealthRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(HealthInitial()) {
    loadHealthData();
  }

  Future<void> loadHealthData() async {
    emit(HealthLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(HealthError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final userId = userResult.data!.id;

    final vitalsResult = await _healthRepository.getVitals(userId);
    final symptomsResult = await _healthRepository.getSymptoms(userId);
    final moodsResult = await _healthRepository.getMoods(userId);
    final labResultsResult = await _healthRepository.getLabResults(userId);

    emit(HealthLoaded(
      vitals: vitalsResult.data ?? [],
      symptoms: symptomsResult.data ?? [],
      moods: moodsResult.data ?? [],
      labResults: labResultsResult.data ?? [],
    ));
  }
}
