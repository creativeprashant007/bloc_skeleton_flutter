import 'package:equatable/equatable.dart';
import 'package:stock_control_master/features/home/domain/models/break_option_ui_model.dart'
    show BreakOptionUiModel;

class StartBreakSelection extends Equatable {
  final String breakId;
  final String comment;

  const StartBreakSelection({required this.breakId, this.comment = ''});

  @override
  List<Object?> get props => [breakId, comment];
}

class StartBreakState extends Equatable {
  final List<BreakOptionUiModel> breakOptions;
  final bool shouldClose;
  final String? selectedBreakId;
  final String comment;

  const StartBreakState({
    this.breakOptions = const [],
    this.shouldClose = false,
    this.selectedBreakId,
    this.comment = '',
  });

  StartBreakState copyWith({
    List<BreakOptionUiModel>? breakOptions,
    bool? shouldClose,
    String? selectedBreakId,
    String? comment,
  }) {
    return StartBreakState(
      breakOptions: breakOptions ?? this.breakOptions,
      shouldClose: shouldClose ?? false,
      selectedBreakId: selectedBreakId ?? this.selectedBreakId,
      comment: comment ?? this.comment,
    );
  }

  StartBreakSelection? get selection {
    final id = selectedBreakId?.trim();

    if (id == null || id.isEmpty) return null;

    return StartBreakSelection(breakId: id, comment: comment.trim());
  }

  @override
  List<Object?> get props => [
    breakOptions,
    shouldClose,
    selectedBreakId,
    comment,
  ];
}
