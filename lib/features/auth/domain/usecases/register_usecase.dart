import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart'
    show LoginResponse;
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/auth/domain/params/register_user_params.dart'
    show RegisterUserParams;
import 'package:stock_control_master/features/auth/domain/repository/auth_repository.dart'
    show AuthRepository;
import 'package:stock_control_master/shared/failure.dart' show Failure;
import 'package:stock_control_master/shared/usecase.dart' show UseCases;

class RegisterUsecase with UseCases<LoginResponse, RegisterUserParams> {
  final _repository = locator<AuthRepository>();
  @override
  Future<Either<Failure, LoginResponse>> call(RegisterUserParams params) {
    return _repository.register(registerUserParams: params);
  }
}
