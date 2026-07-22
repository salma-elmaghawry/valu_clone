import 'package:no_wait/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String phone, required String password});

  /// Sends (or resends) a one-time code to [phone].
  Future<void> sendOtp({required String phone});

  Future<void> verifyOtp({required String phone, required String code});

  /// Finalizes registration once the mobile number has been OTP-verified.
  Future<UserModel> register({required String phone, required String password});

  /// Looks up the mobile number tied to a national ID, for the
  /// "forgot password" flow. Throws [UserNotFoundException] if unknown.
  Future<String> lookupPhoneByNationalId({required String nationalId});

  Future<void> resetPassword({
    required String phone,
    required String newPassword,
  });

  /// Verifies the national ID belongs to an existing account and that
  /// [newPhone] isn't already taken, then sends an OTP to [newPhone].
  Future<void> requestMobileNumberChange({
    required String nationalId,
    required String newPhone,
  });

  /// Finalizes a mobile number change once [newPhone] has been OTP-verified.
  Future<void> changeMobileNumber({
    required String nationalId,
    required String newPhone,
  });
}
