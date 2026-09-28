import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_control_master/features/auth/presentation/view/sign_in_screen.dart';
import 'package:stock_control_master/features/index/presentation/view/index_screen.dart';
import 'package:stock_control_master/main.dart';
import 'package:logger/logger.dart' show Logger;
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart'
    show NavigationService;
import 'package:stock_control_master/features/splash/presentation/bloc/splash_event.dart'
    show
        OnboardingSkipPressed,
        OnboardingNextPressed,
        OnboardingEvent,
        OnboardingPageSwiped;
import 'package:stock_control_master/features/splash/presentation/bloc/splash_state.dart'
    show OnboardingState;

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({required int totalPages})
    : super(OnboardingState(pageIndex: 0, totalPages: totalPages)) {
    on<OnboardingPageSwiped>(_onPageSwiped);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
  }

  void _onPageSwiped(
    OnboardingPageSwiped event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(pageIndex: event.pageIndex, completed: false));
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.isLastPage) {
      emit(state.copyWith(completed: true));
    } else {
      emit(state.copyWith(pageIndex: state.pageIndex + 1, completed: false));
    }
  }

  void _onSkipPressed(
    OnboardingSkipPressed event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(completed: true));
  }
}
