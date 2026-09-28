import 'package:equatable/equatable.dart' show Equatable;

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

final class SignInInitial extends SignInState {
  final String rememberedEmail;
  final String rememberedPassword;
  final bool rememberMe;

  const SignInInitial({
    this.rememberedEmail = '',
    this.rememberedPassword = '',
    this.rememberMe = true,
  });

  SignInInitial copyWith({
    String? rememberedEmail,
    String? rememberedPassword,
    bool? rememberMe,
  }) {
    return SignInInitial(
      rememberedEmail: rememberedEmail ?? this.rememberedEmail,
      rememberedPassword: rememberedPassword ?? this.rememberedPassword,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [rememberedEmail, rememberedPassword, rememberMe];
}
