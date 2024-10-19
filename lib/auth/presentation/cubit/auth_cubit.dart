// AuthCubit handles the authentication logic
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_app/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_todos_app/auth/data/service/auth_service.dart';
import 'package:flutter_todos_app/common/model/delayed_result.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(const AuthState());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

    try {
      bool success = await _authService.login(username, password);

      if (success) {
        emit(state.copyWith(
          isAuthenticated: true,
          loadingResult: const DelayedResult.idle(),
        ));
      } else {
        emit(state.copyWith(
          loadingResult: DelayedResult.fromError(
              Exception('Invalid username or password')),
        ));
      }
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }
}
