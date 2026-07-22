import 'package:no_wait/core/error_handling/app_exceptions.dart';
import 'package:no_wait/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:no_wait/features/auth/data/models/user_model.dart';

/// In-memory demo backend until the real API is ready.
/// Demo account: 01019222298 / NoWait@2026 (national ID 29901011234567)
/// Demo OTP: 123456
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const _latency = Duration(milliseconds: 900);
  static const demoOtp = '123456';

  static final List<UserModel> _users = [
    const UserModel(
      id: 'u-1',
      phone: '01019222298',
      nationalId: '29901011234567',
    ),
  ];
  static final Map<String, String> _passwords = {'01019222298': 'NoWait@2026'};
  static final Map<String, String> _pendingOtps = {};

  @override
  Future<UserModel> login({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(_latency);
    final match = _users.where((u) => u.phone == phone);
    if (match.isEmpty || _passwords[phone] != password) {
      throw InvalidCredentialsException();
    }
    return UserModel(
      id: match.first.id,
      phone: phone,
      nationalId: match.first.nationalId,
      token: 'demo-token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> sendOtp({required String phone}) async {
    await Future.delayed(_latency);
    _pendingOtps[phone] = demoOtp;
  }

  @override
  Future<void> verifyOtp({required String phone, required String code}) async {
    await Future.delayed(_latency ~/ 2);
    if (_pendingOtps[phone] != code) {
      throw InvalidOtpException();
    }
  }

  @override
  Future<UserModel> register({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(_latency);
    if (_users.any((u) => u.phone == phone)) {
      throw PhoneAlreadyInUseException();
    }
    final user = UserModel(
      id: 'u-${_users.length + 1}',
      phone: phone,
      token: 'demo-token-${DateTime.now().millisecondsSinceEpoch}',
    );
    _users.add(user);
    _passwords[phone] = password;
    _pendingOtps.remove(phone);
    return user;
  }

  @override
  Future<String> lookupPhoneByNationalId({required String nationalId}) async {
    await Future.delayed(_latency);
    final match = _users.where((u) => u.nationalId == nationalId);
    if (match.isEmpty) throw UserNotFoundException();
    return match.first.phone;
  }

  @override
  Future<void> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    await Future.delayed(_latency);
    if (!_users.any((u) => u.phone == phone)) throw UserNotFoundException();
    _passwords[phone] = newPassword;
  }

  @override
  Future<void> requestMobileNumberChange({
    required String nationalId,
    required String newPhone,
  }) async {
    await Future.delayed(_latency);
    if (!_users.any((u) => u.nationalId == nationalId)) {
      throw UserNotFoundException();
    }
    if (_users.any((u) => u.phone == newPhone)) {
      throw PhoneAlreadyInUseException();
    }
    _pendingOtps[newPhone] = demoOtp;
  }

  @override
  Future<void> changeMobileNumber({
    required String nationalId,
    required String newPhone,
  }) async {
    await Future.delayed(_latency);
    final index = _users.indexWhere((u) => u.nationalId == nationalId);
    if (index == -1) throw UserNotFoundException();
    final old = _users[index];
    _users[index] = UserModel(
      id: old.id,
      phone: newPhone,
      nationalId: old.nationalId,
      token: old.token,
    );
    _passwords[newPhone] = _passwords.remove(old.phone) ?? '';
    _pendingOtps.remove(newPhone);
  }
}
