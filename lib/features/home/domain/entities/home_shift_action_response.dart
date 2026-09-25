class ShiftActionResponse {
  final bool success;
  final String message;

  const ShiftActionResponse({required this.success, required this.message});

  factory ShiftActionResponse.fromJson(Map<String, dynamic> json) {
    return ShiftActionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
