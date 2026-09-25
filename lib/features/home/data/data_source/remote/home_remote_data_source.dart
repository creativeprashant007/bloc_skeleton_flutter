import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/home/domain/params/working_today_params.dart'
    show WorkingPeopleTodayParams;
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_schedule_response.dart';
import 'package:stock_control_master/features/home/domain/entities/work_areas/work_areas_response.dart';

import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart'
    show LoginResponse;
import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart'
    show AvailableBranchResponse;
import 'package:stock_control_master/features/home/domain/entities/home_shift_action_response.dart'
    show ShiftActionResponse;
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_people_response.dart'
    show TodayPeopleResponse;
import 'package:stock_control_master/features/home/domain/entities/today_shift_response.dart';
import 'package:stock_control_master/features/home/domain/params/shift_action_params.dart';
import 'package:stock_control_master/features/home/domain/params/switch_branch_params.dart'
    show SwitchBranchParams;

abstract class HomeShiftRemoteDataSource {
  Future<Either<Failure, TodayShiftResponse>> getTodayShiftStatus();
  Future<Either<Failure, TodayPeopleResponse>> getTodayWorkingPeople(
    WorkingPeopleTodayParams params,
  );
  Future<Either<Failure, UpcomingScheduleResponse>> getUpcomingSchedule();
  Future<Either<Failure, WorkAreaResponse>> getWorkAreas();
  Future<Either<Failure, AvailableBranchResponse>> getBranches({
    String? params,
  });

  Future<Either<Failure, ShiftActionResponse>> startScheduledShift(
    ShiftActionParams params,
  );
  Future<Either<Failure, LoginResponse>> checkoutBranch(
    SwitchBranchParams params,
  );

  Future<Either<Failure, ShiftActionResponse>> endScheduledShift(
    ShiftActionParams params,
  );

  Future<Either<Failure, ShiftActionResponse>> startScheduledBreak(
    ShiftActionParams params,
  );

  Future<Either<Failure, ShiftActionResponse>> endScheduledBreak(
    ShiftActionParams params,
  );

  Future<Either<Failure, ShiftActionResponse>> startOpenShift(
    ShiftActionParams params,
  );

  Future<Either<Failure, ShiftActionResponse>> endOpenShift(
    ShiftActionParams params,
  );

  Future<Either<Failure, ShiftActionResponse>> startOpenBreak(
    ShiftActionParams params,
  );

  Future<Either<Failure, ShiftActionResponse>> endOpenBreak(
    ShiftActionParams params,
  );
}
