import 'package:equatable/equatable.dart';

abstract class StartBreakEvent extends Equatable {
  const StartBreakEvent();

  @override
  List<Object?> get props => [];
}

class StartBreakStarted extends StartBreakEvent {
  const StartBreakStarted();
}

class BreakStartPressed extends StartBreakEvent {
  final String breakId;
  final String comment;

  const BreakStartPressed(this.breakId, {this.comment = ''});

  @override
  List<Object?> get props => [breakId, comment];
}

class StartBreakCancelPressed extends StartBreakEvent {
  const StartBreakCancelPressed();
}
