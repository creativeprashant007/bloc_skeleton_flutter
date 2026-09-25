import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/index/domain/usecase/notification_count_usecase.dart'
    show NotificationCountUseCase;

import 'bottom_nav_event.dart';
import 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc({NotificationCountUseCase? notificationCountUseCase})
    : _notificationCountUseCase =
          notificationCountUseCase ?? NotificationCountUseCase(),

      super(
        const BottomNavState(
          selectedIndex: 0,
          messageCount: 0,
          pendingTimesheetCount: 0,
        ),
      ) {
    on<BottomNavTabChanged>(_onTabChanged);
    on<LoadNotificationCountEvent>(_loadNotificationCount);
    on<RefreshBottomNavCountsEvent>(_refreshCounts);
    on<BottomNavPendingTimesheetCountChanged>(_onPendingTimesheetCountChanged);

    add(RefreshBottomNavCountsEvent());
  }

  final NotificationCountUseCase _notificationCountUseCase;

  void _onTabChanged(BottomNavTabChanged event, Emitter<BottomNavState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onPendingTimesheetCountChanged(
    BottomNavPendingTimesheetCountChanged event,
    Emitter<BottomNavState> emit,
  ) {
    emit(state.copyWith(pendingTimesheetCount: event.count));
  }

  Future<void> _refreshCounts(
    RefreshBottomNavCountsEvent event,
    Emitter<BottomNavState> emit,
  ) async {
    await _loadNotificationCount(LoadNotificationCountEvent(), emit);
  }

  Future<void> _loadNotificationCount(
    LoadNotificationCountEvent event,
    Emitter<BottomNavState> emit,
  ) async {
    final result = await _notificationCountUseCase.callNoParams();

    result.fold((_) {}, (response) {
      emit(state.copyWith(messageCount: response.data.totalUnreadCount));
    });
  }
}
