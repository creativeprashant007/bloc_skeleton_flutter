class InviteUserResponse {
  final bool status;
  final String message;

  const InviteUserResponse({required this.status, required this.message});

  factory InviteUserResponse.fromJson(Map<String, dynamic> json) {
    return InviteUserResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}
