import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit({UserRepository? userRepository})
      : _userRepository = userRepository ?? getIt<UserRepository>(),
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    final result = await _userRepository.login(email, password);
    
    if (result.isSuccess && result.data != null) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.message ?? 'Login failed'));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    
    final result = await _userRepository.getCurrentUser();
    
    if (result.isSuccess && result.data != null) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthUnauthenticated());
  }
}
