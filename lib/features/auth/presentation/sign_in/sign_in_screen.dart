import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/auth/presentation/sign_in/bloc/sign_in_bloc.dart';
import 'package:stock_control_master/features/auth/presentation/sign_in/bloc/sign_in_event.dart';
import 'package:stock_control_master/features/auth/presentation/sign_in/bloc/sign_in_state.dart';
import 'package:stock_control_master/shared/widgets/organisms/shared_sign_in_screen.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = '/sign-in';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc()..add(const LoadRememberedCredentialsEvent()),
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          final signInState = state is SignInInitial
              ? state
              : const SignInInitial();

          return SharedSignInScreen(
            appName: 'HR Master',
            initialEmail: signInState.rememberedEmail,
            initialPassword: signInState.rememberedPassword,
            rememberMe: signInState.rememberMe,
            onRememberMeChanged: (value) {
              context.read<SignInBloc>().add(RememberMeChangedEvent(value));
            },
            onSignUpPressed: () {
              context.read<SignInBloc>().add(const NavigateToSignUpEvent());
            },
            onForgotPasswordPressed: () {
              context.read<SignInBloc>().add(
                const ForgotPasswordPressedEvent(),
              );
            },
            onSignInPressed:
                ({required String email, required String password}) {
                  context.read<SignInBloc>().add(
                    SubmitSignInEvent(
                      email: email.trim(),
                      password: password.trim(),
                      context: context,
                    ),
                  );
                },
            onSignInWithGoogle: () {
              context.read<SignInBloc>().add(const SignInWithGoogleEvent());
            },
            onSignInWithFacebook: () {
              context.read<SignInBloc>().add(const SignInWithFacebookEvent());
            },
            onSignInWithApple: () {
              context.read<SignInBloc>().add(const SignInWithAppleEvent());
            },
          );
        },
      ),
    );
  }
}
