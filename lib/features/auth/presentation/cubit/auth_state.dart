import 'package:no_wait/core/bloc/base_bloc.dart';
import 'package:no_wait/core/error_handling/failures.dart';
import 'package:no_wait/features/auth/domain/entities/app_user.dart';

enum AuthAction { login, register, forgotPassword }

class AuthState extends BaseState {
  final AppUser? user;
  final Failure? failure;
  final AuthAction? action;

  const AuthState({
    super.status = Status.initial,
    super.message,
    this.user,
    this.failure,
    this.action,
  });

  AuthState copyWith({
    Status? status,
    String? message,
    AppUser? user,
    Failure? failure,
    AuthAction? action,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
      failure: failure ?? this.failure,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [status, message, user, failure, action];
}
