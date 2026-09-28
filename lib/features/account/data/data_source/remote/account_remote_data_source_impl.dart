import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/account/domain/entities/image_response.dart';
import 'package:stock_control_master/features/account/domain/entities/invite_user_response.dart';
import 'package:stock_control_master/features/account/domain/entities/pending_invitations_response.dart';
import 'package:stock_control_master/features/account/domain/params/invite_user_request_params.dart';
import 'package:stock_control_master/features/account/domain/params/profile_image_update_params.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart';

import 'package:logger/logger.dart';

import 'package:stock_control_master/core/constants/api_constants.dart';
import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/core/services/network_service/network_service.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/features/account/domain/params/resend_invitations_params.dart'
    show ResendInvitationParams;
import 'package:stock_control_master/features/account/data/data_source/remote/account_remote_data_source.dart'
    show AccountRemoteDataSource;

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final NetworkService _networkService = locator<NetworkService>();
  final Logger _logger = Logger();

  @override
  Future<Either<Failure, ProfileImageResponse>> getProfileImage() async {
    try {
      final url = Uri.parse(ApiConstants.userImage);

      final res = await _networkService.get(url.toString());

      _logger.i('Image response status: ${res.status}');
      _logger.i('Image response message: ${res.message}');
      _logger.i('Image response data: ${res.data}');

      final rawData = res.data;

      if (rawData == null) {
        return Left(Failure('Image data is empty.'));
      }

      if (rawData is! Map<String, dynamic>) {
        return Left(Failure('Invalid Image response format.'));
      }

      final response = ProfileImageResponse(
        status: res.status == true,
        message: res.message ?? '',
        image: res.data,
      );

      if (!response.status) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to fetch Image.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('Fetch Image failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'Fetch Image remote exception',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Something went wrong: $e'));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> updateProfileImage(
    UpdateProfileImageParams params,
  ) async {
    try {
      final url = Uri.parse(ApiConstants.updateImage);

      final res = await _networkService.post(
        url.toString(),
        body: params.toFormData(),
      );

      _logger.i('Image update status: ${res.status}');
      _logger.i('Image update response message: ${res.message}');
      _logger.i('Image update response data: ${res.data}');

      final rawData = res.data;

      if (rawData == null) {
        return Left(Failure('Image update data is empty.'));
      }

      final response = LoginResponse.fromJson(rawData);

      if (!response.status) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to update Image.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('Update Image failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'Update Image remote exception',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Something went wrong: $e'));
    }
  }

  @override
  Future<Either<Failure, InviteUserResponse>> inviteUser(
    InviteUserRequestParams params,
  ) async {
    try {
      final url = Uri.parse(ApiConstants.inviteUser);

      final res = await _networkService.post(
        url.toString(),
        body: params.toFormData(),
      );

      _logger.i('Invite User status: ${res.status}');
      _logger.i('Invite User response message: ${res.message}');
      _logger.i('Invite User response data: ${res.data}');

      final rawData = res.data;

      if (rawData == null) {
        return Left(Failure('Invite User data is empty.'));
      }

      // if (rawData is! Map<String, dynamic>) {
      //   return Left(Failure('Invalid Invite User response format.'));
      // }

      final response = InviteUserResponse.fromJson(rawData);

      if (!response.status) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to invite user.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('Invite user failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'Invite user remote exception',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Something went wrong: $e'));
    }
  }

  @override
  Future<Either<Failure, PendingInvitationsResponse>>
  getPendingInvitations() async {
    try {
      final url = Uri.parse(ApiConstants.pendingInvitations);

      final res = await _networkService.get(url.toString());

      _logger.i('Pending Invitations status: ${res.status}');
      _logger.i('Pending Invitations message: ${res.message}');
      _logger.i('Pending Invitations data: ${res.data}');

      final rawData = res.data;

      if (rawData == null) {
        return Left(Failure('Pending invitations data is empty.'));
      }

      if (rawData is! Map<String, dynamic>) {
        return Left(Failure('Invalid pending invitations response format.'));
      }
      // final response = PendingInvitationsResponse.fromJson(rawData);

      final response = PendingInvitationsResponse(
        success: res.status == true,
        message: res.message ?? '',
        data: PendingInvitationsData.fromJson(rawData),
      );

      if (!response.success) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to fetch pending invitations.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('Pending invitations failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'Pending invitations remote exception',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Something went wrong: $e'));
    }
  }

  @override
  Future<Either<Failure, InviteUserResponse>> resendInvitation(
    ResendInvitationParams params,
  ) async {
    try {
      final url = Uri.parse(ApiConstants.resendInvitation(params.invitationId));

      final res = await _networkService.post(url.toString());

      _logger.i('Resend invitation status: ${res.status}');
      _logger.i('Resend invitation message: ${res.message}');
      _logger.i('Resend invitation data: ${res.data}');

      final rawData = res.data;

      if (rawData == null) {
        return Left(Failure('Resend invitation data is empty.'));
      }

      // if (rawData is! Map<String, dynamic>) {
      //   return Left(Failure('Invalid resend invitation response format.'));
      // }

      final response = InviteUserResponse.fromJson(rawData);

      if (!response.status) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to resend invitation.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('Resend invitation failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'Resend invitation remote exception',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Something went wrong: $e'));
    }
  }
}
