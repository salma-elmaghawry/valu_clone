import 'package:no_wait/core/error_handling/app_exceptions.dart';
import 'package:no_wait/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:no_wait/features/auth/data/models/user_model.dart';

/// In-memory demo backend until the real API is ready.
/// Demo account: demo@nowait.com / 123456
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const _latency = Duration(milliseconds: 900);

  static final List<UserModel> _users = [
    const UserModel(id: 'u-1', name: 'Demo User', email: 'demo@nowait.com'),
  ];
  static final Map<String, String> _passwords = {'demo@nowait.com': '123456'};

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_latency);
    final normalized = email.trim().toLowerCase();
    final match = _users.where((u) => u.email == normalized);
    if (match.isEmpty || _passwords[normalized] != password) {
      throw InvalidCredentialsException();
    }
    return UserModel(
      id: match.first.id,
      name: match.first.name,
      email: match.first.email,
      token: 'demo-token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(_latency);
    final normalized = email.trim().toLowerCase();
    if (_users.any((u) => u.email == normalized)) {
      throw EmailAlreadyInUseException();
    }
    final user = UserModel(
      id: 'u-${_users.length + 1}',
      name: name,
      email: normalized,
      token: 'demo-token-${DateTime.now().millisecondsSinceEpoch}',
    );
    _users.add(user);
    _passwords[normalized] = password;
    return user;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(_latency);
    final normalized = email.trim().toLowerCase();
    if (!_users.any((u) => u.email == normalized)) {
      throw UserNotFoundException();
    }
  }
}
