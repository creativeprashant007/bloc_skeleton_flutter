import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int pageIndex;
  final int totalPages;
  final bool completed; // true when skip or last-next is pressed

  const OnboardingState({
    required this.pageIndex,
    required this.totalPages,
    this.completed = false,
  });

  bool get isLastPage => pageIndex == totalPages - 1;

  OnboardingState copyWith({int? pageIndex, int? totalPages, bool? completed}) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      totalPages: totalPages ?? this.totalPages,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [pageIndex, totalPages, completed];
}
