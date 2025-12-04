import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/repositories/education_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  final EducationRepository _educationRepository;
  final UserRepository _userRepository;

  EducationCubit({
    EducationRepository? educationRepository,
    UserRepository? userRepository,
  })  : _educationRepository = educationRepository ?? getIt<EducationRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(EducationInitial()) {
    loadTips();
  }

  Future<void> loadTips() async {
    emit(EducationLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(EducationError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final tipsResult = await _educationRepository.getAllTips();
    final savedResult = await _educationRepository.getSavedTips(userResult.data!.id);

    if (tipsResult.isSuccess) {
      emit(EducationLoaded(
        tips: tipsResult.data ?? [],
        savedTips: savedResult.data ?? [],
      ));
    } else {
      emit(EducationError(tipsResult.message ?? 'Failed to load tips'));
    }
  }

  Future<void> toggleSave(String tipId) async {
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) return;

    await _educationRepository.toggleSave(userResult.data!.id, tipId);
    await loadTips();
  }

  Future<void> searchTips(String query) async {
    emit(EducationLoading());
    
    final result = await _educationRepository.searchTips(query);
    final userResult = await _userRepository.getCurrentUser();
    final savedResult = await _educationRepository.getSavedTips(userResult.data!.id);

    if (result.isSuccess) {
      emit(EducationLoaded(
        tips: result.data ?? [],
        savedTips: savedResult.data ?? [],
      ));
    } else {
      emit(EducationError(result.message ?? 'Failed to search tips'));
    }
  }
}
