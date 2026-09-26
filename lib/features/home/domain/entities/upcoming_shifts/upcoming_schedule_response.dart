import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_schedule_data.dart';

class UpcomingScheduleResponse {
  final bool success;
  final String message;
  final UpcomingScheduleData data;

  const UpcomingScheduleResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpcomingScheduleResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingScheduleResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UpcomingScheduleData.fromJson(json['data'] ?? {}),
    );
  }
}
