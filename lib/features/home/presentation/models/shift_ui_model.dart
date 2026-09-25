import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShiftUiModel {
  final String id;
  final int apiShiftId;
  final String title;
  final String location;
  final DateTime start;
  final DateTime end;
  final int breakMinutes;
  final bool isPublished;
  final String status;
  final LatLng? workLocation;

  const ShiftUiModel({
    required this.id,
    required this.apiShiftId,
    required this.title,
    required this.location,
    required this.start,
    required this.end,
    required this.breakMinutes,
    required this.isPublished,
    required this.status,
    this.workLocation,
  });

  Duration get duration => end.difference(start);

  Duration get timeUntilStart => start.difference(DateTime.now());

  Duration get remainingDuration => end.difference(DateTime.now());

  bool get isScheduledShift => apiShiftId > 0;

  String get timeRangeLabel {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(start.hour)}:${two(start.minute)} - ${two(end.hour)}:${two(end.minute)}';
  }
}
