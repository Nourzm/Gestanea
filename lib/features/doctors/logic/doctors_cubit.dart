import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/repositories/doctor_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorRepository _doctorRepository;
  final UserRepository _userRepository;

  DoctorsCubit({
    DoctorRepository? doctorRepository,
    UserRepository? userRepository,
  })  : _doctorRepository = doctorRepository ?? getIt<DoctorRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(DoctorsInitial()) {
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    emit(DoctorsLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(DoctorsError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final doctorsResult = await _doctorRepository.getAllDoctors();
    final favoritesResult = await _doctorRepository.getFavoriteDoctors(userResult.data!.id);

    if (doctorsResult.isSuccess) {
      emit(DoctorsLoaded(
        doctors: doctorsResult.data ?? [],
        favoriteDoctors: favoritesResult.data ?? [],
      ));
    } else {
      emit(DoctorsError(doctorsResult.message ?? 'Failed to load doctors'));
    }
  }

  Future<void> searchDoctors(String query) async {
    emit(DoctorsLoading());
    
    final result = await _doctorRepository.searchDoctors(query);
    final userResult = await _userRepository.getCurrentUser();
    final favoritesResult = await _doctorRepository.getFavoriteDoctors(userResult.data!.id);

    if (result.isSuccess) {
      emit(DoctorsLoaded(
        doctors: result.data ?? [],
        favoriteDoctors: favoritesResult.data ?? [],
      ));
    } else {
      emit(DoctorsError(result.message ?? 'Failed to search doctors'));
    }
  }

  Future<void> toggleFavorite(String doctorId) async {
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) return;

    await _doctorRepository.toggleFavorite(userResult.data!.id, doctorId);
    await loadDoctors();
  }
}
