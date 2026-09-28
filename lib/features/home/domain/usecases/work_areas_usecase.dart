import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/home/domain/entities/work_areas/work_areas_response.dart';

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

class WorkAreasUsecase with UseCases<WorkAreaResponse, NoParams> {
  final HomeShiftRepository _repository = locator<HomeShiftRepository>();

  @override
  Future<Either<Failure, WorkAreaResponse>> call(NoParams params) {
    return _repository.getWorkAreas();
  }

  Future<Either<Failure, WorkAreaResponse>> callNoParams() {
    return _repository.getWorkAreas();
  }
}
