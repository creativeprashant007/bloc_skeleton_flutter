import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

final class LoadRememberedCredentialsEvent extends SignInEvent {
  const LoadRememberedCredentialsEvent();
}

final class RememberMeChangedEvent extends SignInEvent {
  final bool value;

  const RememberMeChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class NavigateToSignUpEvent extends SignInEvent {
  const NavigateToSignUpEvent();
}

final class ForgotPasswordPressedEvent extends SignInEvent {
  const ForgotPasswordPressedEvent();
}

final class SubmitSignInEvent extends SignInEvent {
  final String email;
  final String password;
  final BuildContext context;

  const SubmitSignInEvent({
    required this.email,
    required this.password,
    required this.context,
  });

  @override
  List<Object?> get props => [email, password, context];
}

final class SignInWithGoogleEvent extends SignInEvent {
  const SignInWithGoogleEvent();
}

final class SignInWithFacebookEvent extends SignInEvent {
  const SignInWithFacebookEvent();
}

final class SignInWithAppleEvent extends SignInEvent {
  const SignInWithAppleEvent();
}
