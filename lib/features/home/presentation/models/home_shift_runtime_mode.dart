enum HomeShiftRuntimeMode {
  none,
  scheduledReady,
  scheduledRunning,
  scheduledOnBreak,
  openReady,
  openRunning,
  openOnBreak,
}

extension HomeShiftRuntimeModeX on HomeShiftRuntimeMode {
  static HomeShiftRuntimeMode fromApi(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'scheduled_not_started':
        return HomeShiftRuntimeMode.scheduledReady;
      case 'scheduled_running':
        return HomeShiftRuntimeMode.scheduledRunning;
      case 'scheduled_on_break':
        return HomeShiftRuntimeMode.scheduledOnBreak;
      case 'open_shift_ready':
        return HomeShiftRuntimeMode.openReady;
      case 'open_shift_running':
        return HomeShiftRuntimeMode.openRunning;
      case 'open_shift_on_break':
        return HomeShiftRuntimeMode.openOnBreak;
      default:
        return HomeShiftRuntimeMode.none;
    }
  }

  bool get isScheduled =>
      this == HomeShiftRuntimeMode.scheduledReady ||
      this == HomeShiftRuntimeMode.scheduledRunning ||
      this == HomeShiftRuntimeMode.scheduledOnBreak;

  bool get isOpen =>
      this == HomeShiftRuntimeMode.openReady ||
      this == HomeShiftRuntimeMode.openRunning ||
      this == HomeShiftRuntimeMode.openOnBreak;

  bool get isRunning =>
      this == HomeShiftRuntimeMode.scheduledRunning ||
      this == HomeShiftRuntimeMode.openRunning;

  bool get isOnBreak =>
      this == HomeShiftRuntimeMode.scheduledOnBreak ||
      this == HomeShiftRuntimeMode.openOnBreak;

  bool get canShowShiftCard => this != HomeShiftRuntimeMode.none;
}
