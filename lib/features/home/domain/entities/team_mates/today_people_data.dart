import 'package:stock_control_master/features/home/domain/entities/team_mates/today_peoples_filter.dart'
    show TodayPeopleFilters;
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_team_mates.dart'
    show TodayTeammate;

import 'today_people_pagination.dart' show TodayPeoplePagination;

class TodayPeopleData {
  final List<TodayTeammate> items;
  final TodayPeopleFilters filters;
  final TodayPeoplePagination pagination;

  const TodayPeopleData({
    required this.items,
    required this.filters,
    required this.pagination,
  });

  factory TodayPeopleData.fromJson(Map<String, dynamic> json) {
    return TodayPeopleData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => TodayTeammate.fromJson(e))
          .toList(),
      filters: TodayPeopleFilters.fromJson(json['filters'] ?? {}),
      pagination: TodayPeoplePagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
