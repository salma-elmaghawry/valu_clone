import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_wait/core/bloc/base_bloc.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_state.dart';
import 'package:no_wait/features/auth/repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> login({required String phone, required String password}) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.login));
    final result = await _repository.login(phone: phone, password: password);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.login,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          action: AuthAction.login,
        ),
      ),
    );
  }

  Future<void> sendOtp({required String phone}) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.sendOtp));
    final result = await _repository.sendOtp(phone: phone);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.sendOtp,
        ),
      ),
      (_) => emit(
        state.copyWith(status: Status.success, action: AuthAction.sendOtp),
      ),
    );
  }

  Future<void> verifyOtp({required String phone, required String code}) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.verifyOtp));
    final result = await _repository.verifyOtp(phone: phone, code: code);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.verifyOtp,
        ),
      ),
      (_) => emit(
        state.copyWith(status: Status.success, action: AuthAction.verifyOtp),
      ),
    );
  }

  Future<void> register({
    required String phone,
    required String password,
  }) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.register));
    final result = await _repository.register(phone: phone, password: password);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.register,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          action: AuthAction.register,
        ),
      ),
    );
  }

  Future<void> lookupNationalId({required String nationalId}) async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: AuthAction.lookupNationalId,
      ),
    );
    final result = await _repository.lookupPhoneByNationalId(
      nationalId: nationalId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.lookupNationalId,
        ),
      ),
      (phone) => emit(
        state.copyWith(
          status: Status.success,
          resolvedPhone: phone,
          action: AuthAction.lookupNationalId,
        ),
      ),
    );
  }

  Future<void> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    emit(
      state.copyWith(status: Status.loading, action: AuthAction.resetPassword),
    );
    final result = await _repository.resetPassword(
      phone: phone,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.resetPassword,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          action: AuthAction.resetPassword,
        ),
      ),
    );
  }

  Future<void> requestMobileNumberChange({
    required String nationalId,
    required String newPhone,
  }) async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: AuthAction.requestMobileChange,
      ),
    );
    final result = await _repository.requestMobileNumberChange(
      nationalId: nationalId,
      newPhone: newPhone,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.requestMobileChange,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          resolvedPhone: newPhone,
          action: AuthAction.requestMobileChange,
        ),
      ),
    );
  }

  Future<void> changeMobileNumber({
    required String nationalId,
    required String newPhone,
  }) async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: AuthAction.changeMobileNumber,
      ),
    );
    final result = await _repository.changeMobileNumber(
      nationalId: nationalId,
      newPhone: newPhone,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.changeMobileNumber,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          action: AuthAction.changeMobileNumber,
        ),
      ),
    );
  }
}
