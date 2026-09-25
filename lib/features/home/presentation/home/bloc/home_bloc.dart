import 'package:stock_control_master/shared/widgets/dialogs/info_dialog.dart';
import 'package:stock_control_master/features/home/domain/params/working_today_params.dart';

import 'package:stock_control_master/shared/failure.dart' show Failure;

import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart';
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_team_mates.dart';
import 'package:stock_control_master/features/home/domain/params/switch_branch_params.dart';
import 'package:stock_control_master/features/home/domain/usecases/upcoming_schedule_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/working_people_today_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'package:stock_control_master/core/configs/service/storage_service.dart'
    show StorageService;
import 'package:stock_control_master/core/constants/constant.dart'
    show AppConstants;
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/widgets/dialogs/error_dialog.dart'
    show ErrorDialog;
import 'package:stock_control_master/shared/widgets/dialogs/loading_dialog.dart'
    show LoadingDialog;
import 'package:stock_control_master/core/services/session_manager.dart'
    show SessionManager;
import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart'
    show DialogAndSheetService;
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart'
    show AccountBloc;
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart'
    show LoadAccount;
import 'package:stock_control_master/features/account/presentation/view/account_page.dart';
import 'package:stock_control_master/features/auth/domain/entities/current_user.dart'
    show CurrentUser;
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_bloc.dart'
    show BottomNavBloc;
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_event.dart'
    show BottomNavTabChanged;
import 'package:stock_control_master/features/home/domain/entities/home_shift_action_response.dart';
import 'package:stock_control_master/features/home/domain/params/shift_action_params.dart';
import 'package:stock_control_master/features/home/domain/usecases/end_open_break_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/end_open_shift_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/end_scheduled_break_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/end_scheduled_shift_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/get_location_usecase.dart'
    show GetLocationsUseCase;
import 'package:stock_control_master/features/home/domain/usecases/get_today_shift_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/start_open_break_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/start_open_shift_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/start_scheduled_break_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/start_scheduled_shift_usecase.dart'
    show StartScheduledShiftUseCase;
import 'package:stock_control_master/features/home/domain/usecases/switch_location_usecase.dart'
    show SwitchLocationUseCase;
import 'package:stock_control_master/features/home/domain/usecases/work_areas_usecase.dart.dart'
    show WorkAreasUsecase;
import 'package:stock_control_master/features/home/presentation/helper/home_location_helper.dart'
    show HomeLocationHelper;
import 'package:stock_control_master/features/home/presentation/mapper/home_ui_mapper.dart';
import 'package:stock_control_master/features/home/presentation/models/home_action_type.dart'
    show HomeActionType;
import 'package:stock_control_master/features/home/presentation/models/home_open_work_area_ui_model.dart'
    show HomeOpenWorkAreaUiModel;
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    NavigationService? navigationService,
    GetTodayShiftUseCase? getTodayShiftUseCase,
    StartScheduledShiftUseCase? startScheduledShiftUseCase,
    EndScheduledShiftUseCase? endScheduledShiftUseCase,
    StartScheduledBreakUseCase? startScheduledBreakUseCase,
    EndScheduledBreakUseCase? endScheduledBreakUseCase,
    StartOpenShiftUseCase? startOpenShiftUseCase,
    EndOpenShiftUseCase? endOpenShiftUseCase,
    StartOpenBreakUseCase? startOpenBreakUseCase,
    EndOpenBreakUseCase? endOpenBreakUseCase,
    WorkAreasUsecase? workAreasUseCase,
    WorkingPeopleTodayUsecase? workingPeopleTodayUsecase,
    UpcomingScheduleUsecase? upcomingScheduleUsecase,
    SwitchLocationUseCase? switchLocationUseCase,
    GetLocationsUseCase? getLocationsUseCase,
    StorageService? storageService,
  }) : _storage = storageService ?? StorageService(),

       _navigationService = navigationService ?? locator<NavigationService>(),
       _getTodayShiftUseCase =
           getTodayShiftUseCase ?? locator<GetTodayShiftUseCase>(),
       _startScheduledShiftUseCase =
           startScheduledShiftUseCase ?? locator<StartScheduledShiftUseCase>(),
       _endScheduledShiftUseCase =
           endScheduledShiftUseCase ?? locator<EndScheduledShiftUseCase>(),
       _startScheduledBreakUseCase =
           startScheduledBreakUseCase ?? locator<StartScheduledBreakUseCase>(),
       _endScheduledBreakUseCase =
           endScheduledBreakUseCase ?? locator<EndScheduledBreakUseCase>(),
       _startOpenShiftUseCase =
           startOpenShiftUseCase ?? locator<StartOpenShiftUseCase>(),
       _endOpenShiftUseCase =
           endOpenShiftUseCase ?? locator<EndOpenShiftUseCase>(),
       _startOpenBreakUseCase =
           startOpenBreakUseCase ?? locator<StartOpenBreakUseCase>(),
       _endOpenBreakUseCase =
           endOpenBreakUseCase ?? locator<EndOpenBreakUseCase>(),
       _workAreasUseCase = workAreasUseCase ?? locator<WorkAreasUsecase>(),
       _workingPeopleTodayUsecase =
           workingPeopleTodayUsecase ?? locator<WorkingPeopleTodayUsecase>(),
       _upcomingScheduleUsecase =
           upcomingScheduleUsecase ?? locator<UpcomingScheduleUsecase>(),
       _getLocationsUseCase =
           getLocationsUseCase ?? locator<GetLocationsUseCase>(),
       _switchLocationUseCase =
           switchLocationUseCase ?? locator<SwitchLocationUseCase>(),
       super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomePrimaryActionPressed>(_onPrimaryActionPressed);
    on<HomeSecondaryActionPressed>(_onSecondaryActionPressed);
    on<HomeToggleAvailableShiftsPressed>(_onToggleAvailableShiftsPressed);
    on<HomeProfileTapped>(_onProfileTapped);
    on<HomeUpcomingShiftTapped>(_onUpcomingShiftTapped);
    on<HomeWorkingTodayTapped>(_onWorkingTodayTapped);
    on<HomeNavTapped>(_onHomeNavTapped);
    on<HomeChangeLocation>(_onChangeLocation);
    on<HomeLocationPromptHandled>(_onLocationPromptHandled);
    on<HomeLocationPromptClosed>(_onLocationPromptClosed);
    on<AvailableTapped>(_availableTapped);
  }

  final Logger _logger = Logger();
  final DialogAndSheetService _dialogService = locator<DialogAndSheetService>();
  final StorageService _storage;
  final NavigationService _navigationService;
  bool _storageInitialized = false;
  final GetTodayShiftUseCase _getTodayShiftUseCase;
  final StartScheduledShiftUseCase _startScheduledShiftUseCase;
  final EndScheduledShiftUseCase _endScheduledShiftUseCase;
  final StartScheduledBreakUseCase _startScheduledBreakUseCase;
  final EndScheduledBreakUseCase _endScheduledBreakUseCase;
  final StartOpenShiftUseCase _startOpenShiftUseCase;
  final EndOpenShiftUseCase _endOpenShiftUseCase;
  final StartOpenBreakUseCase _startOpenBreakUseCase;
  final EndOpenBreakUseCase _endOpenBreakUseCase;
  final WorkAreasUsecase _workAreasUseCase;
  final WorkingPeopleTodayUsecase _workingPeopleTodayUsecase;
  final UpcomingScheduleUsecase _upcomingScheduleUsecase;
  final GetLocationsUseCase _getLocationsUseCase;
  final SwitchLocationUseCase _switchLocationUseCase;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    await _loadHomeStatus(emit, showLoader: true);
  }

  Future<void> _ensureStorageInitialized() async {
    if (_storageInitialized) return;
    await _storage.init();
    _storageInitialized = true;
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    await _loadHomeStatus(emit, showLoader: false);
  }

  Future<void> _loadHomeStatus(
    Emitter<HomeState> emit, {
    required bool showLoader,
  }) async {
    emit(
      state.copyWith(
        isLoading: showLoader && !state.hasAnyVisibleHomeData,
        isPrimaryLoading: true,
        isUpcomingLoading: true,
        isTeammatesLoading: true,
        isLocationsLoading: true,
        isWorkAreasLoading: true,
        clearInfoMessage: true,
        shouldShowLocationPrompt: false,
      ),
    );

    final todayShiftFuture = _getTodayShiftUseCase.callNoParams();
    final workAreasFuture = _workAreasUseCase.callNoParams();
    final workingPeopleFuture = _workingPeopleTodayUsecase.call(
      WorkingPeopleTodayParams(page: 1),
    );
    final upcomingFuture = _upcomingScheduleUsecase.callNoParams();
    final locationsFuture = _getLocationsUseCase.callNoParams();

    final todayShiftResult = await todayShiftFuture;

    todayShiftResult.fold(
      (failure) {
        _logger.e('Home status load failed: ${failure.message}');

        emit(
          state.copyWith(
            isLoading: false,
            isPrimaryLoading: false,
            infoMessage: failure.message,
          ),
        );
      },
      (response) {
        final mapped = HomeUiMapper.mapResponse(
          response,
          team: const <TodayTeammate>[],
        );

        emit(
          state.copyWith(
            isLoading: false,
            isPrimaryLoading: false,
            todayShift: mapped.todayShift,
            nextShift: mapped.nextShift,
            activeSession: mapped.activeSession,
            actions: mapped.actions,
            runtimeMode: mapped.runtimeMode,
            primaryAction: mapped.primaryAction,
            secondaryAction: mapped.secondaryAction,
            availableShifts: mapped.availableShifts,
            clearInfoMessage: true,
          ),
        );
      },
    );

    final workAreasResult = await workAreasFuture;

    workAreasResult.fold(
      (failure) {
        _logger.e('Work areas load failed: ${failure.message}');
        emit(state.copyWith(isWorkAreasLoading: false));
      },
      (success) {
        final apiWorkAreas = success.data
            .map(
              (e) => HomeOpenWorkAreaUiModel(
                id: e.id,
                name: e.name,
                branchId: 0,
                branchName: '',
              ),
            )
            .toList();

        emit(
          state.copyWith(
            isWorkAreasLoading: false,
            openShiftWorkAreas: apiWorkAreas,
          ),
        );

        _logger.i('Loaded work areas: ${apiWorkAreas.length}');
      },
    );

    final locationsResult = await locationsFuture;

    await locationsResult.fold(
      (failure) async {
        _logger.e('Locations load failed: ${failure.message}');

        emit(
          state.copyWith(
            isLocationsLoading: false,
            shouldShowLocationPrompt: false,
          ),
        );
      },
      (success) async {
        final locations = success.data;
        final shouldPrompt = await _shouldShowBranchPrompt(locations);

        emit(
          state.copyWith(
            isLocationsLoading: false,
            availableLocations: locations,
            shouldShowLocationPrompt: shouldPrompt,
          ),
        );
      },
    );

    final upcomingResult = await upcomingFuture;

    upcomingResult.fold(
      (failure) {
        _logger.e('Upcoming schedule load failed: ${failure.message}');
        emit(state.copyWith(isUpcomingLoading: false));
      },
      (success) {
        emit(
          state.copyWith(
            isUpcomingLoading: false,
            upcomingShift: success.data.upcomingSchedule,
          ),
        );
      },
    );

    final workingPeopleResult = await workingPeopleFuture;

    workingPeopleResult.fold(
      (failure) {
        _logger.e('Today working people load failed: ${failure.message}');
        emit(state.copyWith(isTeammatesLoading: false));
      },
      (success) {
        emit(
          state.copyWith(
            isTeammatesLoading: false,
            teammates: success.data.items,
          ),
        );
      },
    );

    emit(state.copyWith(isLoading: false));
  }

  Future<bool> _shouldShowBranchPrompt(List<AvailableBranch> locations) async {
    if (locations.length <= 1) return false;

    await _ensureStorageInitialized();

    return !_storage.wasBranchPromptShownToday();
  }

  Future<void> _onLocationPromptHandled(
    HomeLocationPromptHandled event,
    Emitter<HomeState> emit,
  ) async {
    await _ensureStorageInitialized();

    await _storage.setActiveBranchId(event.branchId);
    await _storage.markBranchPromptShownToday();

    emit(state.copyWith(shouldShowLocationPrompt: false));
  }

  void _onLocationPromptClosed(
    HomeLocationPromptClosed event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(shouldShowLocationPrompt: false));
  }

  Future<void> _onChangeLocation(
    HomeChangeLocation event,
    Emitter<HomeState> emit,
  ) async {
    await _ensureStorageInitialized();

    _showLoading('Switching...');

    final res = await _switchLocationUseCase.call(
      SwitchBranchParams(branchId: event.branchId),
    );

    emit(
      state.copyWith(
        isActionLoading: true,
        shouldShowLocationPrompt: false,
        clearInfoMessage: true,
      ),
    );

    await res.fold(
      (failure) async {
        _logger.e('Switch failed: ${failure.message}');

        _closeLoadingIfOpen();

        emit(
          state.copyWith(isActionLoading: false, infoMessage: failure.message),
        );

        _showError(failure.message);
      },
      (loginResponse) async {
        await _saveToken(loginResponse.token);

        await _storage.setActiveBranchId(event.branchId);

        if (event.markPromptHandled) {
          await _storage.markBranchPromptShownToday();
        }

        if (loginResponse.user != null) {
          await _saveUserJson(loginResponse.user!.toJson());
        }

        _logger.i('Switching success: ${loginResponse.user}');

        _closeLoadingIfOpen();

        if (emit.isDone) return;

        emit(
          state.copyWith(
            isActionLoading: false,
            isLoading: false,
            shouldShowLocationPrompt: false,
          ),
        );

        add(const HomeRefreshRequested());
      },
    );
  }

  Future<void> _runAction({
    required Emitter<HomeState> emit,
    required Future<dynamic> Function() request,
  }) async {
    emit(state.copyWith(isActionLoading: true, clearInfoMessage: true));

    final result = await request();

    await result.fold(
      (Failure failure) async {
        _logger.e('Home action failed: ${failure.message}');
        emit(
          state.copyWith(isActionLoading: false, infoMessage: failure.message),
        );
        _dialogService.showAppDialog(
          child: InfoDialog(message: failure.message),
        );
      },
      (ShiftActionResponse response) async {
        emit(
          state.copyWith(isActionLoading: false, infoMessage: response.message),
        );

        await _loadHomeStatus(emit, showLoader: false);
      },
    );
  }

  Future<void> _onPrimaryActionPressed(
    HomePrimaryActionPressed event,
    Emitter<HomeState> emit,
  ) async {
    final comment = event.comment?.trim();

    switch (state.primaryAction) {
      case HomeActionType.startShift:
        await _startScheduledShift(emit, comment: comment);
        break;

      case HomeActionType.startBreak:
        await _startScheduledBreak(
          emit,
          breakId: event.breakId,
          comment: comment,
        );
        break;

      case HomeActionType.endBreak:
        await _endScheduledBreak(emit, comment: comment);
        break;

      case HomeActionType.startOpenShift:
        await _startOpenShift(
          emit,
          workAreaId: event.workAreaId,
          comment: comment,
        );
        break;

      case HomeActionType.startOpenBreak:
        await _startOpenBreak(emit, breakId: event.breakId, comment: comment);
        break;

      case HomeActionType.endOpenBreak:
        await _endOpenBreak(emit, comment: comment);
        break;

      case HomeActionType.endShift:
        await _endScheduledShift(emit, comment: comment);
        break;

      case HomeActionType.endOpenShift:
        await _endOpenShift(emit, comment: comment);
        break;

      case HomeActionType.none:
        emit(state.copyWith(infoMessage: 'No action available.'));
        break;
    }
  }

  Future<void> _onSecondaryActionPressed(
    HomeSecondaryActionPressed event,
    Emitter<HomeState> emit,
  ) async {
    final comment = event.comment?.trim();

    switch (state.secondaryAction) {
      case HomeActionType.endShift:
        await _endScheduledShift(emit, comment: comment);
        break;

      case HomeActionType.endOpenShift:
        await _endOpenShift(emit, comment: comment);
        break;

      case HomeActionType.none:
        emit(state.copyWith(infoMessage: 'No secondary action available.'));
        break;

      default:
        emit(state.copyWith(infoMessage: 'Unsupported secondary action.'));
        break;
    }
  }

  Future<void> _startScheduledShift(
    Emitter<HomeState> emit, {
    String? comment,
  }) async {
    final shiftId = state.todayShift?.apiShiftId;

    if (shiftId == null) {
      emit(state.copyWith(infoMessage: 'No scheduled shift found.'));
      return;
    }

    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _startScheduledShiftUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          shiftId: shiftId,
          comment: comment,
        ),
      ),
    );
  }

  Future<void> _endScheduledShift(
    Emitter<HomeState> emit, {
    String? comment,
  }) async {
    final shiftId =
        state.activeSession?.shiftId ?? state.todayShift?.apiShiftId;

    if (shiftId == null) {
      emit(state.copyWith(infoMessage: 'No running scheduled shift found.'));
      return;
    }

    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _endScheduledShiftUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          shiftId: shiftId,
          comment: comment,
        ),
      ),
    );
  }

  Future<void> _startScheduledBreak(
    Emitter<HomeState> emit, {
    String? breakId,
    String? comment,
  }) async {
    final shiftId =
        state.activeSession?.shiftId ?? state.todayShift?.apiShiftId;

    if (shiftId == null) {
      emit(state.copyWith(infoMessage: 'No running scheduled shift found.'));
      return;
    }

    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _startScheduledBreakUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          shiftId: shiftId,
          breakId: breakId,
          comment: comment,
        ),
      ),
    );
  }

  Future<void> _endScheduledBreak(
    Emitter<HomeState> emit, {
    String? comment,
  }) async {
    final shiftId =
        state.activeSession?.shiftId ?? state.todayShift?.apiShiftId;

    if (shiftId == null) {
      emit(state.copyWith(infoMessage: 'No running scheduled shift found.'));
      return;
    }

    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _endScheduledBreakUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          shiftId: shiftId,
          comment: comment,
        ),
      ),
    );
  }

  Future<void> _startOpenShift(
    Emitter<HomeState> emit, {
    required int? workAreaId,
    String? comment,
  }) async {
    if (workAreaId == null || workAreaId <= 0) {
      emit(state.copyWith(infoMessage: 'Please select a valid work area.'));
      return;
    }

    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _startOpenShiftUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          workAreaId: workAreaId,
          comment: comment,
        ),
      ),
    );
  }

  Future<void> _endOpenShift(Emitter<HomeState> emit, {String? comment}) async {
    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _endOpenShiftUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          comment: comment,
        ),
      ),
    );
  }

  Future<void> _startOpenBreak(
    Emitter<HomeState> emit, {
    String? breakId,
    String? comment,
  }) async {
    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _startOpenBreakUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          breakId: breakId,
          comment: comment,
        ),
      ),
    );
  }

  Future<void> _endOpenBreak(Emitter<HomeState> emit, {String? comment}) async {
    final location = await HomeLocationHelper.getCurrentLocation();

    await _runAction(
      emit: emit,
      request: () => _endOpenBreakUseCase(
        ShiftActionParams(
          latitude: location.latitude,
          longitude: location.longitude,
          comment: comment,
        ),
      ),
    );
  }

  void _onToggleAvailableShiftsPressed(
    HomeToggleAvailableShiftsPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        showAvailableShifts: !state.showAvailableShifts,
        clearInfoMessage: true,
      ),
    );
  }

  void _onHomeNavTapped(HomeNavTapped event, Emitter<HomeState> emit) {
    event.context!.read<BottomNavBloc>().add(BottomNavTabChanged(event.index));
  }

  void _onProfileTapped(HomeProfileTapped event, Emitter<HomeState> emit) {
    _navigationService.navigateToNamed(AccountPage.routeName);
  }

  void _showLoading(String message) {
    _dialogService.showAppDialog(child: LoadingDialog(message: message));
  }

  void _closeLoadingIfOpen() {
    _navigationService.back();
  }

  void _showError(String message) {
    _dialogService.showAppDialog(child: ErrorDialog(errorMessage: message));
  }

  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    await _storage.setString(AppConstants.STORAGE_TOKEN_KEY, token);
  }

  Future<void> _saveUserJson(Map<String, dynamic> userJson) async {
    final user = CurrentUser.fromJson(userJson);
    await SessionManager.instance.saveUser(user);
  }

  void _onUpcomingShiftTapped(
    HomeUpcomingShiftTapped event,
    Emitter<HomeState> emit,
  ) async {}

  void _onWorkingTodayTapped(
    HomeWorkingTodayTapped event,
    Emitter<HomeState> emit,
  ) async {}

  void _availableTapped(AvailableTapped event, Emitter<HomeState> emit) async {}
}
