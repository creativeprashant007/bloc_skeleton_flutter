import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/home/domain/params/working_today_params.dart'
    show WorkingPeopleTodayParams;
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_schedule_response.dart';

import 'package:stock_control_master/core/locator.dart';
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
import 'package:stock_control_master/features/home/domain/entities/work_areas/work_areas_response.dart'
    show WorkAreaResponse;
import 'package:stock_control_master/features/home/domain/params/shift_action_params.dart';
import 'package:stock_control_master/features/home/domain/params/switch_branch_params.dart'
    show SwitchBranchParams;
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;
import 'package:stock_control_master/features/home/data/data_source/remote/home_remote_data_source.dart'
    show HomeShiftRemoteDataSource;

class HomeShiftRepositoryImpl implements HomeShiftRepository {
  final HomeShiftRemoteDataSource _remote =
      locator<HomeShiftRemoteDataSource>();

  @override
  Future<Either<Failure, TodayShiftResponse>> getTodayShiftStatus() {
    return _remote.getTodayShiftStatus();
  }

  @override
  Future<Either<Failure, UpcomingScheduleResponse>> getUpcomingSchedule() {
    return _remote.getUpcomingSchedule();
  }

  @override
  Future<Either<Failure, TodayPeopleResponse>> getTodayWorkingPeople(
    WorkingPeopleTodayParams params,
  ) {
    return _remote.getTodayWorkingPeople(params);
  }

  @override
  Future<Either<Failure, WorkAreaResponse>> getWorkAreas() {
    return _remote.getWorkAreas();
  }

  @override
  Future<Either<Failure, AvailableBranchResponse>> getBranches({
    String? params,
  }) {
    return _remote.getBranches(params: params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startScheduledShift(
    ShiftActionParams params,
  ) {
    return _remote.startScheduledShift(params);
  }

  @override
  Future<Either<Failure, LoginResponse>> checkoutBranch(
    SwitchBranchParams params,
  ) {
    return _remote.checkoutBranch(params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endScheduledShift(
    ShiftActionParams params,
  ) {
    return _remote.endScheduledShift(params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startScheduledBreak(
    ShiftActionParams params,
  ) {
    return _remote.startScheduledBreak(params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endScheduledBreak(
    ShiftActionParams params,
  ) {
    return _remote.endScheduledBreak(params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startOpenShift(
    ShiftActionParams params,
  ) {
    return _remote.startOpenShift(params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endOpenShift(
    ShiftActionParams params,
  ) {
    return _remote.endOpenShift(params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startOpenBreak(
    ShiftActionParams params,
  ) {
    return _remote.startOpenBreak(params);
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endOpenBreak(
    ShiftActionParams params,
  ) {
    return _remote.endOpenBreak(params);
  }
}
