import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/account/domain/params/profile_image_update_params.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/account/domain/repository/account_repository.dart'
    show AccountRepository;

class UserImageUpdateUseCase
    with UseCases<LoginResponse, UpdateProfileImageParams> {
  final AccountRepository _repository = locator<AccountRepository>();

  @override
  Future<Either<Failure, LoginResponse>> call(UpdateProfileImageParams params) {
    return _repository.updateProfileImage(params);
  }
}
