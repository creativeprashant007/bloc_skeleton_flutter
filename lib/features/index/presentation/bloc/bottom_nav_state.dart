class BottomNavState {
  final int selectedIndex;
  final int messageCount;
  final int pendingTimesheetCount;

  const BottomNavState({
    required this.selectedIndex,
    required this.messageCount,
    required this.pendingTimesheetCount,
  });

  BottomNavState copyWith({
    int? selectedIndex,
    int? messageCount,
    int? pendingTimesheetCount,
  }) {
    return BottomNavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      messageCount: messageCount ?? this.messageCount,
      pendingTimesheetCount:
          pendingTimesheetCount ?? this.pendingTimesheetCount,
    );
  }
}
