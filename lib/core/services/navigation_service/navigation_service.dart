import 'package:flutter/material.dart';

abstract class NavigationService {
  Future<T?>? navigateToNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  });

  Future<T?>? navigateToOffNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  });

  Future<T?>? navigateToOffAllNamed<T extends Object?>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  });

  Future<T?>? navigateToNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
  });

  void back<T extends Object?>([T? result]);
}
