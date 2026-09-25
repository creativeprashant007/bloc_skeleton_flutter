import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_schedule_response.dart';

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';

import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

class UpcomingScheduleUsecase
    with UseCases<UpcomingScheduleResponse, NoParams> {
  final HomeShiftRepository _repository = locator<HomeShiftRepository>();

  @override
  Future<Either<Failure, UpcomingScheduleResponse>> call(NoParams params) {
    return _repository.getUpcomingSchedule();
  }

  Future<Either<Failure, UpcomingScheduleResponse>> callNoParams() {
    return _repository.getUpcomingSchedule();
  }
}
