class RegisterUserParams {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? fcmToken;

  RegisterUserParams({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      'fcm_token': fcmToken,
    };
  }
}
