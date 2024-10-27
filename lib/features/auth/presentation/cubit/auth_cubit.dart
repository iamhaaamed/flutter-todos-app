// AuthCubit handles the authentication logic
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_todos_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_todos_app/common/model/delayed_result.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

    try {
      bool success = await _authRepository.login(username, password);

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
