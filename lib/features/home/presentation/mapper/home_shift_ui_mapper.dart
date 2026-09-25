import 'package:intl/intl.dart';

import 'package:stock_control_master/features/home/domain/entities/today_shift_data.dart'
    show ActiveSessionEntity;
import 'package:stock_control_master/features/home/domain/entities/today_shift_item.dart'
    show TodayShiftItem;
import 'package:stock_control_master/features/home/presentation/models/shift_ui_model.dart';

class HomeShiftUiMapper {
  static ShiftUiModel? mapShift(TodayShiftItem? item) {
    if (item == null || item.isEmpty) return null;

    final date = DateTime.tryParse(item.shiftDate);
    if (date == null) return null;

    final start = _combineDateTime(date, item.startTime);
    final end = _combineDateTime(date, item.endTime);

    return ShiftUiModel(
      id: item.id.toString(),
      title: item.workAreaName,
      location: item.branchName,
      start: start,
      end: end,
      breakMinutes: item.breakDurationMins,
      isPublished: item.status.toLowerCase() == 'published',
      status: item.status,
      apiShiftId: item.id,
    );
  }

  static DateTime? mapStartedAt(ActiveSessionEntity? session) {
    if (session == null || session.startedAt.trim().isEmpty) return null;
    return DateTime.tryParse(session.startedAt)?.toLocal();
  }

  static DateTime _combineDateTime(DateTime date, String time) {
    final parsed = DateFormat('HH:mm:ss').parse(time);
    return DateTime(
      date.year,
      date.month,
      date.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
    );
  }
}
