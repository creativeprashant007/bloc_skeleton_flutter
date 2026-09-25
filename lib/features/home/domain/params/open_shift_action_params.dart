class OpenShiftActionParams {
  final double latitude;
  final double longitude;
  final int workAreaId;

  const OpenShiftActionParams({
    required this.latitude,
    required this.longitude,
    required this.workAreaId,
  });

  Map<String, dynamic> toFormData() {
    return {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'work_area_id': workAreaId.toString(),
    };
  }
}
