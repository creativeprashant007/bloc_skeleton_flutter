import 'package:stock_control_master/features/home/domain/entities/today_shift_data.dart';

class TodayShiftResponse {
  final bool success;
  final String message;
  final TodayShiftData data;

  const TodayShiftResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TodayShiftResponse.fromJson(Map<String, dynamic> json) {
    return TodayShiftResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TodayShiftData.fromJson(
        (json['data'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}
