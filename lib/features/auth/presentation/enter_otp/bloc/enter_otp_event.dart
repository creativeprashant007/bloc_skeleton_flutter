part of 'enter_otp_bloc.dart';

sealed class EnterOtpEvent extends Equatable {
  const EnterOtpEvent();

  @override
  List<Object> get props => [];
}

final class SubmitOtpEvent extends EnterOtpEvent {
  final String otp;
  final String email;

  const SubmitOtpEvent(this.otp, this.email);

  @override
  List<Object> get props => [otp, email];
}

final class ResendOtpEvent extends EnterOtpEvent {
  
}


final class NotYouEvent extends EnterOtpEvent {

}


