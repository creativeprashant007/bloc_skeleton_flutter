abstract class BottomNavEvent {
  const BottomNavEvent();
}

class BottomNavTabChanged extends BottomNavEvent {
  final int index;

  const BottomNavTabChanged(this.index);
}

class LoadNotificationCountEvent extends BottomNavEvent {}

class LoadPendingTimesheetCountEvent extends BottomNavEvent {}

class RefreshBottomNavCountsEvent extends BottomNavEvent {}

class BottomNavPendingTimesheetCountChanged extends BottomNavEvent {
  final int count;

  const BottomNavPendingTimesheetCountChanged(this.count);
}
