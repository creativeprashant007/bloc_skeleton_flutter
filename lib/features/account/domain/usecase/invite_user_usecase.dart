import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/account/domain/entities/invite_user_response.dart';
import 'package:stock_control_master/features/account/domain/params/invite_user_request_params.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/account/domain/repository/account_repository.dart'
    show AccountRepository;

class InviteUserUseCase
    with UseCases<InviteUserResponse, InviteUserRequestParams> {
  final AccountRepository _repository = locator<AccountRepository>();

  @override
  Future<Either<Failure, InviteUserResponse>> call(
    InviteUserRequestParams params,
  ) {
    return _repository.inviteUser(params);
  }
}
