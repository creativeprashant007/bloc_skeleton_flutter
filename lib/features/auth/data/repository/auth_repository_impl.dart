import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart'
    show LoginResponse;
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/auth/data/data_sources/remote_data_source/auth_remote_data_source.dart'
    show AuthRemoteDataSource;
import 'package:stock_control_master/features/auth/domain/params/login_params.dart'
    show LoginParams;
import 'package:stock_control_master/features/auth/domain/params/register_user_params.dart'
    show RegisterUserParams;
import 'package:stock_control_master/features/auth/domain/params/verify_otp_params.dart'
    show VerifyOtpParams;
import 'package:stock_control_master/features/auth/domain/repository/auth_repository.dart'
    show AuthRepository;
import 'package:stock_control_master/shared/failure.dart' show Failure;

class AuthRepositoryImpl implements AuthRepository {
  final _remoteDataSource = locator<AuthRemoteDataSource>();
  @override
  Future<Either<Failure, LoginResponse>> register({
    required RegisterUserParams registerUserParams,
  }) {
    return _remoteDataSource.register(registerUserParams: registerUserParams);
  }

  @override
  Future<Either<Failure, LoginResponse>> login({required LoginParams params}) {
    return _remoteDataSource.login(registerUserParams: params);
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required VerifyOtpParams verifyOtpParams,
  }) {
    return _remoteDataSource.verifyOtp(verifyOtpParams: verifyOtpParams);
  }
}
