import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/account/domain/entities/invite_user_response.dart';

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/account/domain/params/resend_invitations_params.dart'
    show ResendInvitationParams;
import 'package:stock_control_master/features/account/domain/repository/account_repository.dart'
    show AccountRepository;

class ResendInvitationUseCase
    with UseCases<InviteUserResponse, ResendInvitationParams> {
  final AccountRepository _repository = locator<AccountRepository>();

  @override
  Future<Either<Failure, InviteUserResponse>> call(
    ResendInvitationParams params,
  ) {
    return _repository.resendInvitation(params);
  }
}
