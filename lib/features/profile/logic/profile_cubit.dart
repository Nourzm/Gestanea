import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/models/user.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;

  ProfileCubit({UserRepository? userRepository})
      : _userRepository = userRepository ?? getIt<UserRepository>(),
        super(ProfileInitial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    
    final result = await _userRepository.getCurrentUser();
    
    if (result.isSuccess && result.data != null) {
      emit(ProfileLoaded(result.data!));
    } else {
      emit(ProfileError(result.message ?? 'Failed to load profile'));
    }
  }

  Future<void> updateProfile(User user) async {
    final result = await _userRepository.updateUser(user);
    
    if (result.isSuccess) {
      await loadProfile();
    } else {
      emit(ProfileError(result.message ?? 'Failed to update profile'));
    }
  }
}
