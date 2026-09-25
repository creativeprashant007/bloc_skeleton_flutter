import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// User swiped PageView to a new index
class OnboardingPageSwiped extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageSwiped(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

/// User tapped the primary button (Next / Get started)
class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

/// User tapped Skip
class OnboardingSkipPressed extends OnboardingEvent {
  const OnboardingSkipPressed();
}
