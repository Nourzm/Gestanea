import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/models/pregnancy.dart';
import 'package:gestanea/core/models/kick_count.dart';
import 'package:gestanea/core/repositories/pregnancy_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'pregnancy_state.dart';

class PregnancyCubit extends Cubit<PregnancyState> {
  final PregnancyRepository _pregnancyRepository;
  final UserRepository _userRepository;

  PregnancyCubit({
    PregnancyRepository? pregnancyRepository,
    UserRepository? userRepository,
  })  : _pregnancyRepository = pregnancyRepository ?? getIt<PregnancyRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(PregnancyInitial()) {
    loadPregnancy();
  }

  Future<void> loadPregnancy() async {
    emit(PregnancyLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(PregnancyError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final pregnancyResult = await _pregnancyRepository.getActivePregnancy(userResult.data!.id);
    
    if (pregnancyResult.isFailure) {
      emit(PregnancyError(pregnancyResult.message ?? 'Failed to load pregnancy'));
      return;
    }

    final pregnancy = pregnancyResult.data;
    List<KickCount> kickCounts = [];

    if (pregnancy != null) {
      final kickResult = await _pregnancyRepository.getKickCounts(pregnancy.id);
      if (kickResult.isSuccess) {
        kickCounts = kickResult.data ?? [];
      }
    }

    emit(PregnancyLoaded(activePregnancy: pregnancy, kickCounts: kickCounts));
  }

  Future<void> addKickCount(KickCount kickCount) async {
    final result = await _pregnancyRepository.addKickCount(kickCount);
    
    if (result.isSuccess) {
      await loadPregnancy();
    } else {
      emit(PregnancyError(result.message ?? 'Failed to add kick count'));
    }
  }
}
