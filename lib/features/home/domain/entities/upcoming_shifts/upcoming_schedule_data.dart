import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_filter.dart';
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_pagination.dart'
    show UpcomingPagination;
import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_shift.dart';

class UpcomingScheduleData {
  final List<UpcomingShift> upcomingSchedule;
  final UpcomingFilters filters;
  final UpcomingPagination pagination;

  const UpcomingScheduleData({
    required this.upcomingSchedule,
    required this.filters,
    required this.pagination,
  });

  factory UpcomingScheduleData.fromJson(Map<String, dynamic> json) {
    return UpcomingScheduleData(
      upcomingSchedule: (json['upcoming_schedule'] as List<dynamic>? ?? [])
          .map((e) => UpcomingShift.fromJson(e))
          .toList(),
      filters: UpcomingFilters.fromJson(json['filters'] ?? {}),
      pagination: UpcomingPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
