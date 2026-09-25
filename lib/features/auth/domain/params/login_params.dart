class LoginParams {
  final String email;
  final String password;
  final String? fcmToken;

  LoginParams({required this.email, required this.password, this.fcmToken});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'fcm_token': fcmToken};
  }
}
