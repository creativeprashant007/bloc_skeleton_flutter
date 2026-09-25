import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_control_master/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:stock_control_master/features/index/presentation/view/index_screen.dart';
import 'package:stock_control_master/main.dart';
import 'package:logger/logger.dart' show Logger;
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart'
    show NavigationService;
import 'splash_event.dart'
    show
        OnboardingSkipPressed,
        OnboardingNextPressed,
        OnboardingEvent,
        OnboardingPageSwiped;
import 'splash_state.dart' show OnboardingState;

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({required int totalPages})
    : super(OnboardingState(pageIndex: 0, totalPages: totalPages)) {
    on<OnboardingPageSwiped>(_onPageSwiped);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
  }
  final _logger = Logger();
  final _navigationService = locator<NavigationService>();
  void _onPageSwiped(
    OnboardingPageSwiped event,
    Emitter<OnboardingState> emit,
  ) {
    // Just reflect the swiped page
    emit(state.copyWith(pageIndex: event.pageIndex, completed: false));
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.isLastPage) {
      // On last page -> onboarding done
      emit(state.copyWith(completed: true));
    } else {
      // Move to next page
      emit(state.copyWith(pageIndex: state.pageIndex + 1, completed: false));
    }
  }

  void _onSkipPressed(
    OnboardingSkipPressed event,
    Emitter<OnboardingState> emit,
  ) {
    // Skip finishes onboarding immediately

    emit(state.copyWith(completed: true));

    _logger.i("get data user response: ${storageService.getIsLoggedIn()}");
    _navigationService.navigateToOffAllNamed(
      SignInScreen.routeName,
      (_) => false,
    );

    if (storageService.getIsLoggedIn()) {
      _navigationService.navigateToOffAllNamed(
        IndexScreen.routeName,
        (_) => false,
      );
    } else {
      _navigationService.navigateToOffAllNamed(
        SignInScreen.routeName,
        (_) => false,
      );
    }
  }
}
