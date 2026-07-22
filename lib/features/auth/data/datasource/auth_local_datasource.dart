import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:no_wait/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _userKey = 'cached_user';

  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  UserModel? getCachedUser() {
    final raw = _prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Cached payload doesn't match the current schema (e.g. left over
      // from before a data-model change) — drop it instead of crashing.
      unawaited(clearUser());
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
}
