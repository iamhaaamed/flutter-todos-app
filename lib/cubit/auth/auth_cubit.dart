// AuthCubit handles the authentication logic
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_app/cubit/auth/auth_state.dart';
import 'package:flutter_todos_app/services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    // Emit AuthLoading state to indicate that authentication process has started
    emit(AuthLoading());

    try {
      // Attempt to authenticate user
      bool success = await _authService.login(username, password);

      if (success) {
        // If authentication is successful, emit AuthSuccess state
        emit(AuthSuccess());
      } else {
        // If authentication fails, emit AuthFailure state with error message
        emit(const AuthFailure('Invalid username or password.'));
      }
    } catch (e) {
      // If an error occurs during authentication, emit AuthFailure state with error message
      emit(AuthFailure('An error occurred: $e'));
    }
  }
}
