import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/home/domain/entities/today_shift_response.dart';

class GetTodayShiftUseCase with UseCases<TodayShiftResponse, NoParams> {
  final HomeShiftRepository _repository = locator<HomeShiftRepository>();

  @override
  Future<Either<Failure, TodayShiftResponse>> call(NoParams params) {
    return _repository.getTodayShiftStatus();
  }

  Future<Either<Failure, TodayShiftResponse>> callNoParams() {
    return _repository.getTodayShiftStatus();
  }
}
