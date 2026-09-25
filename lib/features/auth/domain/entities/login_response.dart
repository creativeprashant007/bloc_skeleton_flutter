import 'package:stock_control_master/features/auth/domain/entities/user_data.dart'
    show UserData;

class LoginResponse {
  final bool status;
  final String message;
  final String? token;
  final UserData? user;

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      token: json['token'] as String?,
      user: (json['data'] != null && json['data'] is Map<String, dynamic>)
          ? UserData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
