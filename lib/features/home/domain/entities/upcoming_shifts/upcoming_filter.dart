class UpcomingFilters {
  final String date;

  const UpcomingFilters({required this.date});

  factory UpcomingFilters.fromJson(Map<String, dynamic> json) {
    return UpcomingFilters(date: json['date'] ?? '');
  }
}
