class UpcomingShift {
  final int id;
  final int shiftVersionId;

  final String date;
  final String startTime;
  final String endTime;

  final String breakType;
  final int breakDurationMins;
  final String breakStartTime;
  final String breakEndTime;
  final String breakLabel;

  final int shiftDurationMins;
  final String shiftDuration;

  final String workAreaName;
  final String branchName;
  final String companyName;

  final String status;

  const UpcomingShift({
    required this.id,
    required this.shiftVersionId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.breakType,
    required this.breakDurationMins,
    required this.breakStartTime,
    required this.breakEndTime,
    required this.breakLabel,
    required this.shiftDurationMins,
    required this.shiftDuration,
    required this.workAreaName,
    required this.branchName,
    required this.companyName,
    required this.status,
  });

  factory UpcomingShift.fromJson(Map<String, dynamic> json) {
    return UpcomingShift(
      id: _toInt(json['id']),
      shiftVersionId: _toInt(json['shift_version_id']),
      date: json['date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      breakType: json['break_type']?.toString() ?? '',
      breakDurationMins: _toInt(json['break_duration_mins']),
      breakStartTime: json['break_start_time']?.toString() ?? '',
      breakEndTime: json['break_end_time']?.toString() ?? '',
      breakLabel: json['break_label']?.toString() ?? '',
      shiftDurationMins: _toInt(json['shift_duration_mins']),
      shiftDuration: json['shift_duration']?.toString() ?? '',
      workAreaName: json['work_area_name']?.toString() ?? '',
      branchName: json['branch_name']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shift_version_id': shiftVersionId,
      'date': date,
      'break_type': breakType,
      'break_duration_mins': breakDurationMins,
      'break_start_time': breakStartTime,
      'break_end_time': breakEndTime,
      'break_label': breakLabel,
      'start_time': startTime,
      'end_time': endTime,
      'shift_duration_mins': shiftDurationMins,
      'shift_duration': shiftDuration,
      'work_area_name': workAreaName,
      'branch_name': branchName,
      'company_name': companyName,
      'status': status,
    };
  }

  String get shiftTime => '$startTime - $endTime';

  String get displayLocation {
    final workArea = workAreaName.trim();
    final branch = branchName.trim();

    if (workArea.isEmpty && branch.isEmpty) return '';
    if (workArea.isEmpty) return branch;
    if (branch.isEmpty) return workArea;

    return '$workArea • $branch';
  }

  String get fullCompanyInfo {
    final company = companyName.trim();
    final branch = branchName.trim();

    if (company.isEmpty && branch.isEmpty) return '';
    if (company.isEmpty) return branch;
    if (branch.isEmpty) return company;

    return '$company • $branch';
  }

  String get breakInfo {
    if (breakLabel.trim().isNotEmpty) return breakLabel;
    if (breakDurationMins <= 0) return 'No break';
    return '$breakDurationMins mins';
  }

  String get displayDuration {
    if (shiftDuration.trim().isNotEmpty) return shiftDuration;
    if (shiftDurationMins <= 0) return '';
    return _formatMinutes(shiftDurationMins);
  }

  bool get isUpcoming => status.toLowerCase().trim() == 'upcoming';

  bool get hasBreak => breakDurationMins > 0;

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _formatMinutes(int minutes) {
    if (minutes <= 0) return '0m';

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0 && mins > 0) return '${hours}h ${mins}m';
    if (hours > 0) return '${hours}h';
    return '${mins}m';
  }
}
