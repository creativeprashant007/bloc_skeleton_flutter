enum HomeActionType {
  none,
  startShift,
  endShift,
  startBreak,
  endBreak,
  startOpenShift,
  endOpenShift,
  startOpenBreak,
  endOpenBreak,
}

extension HomeActionTypeX on HomeActionType {
  static HomeActionType fromApi(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'start_shift':
        return HomeActionType.startShift;
      case 'end_shift':
        return HomeActionType.endShift;
      case 'start_break':
        return HomeActionType.startBreak;
      case 'end_break':
        return HomeActionType.endBreak;
      case 'start_open_shift':
        return HomeActionType.startOpenShift;
      case 'end_open_shift':
        return HomeActionType.endOpenShift;
      case 'start_open_break':
        return HomeActionType.startOpenBreak;
      case 'end_open_break':
        return HomeActionType.endOpenBreak;
      default:
        return HomeActionType.none;
    }
  }

  String get label {
    switch (this) {
      case HomeActionType.startShift:
        return 'Start Shift';
      case HomeActionType.endShift:
        return 'End Shift';
      case HomeActionType.startBreak:
        return 'Start Break';
      case HomeActionType.endBreak:
        return 'Resume Work';
      case HomeActionType.startOpenShift:
        return 'Start Open Shift';
      case HomeActionType.endOpenShift:
        return 'End Shift';
      case HomeActionType.startOpenBreak:
        return 'Start Break';
      case HomeActionType.endOpenBreak:
        return 'Resume Work';
      case HomeActionType.none:
        return '';
    }
  }

  bool get isNone => this == HomeActionType.none;
}
