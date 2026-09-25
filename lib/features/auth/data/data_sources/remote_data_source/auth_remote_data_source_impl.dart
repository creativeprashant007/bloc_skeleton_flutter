import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart'
    show LoginResponse;
import 'package:stock_control_master/core/constants/api_constants.dart'
    show ApiConstants;
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/auth/data/data_sources/remote_data_source/auth_remote_data_source.dart'
    show AuthRemoteDataSource;
import 'package:stock_control_master/features/auth/domain/params/login_params.dart'
    show LoginParams;
import 'package:stock_control_master/features/auth/domain/params/register_user_params.dart'
    show RegisterUserParams;
import 'package:stock_control_master/features/auth/domain/params/verify_otp_params.dart'
    show VerifyOtpParams;
import 'package:stock_control_master/core/constants/hive_box_names.dart'
    show HiveBoxNames;
import 'package:stock_control_master/core/constants/hive_storage_keys.dart'
    show HiveStorageKeys;
import 'package:stock_control_master/shared/failure.dart' show Failure;
import 'package:stock_control_master/core/services/local_storage_service/local_storage_service.dart'
    show LocalStorageService;
import 'package:stock_control_master/core/services/network_service/network_service.dart'
    show NetworkService;
import 'package:logger/logger.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final _networkService = locator<NetworkService>();
  final _localStorageService = locator<LocalStorageService>();
  final _logger = Logger();
  @override
  Future<Either<Failure, LoginResponse>> register({
    required RegisterUserParams registerUserParams,
  }) async {
    try {
      final res = await _networkService.post(
        ApiConstants.register,
        body: registerUserParams.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      _logger.i("Login response here: $res");

      final signUpResponse = LoginResponse.fromJson(res.data!);

      if (signUpResponse.status == true) {
        _logger.i("Login response: $signUpResponse");
        return Right(signUpResponse);
      } else {
        _logger.e("Login failed: ${signUpResponse.message}");
        return Left(Failure(signUpResponse.message));
      }
    } on Failure catch (e) {
      _logger.e("Login response Failure: $e");
      return Left(e);
    } catch (e) {
      _logger.e("Login response Exception: $e");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login({
    required LoginParams registerUserParams,
  }) async {
    try {
      final res = await _networkService.post(
        ApiConstants.login,
        body: registerUserParams.toJson(),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      _logger.i("Login response here: $res");

      final loginResponse = LoginResponse.fromJson(res.data!);

      if (loginResponse.status == true) {
        _logger.i("Login response: $loginResponse");
        return Right(loginResponse);
      } else {
        _logger.e("Login failed: ${loginResponse.message}");
        return Left(Failure(loginResponse.message));
      }
    } on Failure catch (e) {
      _logger.e("Login response Failure: $e");
      return Left(e);
    } catch (e) {
      _logger.e("Login response Exception: $e");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required VerifyOtpParams verifyOtpParams,
  }) async {
    try {
      final res = await _networkService.post(
        ApiConstants.verifyOtp,
        body: verifyOtpParams.toJson(),
      );

      if (res.status == "success") {
        _logger.i("Verify OTP response: $res");

        _logger.i("Token is: ${res.data!["token"]}");

        await _localStorageService.write(
          boxName: HiveBoxNames.userBox,
          key: HiveStorageKeys.token,
          value: res.data!["token"],
        );

        return Right(res.message ?? "Success");
      } else {
        return Left(Failure(res.message ?? "An error occurred"));
      }
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
