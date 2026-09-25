import 'package:stock_control_master/features/home/presentation/models/shift_ui_model.dart'
    show ShiftUiModel;

import 'home_shift_runtime_mode.dart';

class HomeShiftViewModel {
  final ShiftUiModel? displayShift;
  final HomeShiftRuntimeMode mode;
  final bool canShowCard;

  const HomeShiftViewModel({
    required this.displayShift,
    required this.mode,
    required this.canShowCard,
  });
}
