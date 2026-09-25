import 'package:dartz/dartz.dart';

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/home/domain/entities/home_shift_action_response.dart'
    show ShiftActionResponse;
import 'package:stock_control_master/features/home/domain/params/shift_action_params.dart';
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

class StartScheduledShiftUseCase
    with UseCases<ShiftActionResponse, ShiftActionParams> {
  final HomeShiftRepository _repository = locator<HomeShiftRepository>();

  @override
  Future<Either<Failure, ShiftActionResponse>> call(ShiftActionParams params) {
    return _repository.startScheduledShift(params);
  }
}
