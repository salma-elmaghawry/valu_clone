import 'package:dartz/dartz.dart';
import 'package:no_wait/core/error_handling/failures.dart';
import 'package:no_wait/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, Unit>> sendOtp({required String phone});

  Future<Either<Failure, Unit>> verifyOtp({
    required String phone,
    required String code,
  });

  Future<Either<Failure, AppUser>> register({
    required String phone,
    required String password,
  });

  Future<Either<Failure, String>> lookupPhoneByNationalId({
    required String nationalId,
  });

  Future<Either<Failure, Unit>> resetPassword({
    required String phone,
    required String newPassword,
  });

  Future<Either<Failure, Unit>> requestMobileNumberChange({
    required String nationalId,
    required String newPhone,
  });

  Future<Either<Failure, Unit>> changeMobileNumber({
    required String nationalId,
    required String newPhone,
  });

  /// True when a user session is cached locally (used by splash routing).
  bool get isLoggedIn;

  AppUser? get currentUser;

  Future<void> logout();
}
