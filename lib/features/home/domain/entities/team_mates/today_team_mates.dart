class TodayTeammate {
  final int id;
  final String name;
  final String email;

  final int branchId;
  final String branchName;

  final int shiftId;
  final String shiftDate;
  final String startTime;
  final String endTime;

  final int workAreaId;
  final String workAreaName;

  final int attendanceId;
  final String checkIn;
  final String checkOut;

  final String approvalStatus;
  final String status;

  /// NEW
  final String image;

  const TodayTeammate({
    required this.id,
    required this.name,
    required this.email,
    required this.branchId,
    required this.branchName,
    required this.shiftId,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.workAreaId,
    required this.workAreaName,
    required this.attendanceId,
    required this.checkIn,
    required this.checkOut,
    required this.approvalStatus,
    required this.status,
    required this.image,
  });

  factory TodayTeammate.fromJson(Map<String, dynamic> json) {
    return TodayTeammate(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      branchId: json['branch_id'] ?? 0,
      branchName: json['branch_name']?.toString() ?? '',
      shiftId: json['shift_id'] ?? 0,
      shiftDate: json['shift_date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      workAreaId: json['work_area_id'] ?? 0,
      workAreaName: json['work_area_name']?.toString() ?? '',
      attendanceId: json['attendance_id'] ?? 0,
      checkIn: json['check_in']?.toString() ?? '',
      checkOut: json['check_out']?.toString() ?? '',
      approvalStatus: json['approval_status']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  ///  Helpful computed states
  bool get isLate => status.toLowerCase() == 'late';

  bool get isOnShift => status.toLowerCase() == 'shift_on';

  bool get hasCheckedIn => checkIn.trim().isNotEmpty;

  bool get hasCheckedOut => checkOut.trim().isNotEmpty;

  bool get hasImage => image.trim().isNotEmpty;

  bool get isApproved => approvalStatus.toLowerCase() == 'approved';
}
