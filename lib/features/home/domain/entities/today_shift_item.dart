class TodayShiftItem {
  final int id;
  final String shiftDate;
  final String startTime;
  final String endTime;
  final String formattedStartTime;
  final String formattedEndTime;
  final String breakType;
  final int breakDurationMins;
  final String notes;
  final String status;
  final int employeeId;
  final int branchId;
  final String branchName;
  final int companyId;
  final String companyName;
  final int workAreaId;
  final String workAreaName;

  const TodayShiftItem({
    required this.id,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.formattedStartTime,
    required this.formattedEndTime,
    required this.breakType,
    required this.breakDurationMins,
    required this.notes,
    required this.status,
    required this.employeeId,
    required this.branchId,
    required this.branchName,
    required this.companyId,
    required this.companyName,
    required this.workAreaId,
    required this.workAreaName,
  });

  factory TodayShiftItem.fromJson(Map<String, dynamic> json) {
    return TodayShiftItem(
      id: json['id'] ?? 0,
      shiftDate: json['shift_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      formattedStartTime: json['formatted_start_time'] ?? '',
      formattedEndTime: json['formatted_end_time'] ?? '',
      breakType: json['break_type'] ?? '',
      breakDurationMins: (json['break_duration_mins'] is int)
          ? json['break_duration_mins'] as int
          : int.tryParse('${json['break_duration_mins'] ?? 0}') ?? 0,
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      employeeId: json['employee_id'] ?? 0,
      branchId: json['branch_id'] ?? 0,
      branchName: json['branch_name'] ?? '',
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      workAreaId: json['work_area_id'] ?? 0,
      workAreaName: json['work_area_name'] ?? '',
    );
  }

  bool get isEmpty => id == 0;
}
