import 'package:stock_control_master/features/home/domain/entities/team_mates/today_team_mates.dart'
    show TodayTeammate;
import 'package:stock_control_master/features/home/domain/entities/today_shift_data.dart';
import 'home_action_type.dart';
import 'home_open_work_area_ui_model.dart';
import 'home_shift_runtime_mode.dart';
import 'shift_ui_model.dart';

class HomeUiMappedResult {
  final ShiftUiModel? todayShift;
  final ShiftUiModel? nextShift;
  final ActiveSessionEntity? activeSession;
  final ShiftActionsEntity? actions;
  final HomeShiftRuntimeMode runtimeMode;
  final HomeActionType primaryAction;
  final HomeActionType secondaryAction;
  final List<HomeOpenWorkAreaUiModel> openShiftWorkAreas;
  final List<ShiftUiModel> availableShifts;
  final List<TodayTeammate> teammates;

  const HomeUiMappedResult({
    required this.todayShift,
    required this.nextShift,
    required this.activeSession,
    required this.actions,
    required this.runtimeMode,
    required this.primaryAction,
    required this.secondaryAction,
    required this.openShiftWorkAreas,
    required this.availableShifts,
    required this.teammates,
  });
}
