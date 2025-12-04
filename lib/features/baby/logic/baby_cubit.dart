import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/models/baby.dart';
import 'package:gestanea/core/repositories/baby_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'baby_state.dart';

class BabyCubit extends Cubit<BabyState> {
  final BabyRepository _babyRepository;
  final UserRepository _userRepository;

  BabyCubit({
    BabyRepository? babyRepository,
    UserRepository? userRepository,
  })  : _babyRepository = babyRepository ?? getIt<BabyRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(BabyInitial()) {
    loadBabies();
  }

  Future<void> loadBabies() async {
    emit(BabyLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(BabyError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final result = await _babyRepository.getUserBabies(userResult.data!.id);
    
    if (result.isSuccess) {
      emit(BabyLoaded(result.data ?? []));
    } else {
      emit(BabyError(result.message ?? 'Failed to load babies'));
    }
  }

  Future<void> addBaby(Baby baby) async {
    final result = await _babyRepository.createBaby(baby);
    
    if (result.isSuccess) {
      emit(BabyOperationSuccess(result.message ?? 'Baby added successfully'));
      await loadBabies();
    } else {
      emit(BabyError(result.message ?? 'Failed to add baby'));
    }
  }

  Future<void> updateBaby(Baby baby) async {
    final result = await _babyRepository.updateBaby(baby);
    
    if (result.isSuccess) {
      emit(BabyOperationSuccess(result.message ?? 'Baby updated successfully'));
      await loadBabies();
    } else {
      emit(BabyError(result.message ?? 'Failed to update baby'));
    }
  }

  Future<void> deleteBaby(String id) async {
    final result = await _babyRepository.deleteBaby(id);
    
    if (result.isSuccess) {
      emit(BabyOperationSuccess(result.message ?? 'Baby deleted successfully'));
      await loadBabies();
    } else {
      emit(BabyError(result.message ?? 'Failed to delete baby'));
    }
  }
}
