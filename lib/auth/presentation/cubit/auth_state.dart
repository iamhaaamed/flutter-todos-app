import 'package:equatable/equatable.dart';
import 'package:flutter_todos_app/common/model/delayed_result.dart';

class AuthState extends Equatable {
  final DelayedResult<void> loadingResult;
  final bool isAuthenticated;

  const AuthState({
    this.loadingResult = const DelayedResult.idle(),
    this.isAuthenticated = false,
  });

  @override
  List<Object?> get props => [loadingResult, isAuthenticated];

  AuthState copyWith({
    DelayedResult<void>? loadingResult,
    bool? isAuthenticated,
  }) {
    return AuthState(
      loadingResult: loadingResult ?? this.loadingResult,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
