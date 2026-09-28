import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:stock_control_master/features/auth/presentation/widgets/shared_sign_up_screen.dart'
    show SharedSignUpScreen;

class SignUpScreen extends StatelessWidget {
  static const String routeName = '/sign-up';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedSignUpScreen(
      appName: 'FaitShift',
      onSignInPressed: () {
        context.read<SignUpBloc>().add(const NavigateToSignInEvent());
      },
      onSignUpPressed:
          ({required email, required password, required passwordConfirmation}) {
            context.read<SignUpBloc>().add(
              SubmitSignUpEvent(
                email: email,
                context: context,
                password: password,
                passwordConfirmation: passwordConfirmation,
              ),
            );
          },
      onSignInWithApple: () {
        context.read<SignUpBloc>().add(const SignInWithAppleEvent());
      },
      onSignInWithFacebook: () {
        context.read<SignUpBloc>().add(const SignInWithFacebookEvent());
      },
      onSignInWithGoogle: () {
        context.read<SignUpBloc>().add(const SignInWithGoogleEvent());
      },
    );
  }
}
