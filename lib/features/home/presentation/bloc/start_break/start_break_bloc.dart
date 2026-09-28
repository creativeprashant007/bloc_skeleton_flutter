import 'package:stock_control_master/features/home/domain/models/break_option_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/home/presentation/bloc/start_break/start_break_event.dart';
import 'package:stock_control_master/features/home/presentation/bloc/start_break/start_break_state.dart';

class StartBreakBloc extends Bloc<StartBreakEvent, StartBreakState> {
  StartBreakBloc() : super(const StartBreakState()) {
    on<StartBreakStarted>(_onStarted);
    on<BreakStartPressed>(_onBreakStartPressed);
    on<StartBreakCancelPressed>(_onCancelPressed);
  }

  void _onStarted(StartBreakStarted event, Emitter<StartBreakState> emit) {
    emit(
      state.copyWith(
        breakOptions: const [
          BreakOptionUiModel(
            id: 'unpaid_30',
            title: 'Break (unpaid)',
            subtitle: '30 minutes',
            isPaid: false,
          ),
          BreakOptionUiModel(
            id: 'paid_rest',
            title: 'Rest Break (paid)',
            subtitle: 'Unscheduled',
            isPaid: true,
          ),
        ],
      ),
    );
  }

  void _onBreakStartPressed(
    BreakStartPressed event,
    Emitter<StartBreakState> emit,
  ) {
    emit(
      state.copyWith(
        selectedBreakId: event.breakId,
        comment: event.comment.trim(),
        shouldClose: true,
      ),
    );
  }

  void _onCancelPressed(
    StartBreakCancelPressed event,
    Emitter<StartBreakState> emit,
  ) {
    emit(state.copyWith(shouldClose: true));
  }
}
