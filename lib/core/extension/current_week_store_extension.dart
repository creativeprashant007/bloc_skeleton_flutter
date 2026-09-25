class ScheduleWeekStore {
  static String startDate = '';
  static String endDate = '';

  static void setWeek(DateTime focusedDate) {
    final weekStart = focusedDate.weekStartDate;
    final weekEnd = weekStart.add(const Duration(days: 6));

    startDate = weekStart.apiDateString;
    endDate = weekEnd.apiDateString;
  }

  static void clear() {
    startDate = '';
    endDate = '';
  }
}

extension ScheduleWeekDateExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime get weekStartDate {
    final date = dateOnly;
    return date.subtract(Duration(days: date.weekday - 1));
  }

  String get apiDateString {
    return '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }
}
