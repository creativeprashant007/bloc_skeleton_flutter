class ShiftActionParams {
  final double latitude;
  final double longitude;
  final int? shiftId;
  final int? workAreaId;
  final String? breakId;
  final String? comment;

  const ShiftActionParams({
    required this.latitude,
    required this.longitude,
    this.shiftId,
    this.workAreaId,
    this.breakId,
    this.comment,
  });

  Map<String, dynamic> toFormData() {
    final map = <String, dynamic>{
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    if (shiftId != null) {
      map['shift_id'] = shiftId.toString();
    }

    if (workAreaId != null) {
      map['work_area_id'] = workAreaId.toString();
    }

    if (breakId != null && breakId!.isNotEmpty) {
      map['break_id'] = breakId;
    }
    if (comment != null && comment!.isNotEmpty) {
      map['comment'] = comment;
    }

    return map;
  }
}
