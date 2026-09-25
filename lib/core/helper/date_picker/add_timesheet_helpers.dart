// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:stock_control_master/features/home/domain/entities/upcoming_shifts/upcoming_shift.dart';
// import 'package:stock_control_master/features/user_documents/presentation/bloc/user_documents_state.dart';
// import 'package:stock_control_master/shared/widgets/atoms/weekly_schedule_card.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_control_master/features/schedule/create_shift/domain/entities/break_option_entity.dart'
//     show BreakType;
// import 'package:stock_control_master/features/time_sheets/presentation/bloc/timesheets_state.dart';

// String formatShortDate(DateTime? value) {
//   if (value == null) return 'Select';
//   return DateFormat('dd MMM yyyy').format(value);
// }

// String dateText(DateTime? date) {
//   if (date == null) return 'Not selected';
//   return DateFormat('dd MMM').format(date);
// }

// String formatTinyDate(DateTime? value) {
//   if (value == null) return '--';
//   return DateFormat('EEE, dd MMM').format(value);
// }

// String formatTime(DateTime? value) {
//   if (value == null) return 'Select';
//   return DateFormat('hh:mm a').format(value);
// }

// DateTime? startDateTime(TimesheetsState state) {
//   final date = state.addTimesheetDate;
//   final time = state.addTimesheetStartTime;

//   if (date == null || time == null) return null;

//   return DateTime(date.year, date.month, date.day, time.hour, time.minute);
// }

// DateTime? endDateTime(TimesheetsState state) {
//   final date = state.addTimesheetEndDate ?? state.addTimesheetDate;
//   final time = state.addTimesheetEndTime;

//   if (date == null || time == null) return null;

//   return DateTime(date.year, date.month, date.day, time.hour, time.minute);
// }

// int durationMinutes(TimesheetsState state) {
//   final start = startDateTime(state);
//   final end = endDateTime(state);

//   if (start == null || end == null) return 0;

//   final minutes = end.difference(start).inMinutes;
//   return minutes > 0 ? minutes : 0;
// }

// String formatMinutes(int minutes) {
//   if (minutes <= 0) return '0m';

//   final hours = minutes ~/ 60;
//   final mins = minutes % 60;

//   if (hours > 0 && mins > 0) return '${hours}h ${mins}m';
//   if (hours > 0) return '${hours}h';
//   return '${mins}m';
// }

// String formatDate(DateTime? value) {
//   if (value == null) return 'Select date';

//   return DateFormat('EEE, dd MMM').format(value);
// }

// DateTime initialExpiryDateDocument(UserDocument doc, String expiryDate) {
//   final text = expiryDate.trim().isNotEmpty
//       ? expiryDate.trim()
//       : doc.expiryDate.trim();

//   if (text.isNotEmpty) {
//     final parsed = DateTime.tryParse(text);
//     if (parsed != null) return parsed;
//   }

//   return DateTime.now();
// }

// String formatDateDocument(DateTime date) {
//   final month = date.month.toString().padLeft(2, '0');
//   final day = date.day.toString().padLeft(2, '0');
//   return '${date.year}-$month-$day';
// }

// String formatForBloc(DateTime? value) {
//   if (value == null) return '';

//   return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(value);
// }

// int totalMinutes(DateTime? startDateTime, DateTime? endDateTime) {
//   final start = startDateTime;
//   final end = endDateTime;

//   if (start == null || end == null) return 0;

//   final minutes = end.difference(start).inMinutes;

//   return minutes > 0 ? minutes : 0;
// }

// void autoFixOvernightIfNeeded(DateTime? startDateTime, DateTime? endDateTime) {
//   final start = startDateTime;
//   final end = endDateTime;

//   if (start == null || end == null) return;

//   if (!end.isAfter(start)) {
//     endDateTime = end.add(const Duration(days: 1));
//   }
// }

// bool hasTimezoneOffset(String value) {
//   final trimmed = value.trim();

//   if (trimmed.endsWith('Z')) return true;

//   return RegExp(r'([+-]\d{2}:?\d{2})$').hasMatch(trimmed);
// }

// DateTime dateOnly(DateTime value) {
//   return DateTime(value.year, value.month, value.day);
// }

// bool isOvernights(DateTime? startDateTime, DateTime? endDateTime) {
//   final start = startDateTime;
//   final end = endDateTime;

//   if (start == null || end == null) return false;

//   return dateOnly(start) != dateOnly(end);
// }

// String durationLabels(DateTime? startDateTime, DateTime? endDateTime) {
//   final start = startDateTime;
//   final end = endDateTime;
//   if (start == null || end == null) return 'Select both';

//   final minutes = totalMinutes(start, end);

//   if (minutes <= 0) return 'Invalid';
//   return formatMinutes(minutes);
// }

// String durationLabel(TimesheetsState state) {
//   final start = startDateTime(state);
//   final end = endDateTime(state);

//   if (start == null || end == null) return 'Select start and end time';

//   final minutes = durationMinutes(state);
//   if (minutes <= 0) return 'Invalid time range';

//   return formatMinutes(minutes);
// }

// String breakTypeLabel(BreakType type) {
//   switch (type) {
//     case BreakType.noBreak:
//       return 'No break';
//     case BreakType.fixed:
//       return 'Fixed break';
//     case BreakType.duration:
//       return 'Custom break';
//   }
// }

// int breakMinutes(TimesheetsState state) {
//   switch (state.addTimesheetBreakType) {
//     case BreakType.noBreak:
//       return 0;

//     case BreakType.fixed:
//       return state.addTimesheetFixedBreakOption?.minute ?? 0;

//     case BreakType.duration:
//       final start = state.addTimesheetBreakStartTime;
//       final end = state.addTimesheetBreakEndTime;

//       if (start == null || end == null) return 0;

//       final minutes = end.difference(start).inMinutes;
//       return minutes > 0 ? minutes : 0;
//   }
// }

// String paidDurationLabel(TimesheetsState state) {
//   final total = durationMinutes(state);

//   if (total <= 0) return 'Select valid time';

//   final paid = total - breakMinutes(state);
//   if (paid <= 0) return '0m';

//   return formatMinutes(paid);
// }

// String breakSummary(TimesheetsState state) {
//   switch (state.addTimesheetBreakType) {
//     case BreakType.noBreak:
//       return 'No unpaid break';

//     case BreakType.fixed:
//       return state.addTimesheetFixedBreakOption?.label ?? 'Select fixed break';

//     case BreakType.duration:
//       final start = state.addTimesheetBreakStartTime;
//       final end = state.addTimesheetBreakEndTime;

//       if (start == null || end == null) {
//         return 'Select break start and end';
//       }

//       final mins = breakMinutes(state);
//       if (mins <= 0) return 'Invalid break time';

//       return '${formatTime(start)} - ${formatTime(end)} • ${formatMinutes(mins)}';
//   }
// }

// bool isMultiDay(TimesheetsState state) {
//   final startDate = state.addTimesheetDate;
//   final endDate = state.addTimesheetEndDate;

//   if (startDate == null || endDate == null) return false;

//   return startDate.dateOnly != endDate.dateOnly;
// }

// bool hasInvalidTimesheetTime(TimesheetsState state) {
//   final start = startDateTime(state);
//   final end = endDateTime(state);

//   if (start == null || end == null) return false;

//   return !end.isAfter(start);
// }

// bool hasInvalidBreakTime(TimesheetsState state) {
//   if (state.addTimesheetBreakType != BreakType.duration) return false;

//   final start = state.addTimesheetBreakStartTime;
//   final end = state.addTimesheetBreakEndTime;

//   if (start == null || end == null) return false;

//   return !end.isAfter(start);
// }

// bool isBreakOutsideTimesheet(TimesheetsState state) {
//   if (state.addTimesheetBreakType != BreakType.duration) return false;

//   final timesheetStart = startDateTime(state);
//   final timesheetEnd = endDateTime(state);
//   final breakStart = state.addTimesheetBreakStartTime;
//   final breakEnd = state.addTimesheetBreakEndTime;

//   if (timesheetStart == null ||
//       timesheetEnd == null ||
//       breakStart == null ||
//       breakEnd == null) {
//     return false;
//   }

//   return breakStart.isBefore(timesheetStart) || breakEnd.isAfter(timesheetEnd);
// }

// String breakLabel(UpcomingShift shift) {
//   final label = shift.breakLabel.trim();

//   if (label.isNotEmpty) return label;

//   if (shift.breakDurationMins <= 0) return 'No break';

//   return '${shift.breakDurationMins} mins';
// }

// DateTime? _parseTime(String date, String time) {
//   final parsedDate = DateTime.tryParse(date);
//   if (parsedDate == null || time.trim().isEmpty) return null;

//   final normalized = time.trim().toUpperCase();
//   final parts = normalized.split(RegExp(r'\s+'));
//   final hm = parts.first.split(':');

//   if (hm.isEmpty) return null;

//   var hour = int.tryParse(hm[0]) ?? 0;
//   final minute = hm.length > 1 ? int.tryParse(hm[1]) ?? 0 : 0;
//   final meridiem = parts.length > 1 ? parts[1] : '';

//   if (meridiem == 'PM' && hour != 12) hour += 12;
//   if (meridiem == 'AM' && hour == 12) hour = 0;

//   return DateTime(
//     parsedDate.year,
//     parsedDate.month,
//     parsedDate.day,
//     hour,
//     minute,
//   );
// }

// int _workedMinutes(UpcomingShift shift) {
//   final start = _parseTime(shift.date, shift.startTime);
//   final end = _parseTime(shift.date, shift.endTime);

//   if (start == null || end == null) return 0;

//   var fixedEnd = end;

//   if (!fixedEnd.isAfter(start)) {
//     fixedEnd = fixedEnd.add(const Duration(days: 1));
//   }

//   final minutes = fixedEnd.difference(start).inMinutes;

//   if (minutes <= 0) return 0;

//   return minutes.clamp(0, 24 * 60);
// }

// String paidDurationLabelV1(UpcomingShift shift) {
//   final duration = shift.shiftDuration.trim();

//   if (duration.isNotEmpty) return duration;

//   if (shift.shiftDurationMins > 0) {
//     return formatMinutes(shift.shiftDurationMins);
//   }

//   final workedMinutes = _workedMinutes(shift);
//   final paidMinutes = workedMinutes - shift.breakDurationMins;

//   return formatMinutes(paidMinutes > 0 ? paidMinutes : workedMinutes);
// }

// String weekday(int day) {
//   const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//   return days[day - 1];
// }

// String month(int month) {
//   const months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];
//   return months[month - 1];
// }

// String formatTimeNextShift(BuildContext context, DateTime value) {
//   return TimeOfDay.fromDateTime(value).format(context);
// }

// String formatDateNextShift(DateTime value) {
//   const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//   const months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];

//   return '${days[value.weekday - 1]}, ${value.day} ${months[value.month - 1]}';
// }

// List<WeekShiftGroup> groupByWeek(List<UpcomingShift> shifts) {
//   final grouped = <DateTime, List<UpcomingShift>>{};

//   for (final shift in shifts) {
//     final date = DateTime.tryParse(shift.date);
//     if (date == null) continue;

//     final weekStart = DateTime(
//       date.year,
//       date.month,
//       date.day,
//     ).subtract(Duration(days: date.weekday - 1));

//     grouped.putIfAbsent(weekStart, () => []);
//     grouped[weekStart]!.add(shift);
//   }

//   final groups = grouped.entries.map((entry) {
//     final sorted = [...entry.value]..sort((a, b) => a.date.compareTo(b.date));
//     return WeekShiftGroup(weekStart: entry.key, shifts: sorted);
//   }).toList();

//   groups.sort((a, b) => a.weekStart.compareTo(b.weekStart));
//   return groups;
// }
