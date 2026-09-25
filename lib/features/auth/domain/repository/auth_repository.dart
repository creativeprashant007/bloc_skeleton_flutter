import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/auth/domain/entities/login_response.dart'
    show LoginResponse;
import 'package:stock_control_master/features/auth/domain/params/login_params.dart'
    show LoginParams;
import 'package:stock_control_master/features/auth/domain/params/register_user_params.dart'
    show RegisterUserParams;
import 'package:stock_control_master/features/auth/domain/params/verify_otp_params.dart'
    show VerifyOtpParams;
import 'package:stock_control_master/shared/failure.dart' show Failure;

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> register({
    required RegisterUserParams registerUserParams,
  });
  Future<Either<Failure, LoginResponse>> login({required LoginParams params});
  Future<Either<Failure, String>> verifyOtp({
    required VerifyOtpParams verifyOtpParams,
  });
}
