import 'package:dartz/dartz.dart';
import 'package:no_wait/core/error_handling/error_mapper.dart';
import 'package:no_wait/core/error_handling/failures.dart';
import 'package:no_wait/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:no_wait/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:no_wait/features/auth/domain/entities/app_user.dart';
import 'package:no_wait/features/auth/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, AppUser>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        phone: phone,
        password: password,
      );
      await _localDataSource.cacheUser(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendOtp({required String phone}) async {
    try {
      await _remoteDataSource.sendOtp(phone: phone);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(phone: phone, code: code);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String phone,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.register(
        phone: phone,
        password: password,
      );
      await _localDataSource.cacheUser(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, String>> lookupPhoneByNationalId({
    required String nationalId,
  }) async {
    try {
      final phone = await _remoteDataSource.lookupPhoneByNationalId(
        nationalId: nationalId,
      );
      return Right(phone);
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        phone: phone,
        newPassword: newPassword,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestMobileNumberChange({
    required String nationalId,
    required String newPhone,
  }) async {
    try {
      await _remoteDataSource.requestMobileNumberChange(
        nationalId: nationalId,
        newPhone: newPhone,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> changeMobileNumber({
    required String nationalId,
    required String newPhone,
  }) async {
    try {
      await _remoteDataSource.changeMobileNumber(
        nationalId: nationalId,
        newPhone: newPhone,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  bool get isLoggedIn => _localDataSource.getCachedUser() != null;

  @override
  AppUser? get currentUser => _localDataSource.getCachedUser()?.toEntity();

  @override
  Future<void> logout() => _localDataSource.clearUser();
}
