import 'package:stock_control_master/features/home/domain/entities/team_mates/today_people_data.dart'
    show TodayPeopleData;

class TodayPeopleResponse {
  final bool success;
  final String message;
  final TodayPeopleData data;

  const TodayPeopleResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TodayPeopleResponse.fromJson(Map<String, dynamic> json) {
    return TodayPeopleResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TodayPeopleData.fromJson(json['data'] ?? {}),
    );
  }
}
