import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_wait/core/bloc/base_bloc.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_state.dart';
import 'package:no_wait/features/auth/repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.login));
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        message: failure.message,
        failure: failure,
        action: AuthAction.login,
      )),
      (user) => emit(state.copyWith(
        status: Status.success,
        user: user,
        action: AuthAction.login,
      )),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.register));
    final result = await _repository.register(
      name: name,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        message: failure.message,
        failure: failure,
        action: AuthAction.register,
      )),
      (user) => emit(state.copyWith(
        status: Status.success,
        user: user,
        action: AuthAction.register,
      )),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    emit(state.copyWith(
      status: Status.loading,
      action: AuthAction.forgotPassword,
    ));
    final result = await _repository.forgotPassword(email: email);
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        message: failure.message,
        failure: failure,
        action: AuthAction.forgotPassword,
      )),
      (_) => emit(state.copyWith(
        status: Status.success,
        action: AuthAction.forgotPassword,
      )),
    );
  }
}
