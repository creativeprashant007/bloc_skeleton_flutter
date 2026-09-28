import 'package:stock_control_master/features/auth/presentation/bloc/enter_otp/enter_otp_bloc.dart'
    show EnterOtpBloc, NotYouEvent, SubmitOtpEvent, ResendOtpEvent;
import 'package:stock_control_master/features/auth/presentation/widgets/shared_enter_pin_screen.dart'
    show SharedEnterPinScreen;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterOtpScreen extends StatelessWidget {
  static const routeName = '/enter-otp';
  const EnterOtpScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return SharedEnterPinScreen(
      onNotYou: () {
        context.read<EnterOtpBloc>().add(NotYouEvent());
      },
      onPinEntered: (otp) {
        context.read<EnterOtpBloc>().add(SubmitOtpEvent(otp, email));
      },
      email: email,
      onResendCode: () {
        context.read<EnterOtpBloc>().add(ResendOtpEvent());
      },
    );
  }
}
