import 'package:dartz/dartz.dart';
import 'package:no_wait/core/error_handling/failures.dart';
import 'package:no_wait/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  /// True when a user session is cached locally (used by splash routing).
  bool get isLoggedIn;

  AppUser? get currentUser;

  Future<void> logout();
}
