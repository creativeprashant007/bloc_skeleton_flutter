import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/account/domain/entities/image_response.dart'
    show ProfileImageResponse;
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/account/domain/repository/account_repository.dart'
    show AccountRepository;

class UserImageUseCase with UseCases<ProfileImageResponse, NoParams> {
  final AccountRepository _repository = locator<AccountRepository>();

  @override
  Future<Either<Failure, ProfileImageResponse>> call(NoParams params) {
    return _repository.getProfileImage();
  }
}
