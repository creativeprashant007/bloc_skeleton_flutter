import 'package:dartz/dartz.dart' show Either;
import 'package:stock_control_master/features/account/domain/entities/image_response.dart';
import 'package:stock_control_master/features/account/domain/entities/invite_user_response.dart';
import 'package:stock_control_master/features/account/domain/entities/pending_invitations_response.dart';
import 'package:stock_control_master/features/account/domain/params/invite_user_request_params.dart';
import 'package:stock_control_master/features/account/domain/params/profile_image_update_params.dart';
import 'package:stock_control_master/features/account/domain/repository/account_repository.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart';
import 'package:stock_control_master/shared/failure.dart' show Failure;

import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/account/domain/params/resend_invitations_params.dart'
    show ResendInvitationParams;
import 'package:stock_control_master/features/account/data/data_source/remote/account_remote_data_source.dart'
    show AccountRemoteDataSource;

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remote = locator<AccountRemoteDataSource>();

  @override
  Future<Either<Failure, ProfileImageResponse>> getProfileImage() {
    return _remote.getProfileImage();
  }

  @override
  Future<Either<Failure, LoginResponse>> updateProfileImage(
    UpdateProfileImageParams params,
  ) {
    return _remote.updateProfileImage(params);
  }

  @override
  Future<Either<Failure, InviteUserResponse>> inviteUser(
    InviteUserRequestParams params,
  ) {
    return _remote.inviteUser(params);
  }

  @override
  Future<Either<Failure, PendingInvitationsResponse>> getPendingInvitations() {
    return _remote.getPendingInvitations();
  }

  @override
  Future<Either<Failure, InviteUserResponse>> resendInvitation(
    ResendInvitationParams params,
  ) {
    return _remote.resendInvitation(params);
  }
}
