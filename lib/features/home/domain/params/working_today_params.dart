class WorkingPeopleTodayParams {
  final int page;

  const WorkingPeopleTodayParams({required this.page});

  Map<String, dynamic> toQuery() {
    return {'page': page.toString()};
  }

  String toQueryString() {
    final query = toQuery();

    return query.entries
        .map(
          (entry) =>
              '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value.toString())}',
        )
        .join('&');
  }

  WorkingPeopleTodayParams copyWith({int? page}) {
    return WorkingPeopleTodayParams(page: page ?? this.page);
  }
}
