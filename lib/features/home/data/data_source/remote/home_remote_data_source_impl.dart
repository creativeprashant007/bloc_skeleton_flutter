import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stock_control_master/features/home/domain/params/working_today_params.dart'
    show WorkingPeopleTodayParams;
import 'package:stock_control_master/features/home/data/data_source/remote/home_remote_data_source.dart'
    show HomeShiftRemoteDataSource;
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_schedule_response.dart';
import 'package:stock_control_master/features/home/domain/entities/work_areas/work_areas_response.dart';
import 'package:stock_control_master/features/home/domain/params/switch_branch_params.dart'
    show SwitchBranchParams;
import 'package:logger/logger.dart';

import 'package:stock_control_master/core/constants/api_constants.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/core/services/network_service/network_service.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart'
    show LoginResponse;
import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart'
    show AvailableBranchResponse, AvailableBranch;
import 'package:stock_control_master/features/home/domain/entities/home_shift_action_response.dart'
    show ShiftActionResponse;
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_people_data.dart'
    show TodayPeopleData;
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_people_response.dart'
    show TodayPeopleResponse;
import 'package:stock_control_master/features/home/domain/entities/today_shift_data.dart'
    show TodayShiftData;
import 'package:stock_control_master/features/home/domain/entities/today_shift_response.dart';
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_schedule_data.dart'
    show UpcomingScheduleData;
import 'package:stock_control_master/features/home/domain/params/shift_action_params.dart';

class HomeShiftRemoteDataSourceImpl implements HomeShiftRemoteDataSource {
  final NetworkService _networkService = locator<NetworkService>();
  final Logger _logger = Logger();

  @override
  Future<Either<Failure, UpcomingScheduleResponse>>
  getUpcomingSchedule() async {
    try {
      final url = Uri.parse(ApiConstants.upcomingSchedule);

      final res = await _networkService.get(url.toString());

      _logger.i('Upcoming Schedule list response status: ${res.status}');
      _logger.i('Upcoming Schedule list response message: ${res.message}');
      _logger.i('Upcoming Schedule list response data: ${res.data}');

      final rawData = res.data;
      if (rawData == null) {
        return Left(Failure('Upcoming Schedule data is empty.'));
      }

      if (rawData is! Map<String, dynamic>) {
        return Left(Failure('Invalid Upcoming Schedule response format.'));
      }

      final response = UpcomingScheduleResponse(
        success: res.status == true,
        message: res.message ?? '',
        data: UpcomingScheduleData.fromJson(rawData),
      );

      if (!response.success) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to fetch Upcoming Schedule list.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('fetch Upcoming Schedule list failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'fetch Upcoming Schedule list remote exception',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Something went wrong: $e'));
    }
  }

  @override
  Future<Either<Failure, TodayPeopleResponse>> getTodayWorkingPeople(
    WorkingPeopleTodayParams params,
  ) async {
    try {
      final query = params.toQueryString();

      final url = query.isEmpty
          ? ApiConstants.todayWorkingPeople
          : '${ApiConstants.todayWorkingPeople}?$query';

      final res = await _networkService.get(url);

      _logger.i('Today Working People list url: $url');
      _logger.i('Today Working People list response status: ${res.status}');
      _logger.i('Today Working People list response message: ${res.message}');
      _logger.i('Today Working People list response data: ${res.data}');

      final rawData = res.data;

      if (rawData == null) {
        return Left(Failure('Today Working People data is empty.'));
      }

      if (rawData is! Map<String, dynamic>) {
        return Left(Failure('Invalid Today Working People response format.'));
      }

      final response = TodayPeopleResponse(
        success: res.status == true,
        message: res.message ?? '',
        data: TodayPeopleData.fromJson(rawData),
      );

      if (!response.success) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to fetch Today Working People list.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('Today Working People failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'Today Working People remote exception',
        error: e,
        stackTrace: stackTrace,
      );

      return Left(Failure('Something went wrong: $e'));
    }
  }

  @override
  Future<Either<Failure, TodayShiftResponse>> getTodayShiftStatus() async {
    try {
      final res = await _networkService.get(ApiConstants.todayShift);
      final rawData = res.data;

      if (rawData is! Map<String, dynamic>) {
        return Left(Failure('Invalid today shift response.'));
      }
      final response = TodayShiftResponse(
        success: res.status == true,
        message: res.message ?? '',
        data: TodayShiftData.fromJson(rawData),
      );

      return Right(response);
    } catch (e, st) {
      _logger.e('getTodayShiftStatus error', error: e, stackTrace: st);
      return Left(Failure('Failed to fetch shift status.'));
    }
  }

  @override
  Future<Either<Failure, WorkAreaResponse>> getWorkAreas() async {
    try {
      final res = await _networkService.get(ApiConstants.workArea);
      final rawData = res.data;

      _logger.i('work areas raw type: ${rawData.runtimeType}');
      _logger.i('work areas raw data: $rawData');

      if (rawData is! List) {
        return Left(Failure('Invalid work areas response.'));
      }

      final response = WorkAreaResponse(
        status: res.status ?? false,
        message: res.message ?? '',
        data: rawData
            .map(
              (e) => WorkAreaData.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      );

      if (!response.status) {
        return Left(
          Failure(
            response.message.isNotEmpty
                ? response.message
                : 'Failed to fetch work areas.',
          ),
        );
      }

      return Right(response);
    } catch (e, st) {
      _logger.e('getWorkAreas error', error: e, stackTrace: st);
      return Left(Failure('Failed to fetch work areas.'));
    }
  }

  @override
  Future<Either<Failure, AvailableBranchResponse>> getBranches({
    String? params,
  }) async {
    try {
      final res = await _networkService.get(params ?? ApiConstants.branch);
      final rawData = res.data;

      _logger.i('Branch raw type: ${rawData.runtimeType}');
      _logger.i('Branch raw data: $rawData');

      if (rawData is! List) {
        return Left(Failure('Invalid Branch response.'));
      }

      final response = AvailableBranchResponse(
        status: true,
        message: res.message ?? '',
        data: rawData
            .map(
              (e) =>
                  AvailableBranch.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      );

      if (!response.status) {
        return Left(
          Failure(
            response.message.isNotEmpty
                ? response.message
                : 'Failed to fetch Branch.',
          ),
        );
      }

      return Right(response);
    } catch (e, st) {
      _logger.e('fetch branch error', error: e, stackTrace: st);
      return Left(Failure('Failed to fetch Branch.'));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> checkoutBranch(
    SwitchBranchParams switchParams,
  ) async {
    try {
      final res = await _networkService.post(
        "/branch/${switchParams.branchId}${ApiConstants.branchCheckout}",
      );
      _logger.i("branch Switch  here: $res");

      final loginResponse = LoginResponse.fromJson(res.data!);

      if (loginResponse.status == true) {
        _logger.i("branch Switch : $loginResponse");
        return Right(loginResponse);
      } else {
        _logger.e("branch Switch  failed: ${loginResponse.message}");
        return Left(Failure(loginResponse.message));
      }
    } on Failure catch (e) {
      _logger.e("branch Switch  Failure: $e");
      return Left(e);
    } catch (e) {
      _logger.e("branch Switch  Exception: $e");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startScheduledShift(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.shiftIn,
      fields: params.toFormData(),
    );
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endScheduledShift(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.shiftOut,
      fields: params.toFormData(),
    );
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startScheduledBreak(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.startBreak,
      fields: params.toFormData(),
    );
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endScheduledBreak(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.endBreak,
      fields: params.toFormData(),
    );
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startOpenShift(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.openShiftIn,
      fields: params.toFormData(),
    );
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endOpenShift(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.openShiftOut,
      fields: params.toFormData(),
    );
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> startOpenBreak(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.openBreakIn,
      fields: params.toFormData(),
    );
  }

  @override
  Future<Either<Failure, ShiftActionResponse>> endOpenBreak(
    ShiftActionParams params,
  ) {
    return _postForm(
      endpoint: ApiConstants.openBreakOut,
      fields: params.toFormData(),
    );
  }

  Future<Either<Failure, ShiftActionResponse>> _postForm({
    required String endpoint,
    required Map<String, dynamic> fields,
  }) async {
    try {
      final formData = FormData.fromMap(fields);
      final res = await _networkService.post(endpoint, body: formData);

      final rawData = res.data;

      if (rawData is! Map<String, dynamic>) {
        return Left(Failure(res.message ?? 'Invalid response.'));
      }

      final parsed = ShiftActionResponse(
        success: res.status ?? true,
        message: res.message ?? '',
      );

      if (!parsed.success) {
        return Left(Failure(parsed.message));
      }

      return Right(parsed);
    } catch (e, st) {
      _logger.e('_postForm error', error: e, stackTrace: st);

      final errorString = e.toString();

      final match = RegExp(
        r'Failure\(message:\s*(.*?),\s*extraData:',
      ).firstMatch(errorString);

      final message = match?.group(1) ?? 'Something went wrong';

      return Left(Failure(message));
    }
  }
}
