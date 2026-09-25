import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

class GetLocationsUseCase with UseCases<AvailableBranchResponse, NoParams> {
  final HomeShiftRepository _repository = locator<HomeShiftRepository>();

  @override
  Future<Either<Failure, AvailableBranchResponse>> call(NoParams params) {
    return _repository.getBranches();
  }

  Future<Either<Failure, AvailableBranchResponse>> callNoParams({
    String? params,
  }) {
    return _repository.getBranches(params: params);
  }
}
