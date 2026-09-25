import 'dart:convert';

import 'package:stock_control_master/core/configs/service/storage_service.dart';
import 'package:stock_control_master/features/auth/domain/entities/current_user.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  final StorageService _storage = StorageService();

  CurrentUser? _user;

  CurrentUser? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> init() async {
    await _storage.init();

    try {
      final userMap = await _storage.getUserData(); // ✅ Map

      if (userMap == null || userMap.isEmpty) {
        _user = null;
        return;
      }

      _user = CurrentUser.fromJson(userMap); // ✅ no jsonDecode
    } catch (e) {
      _user = null;
    }
  }

  Future<void> saveUser(CurrentUser user) async {
    _user = user;

    await _storage.storeUserData(jsonEncode(user.toJson()));
  }

  Future<void> clear() async {
    _user = null;
    await _storage.clearAll();
  }
}
