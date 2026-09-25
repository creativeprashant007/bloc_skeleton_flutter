import 'package:dartz/dartz.dart' show Either;
import 'package:stock_control_master/features/account/domain/entities/invite_user_response.dart';
import 'package:stock_control_master/features/account/domain/entities/pending_invitations_response.dart';
import 'package:stock_control_master/features/account/domain/params/invite_user_request_params.dart';
import 'package:stock_control_master/features/account/domain/params/profile_image_update_params.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart';
import 'package:stock_control_master/shared/failure.dart' show Failure;

import 'package:stock_control_master/features/account/domain/entities/image_response.dart'
    show ProfileImageResponse;
import 'package:stock_control_master/features/account/domain/params/resend_invitations_params.dart'
    show ResendInvitationParams;

abstract class AccountRepository {
  Future<Either<Failure, ProfileImageResponse>> getProfileImage();

  Future<Either<Failure, LoginResponse>> updateProfileImage(
    UpdateProfileImageParams params,
  );

  Future<Either<Failure, InviteUserResponse>> inviteUser(
    InviteUserRequestParams params,
  );

  Future<Either<Failure, PendingInvitationsResponse>> getPendingInvitations();

  Future<Either<Failure, InviteUserResponse>> resendInvitation(
    ResendInvitationParams params,
  );
}
