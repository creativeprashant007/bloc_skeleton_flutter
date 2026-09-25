import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/account/domain/entities/pending_invitations_response.dart';

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';
import 'package:stock_control_master/features/account/domain/repository/account_repository.dart'
    show AccountRepository;

class GetPendingInvitationsUseCase
    with UseCases<PendingInvitationsResponse, NoParams> {
  final AccountRepository _repository = locator<AccountRepository>();

  @override
  Future<Either<Failure, PendingInvitationsResponse>> call(NoParams params) {
    return _repository.getPendingInvitations();
  }
}
