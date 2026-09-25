part of 'enter_otp_bloc.dart';

sealed class EnterOtpState extends Equatable {
  const EnterOtpState();
  
  @override
  List<Object> get props => [];
}

final class EnterOtpInitial extends EnterOtpState {}
