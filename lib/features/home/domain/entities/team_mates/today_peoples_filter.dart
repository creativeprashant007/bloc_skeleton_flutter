class TodayPeopleFilters {
  final String date;

  const TodayPeopleFilters({required this.date});

  factory TodayPeopleFilters.fromJson(Map<String, dynamic> json) {
    return TodayPeopleFilters(
      date: json['date'] ?? '',
    );
  }
}