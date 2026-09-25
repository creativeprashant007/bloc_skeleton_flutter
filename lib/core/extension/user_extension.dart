import 'package:flutter/widgets.dart';

import 'package:stock_control_master/features/auth/domain/entities/current_user.dart'
    show CurrentUser;
import 'package:stock_control_master/core/services/session_manager.dart'
    show SessionManager;

extension CurrentUserExtension on BuildContext {
  CurrentUser get currentUser {
    final user = SessionManager.instance.user;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return user;
  }

  bool get isManager {
    final role = SessionManager.instance.user?.role;
    return role == 'branch_manager';
  }

  String get userName {
    return SessionManager.instance.user?.name ?? '';
  }
}
