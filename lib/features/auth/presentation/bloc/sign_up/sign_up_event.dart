part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class NavigateToSignInEvent extends SignUpEvent {
  const NavigateToSignInEvent();
}

final class SubmitSignUpEvent extends SignUpEvent {
  final String email;
  final String password;
  final String passwordConfirmation;
  final BuildContext context;

  const SubmitSignUpEvent({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.context,
  });

  @override
  List<Object> get props => [email, password, passwordConfirmation, context];
}

final class SignInWithGoogleEvent extends SignUpEvent {
  const SignInWithGoogleEvent();
}

final class SignInWithFacebookEvent extends SignUpEvent {
  const SignInWithFacebookEvent();
}

final class SignInWithAppleEvent extends SignUpEvent {
  const SignInWithAppleEvent();
}
