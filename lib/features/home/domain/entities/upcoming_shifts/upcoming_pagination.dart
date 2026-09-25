class UpcomingPagination {
  final int currentPage;
  final int perPage;
  final int totalPages;
  final int totalItems;

  const UpcomingPagination({
    required this.currentPage,
    required this.perPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory UpcomingPagination.fromJson(Map<String, dynamic> json) {
    return UpcomingPagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
    );
  }
}
