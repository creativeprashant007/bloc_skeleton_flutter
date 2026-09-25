import 'package:flutter/widgets.dart' show BuildContext;

abstract class HomeEvent {
  const HomeEvent();
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

class HomePrimaryActionPressed extends HomeEvent {
  final String? breakId;
  final int? workAreaId;
  final String? workAreaName;
  final String? comment;

  const HomePrimaryActionPressed({
    this.breakId,
    this.workAreaId,
    this.workAreaName,
    this.comment,
  });
}

class HomeSecondaryActionPressed extends HomeEvent {
  final String? comment;

  const HomeSecondaryActionPressed({this.comment});
}

class HomeToggleAvailableShiftsPressed extends HomeEvent {
  const HomeToggleAvailableShiftsPressed();
}

class HomeProfileTapped extends HomeEvent {
  const HomeProfileTapped();
}

class HomeUpcomingShiftTapped extends HomeEvent {
  final BuildContext context;

  const HomeUpcomingShiftTapped(this.context);
}

class HomeWorkingTodayTapped extends HomeEvent {
  final BuildContext context;

  const HomeWorkingTodayTapped(this.context);
}

class HomeNavTapped extends HomeEvent {
  final BuildContext? context;
  final int index;

  const HomeNavTapped({required this.context, this.index = 0});
}

class HomeChangeLocation extends HomeEvent {
  final int branchId;
  final BuildContext context;
  final bool markPromptHandled;

  const HomeChangeLocation({
    required this.branchId,
    required this.context,
    this.markPromptHandled = false,
  });
}

class HomeLocationPromptHandled extends HomeEvent {
  final int branchId;

  const HomeLocationPromptHandled({required this.branchId});
}

class HomeLocationPromptClosed extends HomeEvent {
  const HomeLocationPromptClosed();
}

class AvailableTapped extends HomeEvent {
  const AvailableTapped();
}
