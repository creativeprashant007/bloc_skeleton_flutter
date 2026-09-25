import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart'
    show LoginResponse;
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/auth/domain/params/login_params.dart'
    show LoginParams;
import 'package:stock_control_master/features/auth/domain/repository/auth_repository.dart'
    show AuthRepository;
import 'package:stock_control_master/shared/usecase.dart' show UseCases;

import 'package:stock_control_master/shared/failure.dart' show Failure;

class LoginUsecase with UseCases<LoginResponse, LoginParams> {
  final _repository = locator<AuthRepository>();
  @override
  Future<Either<Failure, LoginResponse>> call(LoginParams params) {
    print("i am here inside login use case");
    return _repository.login(params: params);
  }
}
