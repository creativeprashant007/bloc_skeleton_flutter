import 'package:stock_control_master/features/home/domain/entities/today_shift_item.dart';

class ActiveSessionEntity {
  final bool exists;
  final String sessionType;
  final int attendanceId;
  final int shiftId;
  final int workAreaId;
  final String workAreaName;
  final int branchId;
  final String branchName;
  final String startedAt;
  final String endedAt;
  final bool isOnBreak;
  final String breakType;
  final String breakStartedAt;
  final String breakEndedAt;
  final int breakMinutes;
  final int workedMinutes;

  const ActiveSessionEntity({
    required this.exists,
    required this.sessionType,
    required this.attendanceId,
    required this.shiftId,
    required this.workAreaId,
    required this.workAreaName,
    required this.branchId,
    required this.branchName,
    required this.startedAt,
    required this.endedAt,
    required this.isOnBreak,
    required this.breakType,
    required this.breakStartedAt,
    required this.breakEndedAt,
    required this.breakMinutes,
    required this.workedMinutes,
  });

  factory ActiveSessionEntity.fromJson(Map<String, dynamic> json) {
    return ActiveSessionEntity(
      exists: json['exists'] ?? false,
      sessionType: json['session_type'] ?? '',
      attendanceId: json['attendance_id'] == ""
          ? 0
          : int.parse(json['attendance_id'].toString()),
      shiftId: json['shift_id'] == "" ? 0 : json['shift_id'],
      workAreaId: json['work_area_id'] == "" ? 0 : json['work_area_id'],
      workAreaName: json['work_area_name'] ?? '',
      branchId: json['branch_id'] == "" ? 0 : json['branch_id'],
      branchName: json['branch_name'] ?? '',
      startedAt: json['started_at'] ?? '',
      endedAt: json['ended_at'] ?? '',
      isOnBreak: json['is_on_break'] ?? false,
      breakType: json['break_type'] ?? '',
      breakStartedAt: json['break_started_at'] ?? '',
      breakEndedAt: json['break_ended_at'] ?? '',
      breakMinutes: (json['break_minutes'] ?? 0) as int,
      workedMinutes: (json['worked_minutes'] is int)
          ? json['worked_minutes'] as int
          : (((json['worked_minutes'] ?? 0) as num).round()),
    );
  }
}

class ShiftActionsEntity {
  final bool canStartScheduledShift;
  final bool canEndScheduledShift;
  final bool canStartScheduledBreak;
  final bool canEndScheduledBreak;
  final bool canStartOpenShift;
  final bool canEndOpenShift;
  final bool canStartOpenBreak;
  final bool canEndOpenBreak;

  const ShiftActionsEntity({
    required this.canStartScheduledShift,
    required this.canEndScheduledShift,
    required this.canStartScheduledBreak,
    required this.canEndScheduledBreak,
    required this.canStartOpenShift,
    required this.canEndOpenShift,
    required this.canStartOpenBreak,
    required this.canEndOpenBreak,
  });

  factory ShiftActionsEntity.fromJson(Map<String, dynamic> json) {
    return ShiftActionsEntity(
      canStartScheduledShift: json['can_start_scheduled_shift'] ?? false,
      canEndScheduledShift: json['can_end_scheduled_shift'] ?? false,
      canStartScheduledBreak: json['can_start_scheduled_break'] ?? false,
      canEndScheduledBreak: json['can_end_scheduled_break'] ?? false,
      canStartOpenShift: json['can_start_open_shift'] ?? false,
      canEndOpenShift: json['can_end_open_shift'] ?? false,
      canStartOpenBreak: json['can_start_open_break'] ?? false,
      canEndOpenBreak: json['can_end_open_break'] ?? false,
    );
  }
}

class ShiftUiStateEntity {
  final String homeMode;
  final String primaryAction;
  final String secondaryAction;
  final String displayTitle;
  final String displayLocation;

  const ShiftUiStateEntity({
    required this.homeMode,
    required this.primaryAction,
    required this.secondaryAction,
    required this.displayTitle,
    required this.displayLocation,
  });

  factory ShiftUiStateEntity.fromJson(Map<String, dynamic> json) {
    return ShiftUiStateEntity(
      homeMode: json['home_mode'] ?? 'none',
      primaryAction: json['primary_action'] ?? '',
      secondaryAction: json['secondary_action'] ?? '',
      displayTitle: json['display_title'] ?? '',
      displayLocation: json['display_location'] ?? '',
    );
  }
}

class TodayShiftData {
  final TodayShiftItem? todayShift;
  final ActiveSessionEntity? activeSession;
  final ShiftActionsEntity actions;
  final ShiftUiStateEntity uiState;
  final TodayShiftItem? nextShift;

  const TodayShiftData({
    required this.todayShift,
    required this.activeSession,
    required this.actions,
    required this.uiState,
    required this.nextShift,
  });

  factory TodayShiftData.fromJson(Map<String, dynamic> json) {
    final todayRaw = json['today_shift'];
    final activeRaw = json['active_session'];
    final nextRaw = json['next_shift'];

    return TodayShiftData(
      todayShift: todayRaw is Map<String, dynamic> && todayRaw.isNotEmpty
          ? TodayShiftItem.fromJson(todayRaw)
          : null,
      activeSession: activeRaw is Map<String, dynamic> && activeRaw.isNotEmpty
          ? ActiveSessionEntity.fromJson(activeRaw)
          : null,
      actions: ShiftActionsEntity.fromJson(
        (json['actions'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      uiState: ShiftUiStateEntity.fromJson(
        (json['ui_state'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      nextShift: nextRaw is Map<String, dynamic> && nextRaw.isNotEmpty
          ? TodayShiftItem.fromJson(nextRaw)
          : null,
    );
  }
}
