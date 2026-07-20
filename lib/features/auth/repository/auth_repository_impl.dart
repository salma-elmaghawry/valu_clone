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
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _localDataSource.cacheUser(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      await _localDataSource.cacheUser(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
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
