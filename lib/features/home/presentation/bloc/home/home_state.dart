import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart';
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_team_mates.dart';
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_shift.dart';

import 'package:stock_control_master/features/home/domain/entities/today_shift_data.dart';
import 'package:stock_control_master/features/home/presentation/models/home_action_type.dart'
    show HomeActionType;
import 'package:stock_control_master/features/home/presentation/models/home_open_work_area_ui_model.dart'
    show HomeOpenWorkAreaUiModel;
import 'package:stock_control_master/features/home/presentation/models/home_shift_runtime_mode.dart'
    show HomeShiftRuntimeMode;
import 'package:stock_control_master/features/home/presentation/models/shift_ui_model.dart'
    show ShiftUiModel;

class HomeState {
  final bool isLoading;
  final bool isActionLoading;
  final bool isPrimaryLoading;
  final bool isUpcomingLoading;
  final bool isTeammatesLoading;
  final bool isLocationsLoading;
  final bool isWorkAreasLoading;
  final bool shouldShowLocationPrompt;
  final bool showAvailableShifts;

  final ShiftUiModel? todayShift;
  final ShiftUiModel? nextShift;

  final ActiveSessionEntity? activeSession;
  final ShiftActionsEntity? actions;

  final HomeShiftRuntimeMode runtimeMode;
  final HomeActionType primaryAction;
  final HomeActionType secondaryAction;

  final List<HomeOpenWorkAreaUiModel> openShiftWorkAreas;
  final List<AvailableBranch> availableLocations;
  final List<ShiftUiModel> availableShifts;
  final List<TodayTeammate> teammates;
  final List<UpcomingShift> upcomingShift;

  final String? infoMessage;

  const HomeState({
    required this.isLoading,
    required this.isActionLoading,
    required this.isPrimaryLoading,
    required this.isUpcomingLoading,
    required this.isTeammatesLoading,
    required this.isLocationsLoading,
    required this.isWorkAreasLoading,
    required this.shouldShowLocationPrompt,
    required this.showAvailableShifts,
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
    required this.infoMessage,
    required this.upcomingShift,
    required this.availableLocations,
  });

  factory HomeState.initial() {
    return const HomeState(
      isLoading: false,
      isActionLoading: false,
      isPrimaryLoading: false,
      isUpcomingLoading: false,
      isTeammatesLoading: false,
      isLocationsLoading: false,
      isWorkAreasLoading: false,
      shouldShowLocationPrompt: false,
      showAvailableShifts: false,
      todayShift: null,
      nextShift: null,
      activeSession: null,
      actions: null,
      runtimeMode: HomeShiftRuntimeMode.none,
      primaryAction: HomeActionType.none,
      secondaryAction: HomeActionType.none,
      openShiftWorkAreas: [],
      availableShifts: [],
      teammates: [],
      availableLocations: [],
      upcomingShift: [],
      infoMessage: null,
    );
  }

  HomeState copyWith({
    bool? isLoading,
    bool? isActionLoading,
    bool? isPrimaryLoading,
    bool? isUpcomingLoading,
    bool? isTeammatesLoading,
    bool? isLocationsLoading,
    bool? isWorkAreasLoading,
    bool? shouldShowLocationPrompt,
    bool? showAvailableShifts,
    ShiftUiModel? todayShift,
    bool clearTodayShift = false,
    ShiftUiModel? nextShift,
    bool clearNextShift = false,
    ActiveSessionEntity? activeSession,
    bool clearActiveSession = false,
    ShiftActionsEntity? actions,
    bool clearActions = false,
    HomeShiftRuntimeMode? runtimeMode,
    HomeActionType? primaryAction,
    HomeActionType? secondaryAction,
    List<HomeOpenWorkAreaUiModel>? openShiftWorkAreas,
    List<ShiftUiModel>? availableShifts,
    List<TodayTeammate>? teammates,
    String? infoMessage,
    bool clearInfoMessage = false,
    List<UpcomingShift>? upcomingShift,
    List<AvailableBranch>? availableLocations,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      isPrimaryLoading: isPrimaryLoading ?? this.isPrimaryLoading,
      isUpcomingLoading: isUpcomingLoading ?? this.isUpcomingLoading,
      isTeammatesLoading: isTeammatesLoading ?? this.isTeammatesLoading,
      isLocationsLoading: isLocationsLoading ?? this.isLocationsLoading,
      isWorkAreasLoading: isWorkAreasLoading ?? this.isWorkAreasLoading,
      shouldShowLocationPrompt:
          shouldShowLocationPrompt ?? this.shouldShowLocationPrompt,
      showAvailableShifts: showAvailableShifts ?? this.showAvailableShifts,
      todayShift: clearTodayShift ? null : (todayShift ?? this.todayShift),
      nextShift: clearNextShift ? null : (nextShift ?? this.nextShift),
      activeSession: clearActiveSession
          ? null
          : (activeSession ?? this.activeSession),
      actions: clearActions ? null : (actions ?? this.actions),
      runtimeMode: runtimeMode ?? this.runtimeMode,
      primaryAction: primaryAction ?? this.primaryAction,
      secondaryAction: secondaryAction ?? this.secondaryAction,
      openShiftWorkAreas: openShiftWorkAreas ?? this.openShiftWorkAreas,
      availableShifts: availableShifts ?? this.availableShifts,
      upcomingShift: upcomingShift ?? this.upcomingShift,
      teammates: teammates ?? this.teammates,
      infoMessage: clearInfoMessage ? null : (infoMessage ?? this.infoMessage),
      availableLocations: availableLocations ?? this.availableLocations,
    );
  }

  bool get hasTodayShift => todayShift != null;
  bool get hasNextShift => nextShift != null;
  bool get hasOpenShiftAreas => openShiftWorkAreas.isNotEmpty;

  bool get hasAnyVisibleHomeData {
    return todayShift != null ||
        nextShift != null ||
        openShiftWorkAreas.isNotEmpty ||
        upcomingShift.isNotEmpty ||
        teammates.isNotEmpty ||
        availableLocations.isNotEmpty;
  }

  bool get shouldShowFullPageLoader {
    return isLoading && !hasAnyVisibleHomeData;
  }

  ShiftUiModel? get currentDisplayShift {
    switch (runtimeMode) {
      case HomeShiftRuntimeMode.scheduledReady:
      case HomeShiftRuntimeMode.scheduledRunning:
      case HomeShiftRuntimeMode.scheduledOnBreak:
        return todayShift;

      case HomeShiftRuntimeMode.openRunning:
      case HomeShiftRuntimeMode.openOnBreak:
        return todayShift;

      case HomeShiftRuntimeMode.openReady:
      case HomeShiftRuntimeMode.none:
        return null;
    }
  }

  bool get showOpenShiftCard => runtimeMode == HomeShiftRuntimeMode.openReady;
}
