import 'package:dartz/dartz.dart';
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/auth/domain/params/verify_otp_params.dart'
    show VerifyOtpParams;
import 'package:stock_control_master/features/auth/domain/repository/auth_repository.dart'
    show AuthRepository;
import 'package:stock_control_master/shared/failure.dart' show Failure;
import 'package:stock_control_master/shared/usecase.dart' show UseCases;

class VerifyOtpUsecase with UseCases<String, VerifyOtpParams> {
  final _repository = locator<AuthRepository>();
  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(verifyOtpParams: params);
  }
}
