import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart';
import 'package:stock_control_master/features/home/domain/params/switch_branch_params.dart';

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

class SwitchLocationUseCase with UseCases<LoginResponse, SwitchBranchParams> {
  final HomeShiftRepository _repository = locator<HomeShiftRepository>();

  @override
  Future<Either<Failure, LoginResponse>> call(SwitchBranchParams params) {
    return _repository.checkoutBranch(params);
  }
}
