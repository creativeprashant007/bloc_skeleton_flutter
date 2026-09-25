import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart'
    show NavigationService;
import 'package:flutter/material.dart';

class INavigationService implements NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void back<T extends Object?>([T? result]) {
    return navigatorKey.currentState?.pop(result);
  }

  @override
  Future<T?>? navigateToNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  @override
  Future<T?>? navigateToOffAllNamed<T extends Object?>(
    String routeName,
    bool Function(Route p1) predicate, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  @override
  Future<T?>? navigateToOffNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  @override
  Future<T?>? navigateToNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
