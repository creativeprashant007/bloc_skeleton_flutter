import 'package:dartz/dartz.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_people_response.dart'
    show TodayPeopleResponse;
import 'package:stock_control_master/features/home/domain/params/working_today_params.dart'
    show WorkingPeopleTodayParams;
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

class WorkingPeopleTodayUsecase
    with UseCases<TodayPeopleResponse, WorkingPeopleTodayParams> {
  final HomeShiftRepository _repository = locator<HomeShiftRepository>();

  @override
  Future<Either<Failure, TodayPeopleResponse>> call(
    WorkingPeopleTodayParams params,
  ) {
    return _repository.getTodayWorkingPeople(params);
  }
}
