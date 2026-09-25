class NotificationCountResponse {
  final bool status;
  final String message;
  final NotificationCountData data;

  NotificationCountResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationCountResponse.fromJson(Map<String, dynamic> json) {
    return NotificationCountResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: NotificationCountData.fromJson(json['data'] ?? {}),
    );
  }
}

class NotificationCountData {
  final int announcementUnreadCount;
  final int leaveUnreadCount;
  final int notificationUnreadCount;
  final int totalUnreadCount;

  NotificationCountData({
    required this.announcementUnreadCount,
    required this.leaveUnreadCount,
    required this.notificationUnreadCount,
    required this.totalUnreadCount,
  });

  factory NotificationCountData.fromJson(Map<String, dynamic> json) {
    return NotificationCountData(
      announcementUnreadCount: json['announcement_unread_count'] ?? 0,
      leaveUnreadCount: json['leave_unread_count'] ?? 0,
      notificationUnreadCount: json['notification_unread_count'] ?? 0,
      totalUnreadCount: json['total_unread_count'] ?? 0,
    );
  }
}
