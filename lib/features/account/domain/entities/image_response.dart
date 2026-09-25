class ProfileImageResponse {
  final bool status;
  final String message;
  final String image;

  ProfileImageResponse({
    required this.status,
    required this.message,
    required this.image,
  });

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) {
    return ProfileImageResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'image': image};
  }
}
