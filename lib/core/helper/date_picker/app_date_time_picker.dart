import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class AppDateTimePicker {
  const AppDateTimePicker._();

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime _mergeDateAndTime({
    required DateTime date,
    required DateTime time,
  }) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static DateTime _startOfWeek(DateTime date) {
    final clean = _dateOnly(date);
    return clean.subtract(Duration(days: clean.weekday - 1));
  }

  static DateTime _endOfWeek(DateTime date) {
    return _startOfWeek(date).add(const Duration(days: 6));
  }

  static List<DateTime> _weekDays(DateTime date) {
    final start = _startOfWeek(date);
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool _isDisabledDate({
    required DateTime date,
    required DateTime minDate,
    required DateTime maxDate,
  }) {
    final clean = _dateOnly(date);
    return clean.isBefore(_dateOnly(minDate)) ||
        clean.isAfter(_dateOnly(maxDate));
  }

  static bool _canMoveToPreviousWeek({
    required DateTime focusedWeekDate,
    required DateTime minDate,
  }) {
    final previousWeekEnd = _endOfWeek(
      focusedWeekDate.subtract(const Duration(days: 7)),
    );

    return !previousWeekEnd.isBefore(_dateOnly(minDate));
  }

  static bool _canMoveToNextWeek({
    required DateTime focusedWeekDate,
    required DateTime maxDate,
  }) {
    final nextWeekStart = _startOfWeek(
      focusedWeekDate.add(const Duration(days: 7)),
    );

    return !nextWeekStart.isAfter(_dateOnly(maxDate));
  }

  static String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return names[month - 1];
  }

  static Future<DateTimeRange?> pickDateRange({
    required BuildContext context,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Select date range',
    bool disablePastDates = true,
  }) async {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final minDate = disablePastDates
        ? today
        : firstDate ?? DateTime(now.year - 2, 1, 1);

    final maxDate = lastDate ?? DateTime(now.year + 5, 12, 31);

    DateTime start = _dateOnly(initialStartDate ?? today);
    DateTime end = _dateOnly(initialEndDate ?? start);

    if (start.isBefore(minDate)) start = minDate;
    if (start.isAfter(maxDate)) start = maxDate;
    if (end.isBefore(start)) end = start;
    if (end.isAfter(maxDate)) end = maxDate;

    final result = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .50),
      builder: (sheetContext) {
        DateTime tempStart = start;
        DateTime tempEnd = end;

        String rangeLabel() {
          if (_isSameDate(tempStart, tempEnd)) {
            return _selectedDateLabel(tempStart);
          }

          return '${_shortDateLabel(tempStart)} - ${_shortDateLabel(tempEnd)}';
        }

        int selectedDays() {
          final days = tempEnd.difference(tempStart).inDays + 1;
          return days <= 0 ? 0 : days;
        }

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              constraints: BoxConstraints(maxHeight: 0.92.sh),
              decoration: BoxDecoration(
                color: appColors.cardBackground,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: appColors.divider.withValues(
                    alpha: isDark ? .40 : .56,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .28 : .12),
                    blurRadius: 30.r,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 46.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: appColors.divider.withValues(alpha: .80),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: appColors.accent.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              Icons.date_range_rounded,
                              color: appColors.accent,
                              size: 23.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: appColors.primaryText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Select start and end date',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.secondaryText,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(14.r),
                            onTap: () => Navigator.pop(sheetContext),
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: appColors.pageBackground.withValues(
                                  alpha: isDark ? .45 : .80,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: appColors.divider.withValues(
                                    alpha: .35,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: appColors.secondaryText,
                                size: 21.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(13.w),
                        decoration: BoxDecoration(
                          color: appColors.accent.withValues(
                            alpha: isDark ? .13 : .08,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: appColors.accent.withValues(alpha: .16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: appColors.accent.withValues(alpha: .14),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Text(
                                '${selectedDays()}d',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: appColors.accent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                rangeLabel(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: appColors.primaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: appColors.pageBackground.withValues(
                              alpha: isDark ? .40 : .70,
                            ),
                            borderRadius: BorderRadius.circular(22.r),
                            border: Border.all(
                              color: appColors.divider.withValues(alpha: .36),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.r),
                            child: SfDateRangePicker(
                              view: DateRangePickerView.month,
                              selectionMode: DateRangePickerSelectionMode.range,
                              initialSelectedRange: PickerDateRange(
                                tempStart,
                                tempEnd,
                              ),
                              initialDisplayDate: tempStart,
                              minDate: minDate,
                              maxDate: maxDate,
                              showNavigationArrow: true,
                              headerHeight: 52.h,
                              todayHighlightColor: appColors.accent,
                              startRangeSelectionColor: appColors.accent,
                              endRangeSelectionColor: appColors.accent,
                              rangeSelectionColor: appColors.accent.withValues(
                                alpha: .18,
                              ),
                              backgroundColor: Colors.transparent,
                              selectionTextStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.sp,
                                  ),
                              headerStyle: DateRangePickerHeaderStyle(
                                backgroundColor: Colors.transparent,
                                textAlign: TextAlign.center,
                                textStyle: theme.textTheme.titleMedium
                                    ?.copyWith(
                                      color: appColors.primaryText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                              ),
                              monthViewSettings:
                                  DateRangePickerMonthViewSettings(
                                    firstDayOfWeek: 1,
                                    dayFormat: 'EEE',
                                    showTrailingAndLeadingDates: false,
                                    viewHeaderStyle:
                                        DateRangePickerViewHeaderStyle(
                                          textStyle: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: appColors.secondaryText,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11.sp,
                                              ),
                                        ),
                                  ),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                textStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: appColors.primaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                                todayTextStyle: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: appColors.accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.sp,
                                    ),
                                disabledDatesTextStyle: theme
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: appColors.secondaryText.withValues(
                                        alpha: .28,
                                      ),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp,
                                    ),
                              ),
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                    final value = args.value;

                                    if (value is PickerDateRange) {
                                      final startDate = value.startDate;
                                      final endDate =
                                          value.endDate ?? startDate;

                                      if (startDate == null ||
                                          endDate == null) {
                                        return;
                                      }

                                      setModalState(() {
                                        tempStart = _dateOnly(startDate);
                                        tempEnd = _dateOnly(endDate);

                                        if (tempEnd.isBefore(tempStart)) {
                                          tempEnd = tempStart;
                                        }
                                      });
                                    }
                                  },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44.h,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(sheetContext),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: appColors.divider.withValues(
                                      alpha: .75,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: SizedBox(
                              height: 44.h,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(
                                    sheetContext,
                                    DateTimeRange(
                                      start: _dateOnly(tempStart),
                                      end: _dateOnly(tempEnd),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.check_rounded, size: 18.sp),
                                label: Text(
                                  'Apply',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) return null;

    return DateTimeRange(
      start: _dateOnly(result.start),
      end: _dateOnly(result.end),
    );
  }

  static String _shortMonthName(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return names[month - 1];
  }

  static String _weekdayName(int weekday) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return names[weekday - 1];
  }

  static String _shortWeekdayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  static String _selectedDateLabel(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    return '${_weekdayName(date.weekday)}, $day ${_monthName(date.month)} ${date.year}';
  }

  static String _shortDateLabel(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  static String _weekRangeLabel(DateTime focusedWeekDate) {
    final start = _startOfWeek(focusedWeekDate);
    final end = _endOfWeek(focusedWeekDate);

    if (start.month == end.month && start.year == end.year) {
      return '${start.day} - ${end.day} ${_shortMonthName(start.month)} ${start.year}';
    }

    if (start.year == end.year) {
      return '${start.day} ${_shortMonthName(start.month)} - ${end.day} ${_shortMonthName(end.month)} ${start.year}';
    }

    return '${start.day} ${_shortMonthName(start.month)} ${start.year} - ${end.day} ${_shortMonthName(end.month)} ${end.year}';
  }

  static String _timeLabel(DateTime value, {bool is24HourMode = false}) {
    if (is24HourMode) {
      return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    }

    final period = value.hour >= 12 ? 'PM' : 'AM';
    var hour = value.hour % 12;
    if (hour == 0) hour = 12;

    return '${hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} $period';
  }

  static DateTime? _parseFlexibleTimeInput({
    required String input,
    required DateTime baseDate,
    required bool is24HourMode,
    required String fallbackPeriod,
  }) {
    var clean = input.trim().toLowerCase();

    if (clean.isEmpty) return null;

    clean = clean.replaceAll(' ', '').replaceAll('.', ':').replaceAll('-', ':');

    String? explicitPeriod;

    if (clean.endsWith('am')) {
      explicitPeriod = 'AM';
      clean = clean.substring(0, clean.length - 2);
    } else if (clean.endsWith('pm')) {
      explicitPeriod = 'PM';
      clean = clean.substring(0, clean.length - 2);
    } else if (clean.endsWith('a')) {
      explicitPeriod = 'AM';
      clean = clean.substring(0, clean.length - 1);
    } else if (clean.endsWith('p')) {
      explicitPeriod = 'PM';
      clean = clean.substring(0, clean.length - 1);
    }

    int? hour;
    int minute = 0;

    if (clean.contains(':')) {
      final parts = clean.split(':');
      if (parts.isEmpty || parts.length > 2) return null;

      hour = int.tryParse(parts[0]);

      if (parts.length == 2 && parts[1].isNotEmpty) {
        minute = int.tryParse(parts[1]) ?? -1;
      }
    } else {
      final digitsOnly = clean.replaceAll(RegExp(r'[^0-9]'), '');

      if (digitsOnly.isEmpty || digitsOnly.length > 4) return null;

      if (digitsOnly.length <= 2) {
        hour = int.tryParse(digitsOnly);
      } else if (digitsOnly.length == 3) {
        hour = int.tryParse(digitsOnly.substring(0, 1));
        minute = int.tryParse(digitsOnly.substring(1, 3)) ?? -1;
      } else {
        hour = int.tryParse(digitsOnly.substring(0, 2));
        minute = int.tryParse(digitsOnly.substring(2, 4)) ?? -1;
      }
    }

    if (hour == null || minute < 0 || minute > 59) return null;

    int finalHour;

    if (is24HourMode) {
      if (hour < 0 || hour > 23) return null;
      finalHour = hour;
    } else {
      if (explicitPeriod != null) {
        if (hour < 1 || hour > 12) return null;

        finalHour = hour % 12;

        if (explicitPeriod == 'PM') {
          finalHour += 12;
        }
      } else {
        if (hour < 0 || hour > 23) return null;

        if (hour > 12) {
          finalHour = hour;
        } else {
          finalHour = hour % 12;

          if (fallbackPeriod == 'PM') {
            finalHour += 12;
          }
        }
      }
    }

    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      finalHour,
      minute,
    );
  }

  static List<DateTime> _recommendedTimesFromInput({
    required String input,
    required DateTime baseDate,
    required bool is24HourMode,
  }) {
    final clean = input.trim().toLowerCase();

    if (clean.isEmpty) return const [];

    final hasPeriod =
        clean.contains('am') ||
        clean.contains('pm') ||
        clean.endsWith('a') ||
        clean.endsWith('p');

    final digits = clean.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty || digits.length > 4) return const [];

    int? rawHour;
    int minute = 0;

    if (clean.contains(':') || clean.contains('.') || clean.contains('-')) {
      final normalised = clean
          .replaceAll(' ', '')
          .replaceAll('.', ':')
          .replaceAll('-', ':')
          .replaceAll('am', '')
          .replaceAll('pm', '')
          .replaceAll('a', '')
          .replaceAll('p', '');

      final parts = normalised.split(':');
      if (parts.isEmpty) return const [];

      rawHour = int.tryParse(parts[0]);

      if (parts.length > 1 && parts[1].isNotEmpty) {
        minute = int.tryParse(parts[1]) ?? 0;
      }
    } else {
      if (digits.length <= 2) {
        rawHour = int.tryParse(digits);
      } else if (digits.length == 3) {
        rawHour = int.tryParse(digits.substring(0, 1));
        minute = int.tryParse(digits.substring(1, 3)) ?? 0;
      } else {
        rawHour = int.tryParse(digits.substring(0, 2));
        minute = int.tryParse(digits.substring(2, 4)) ?? 0;
      }
    }

    if (rawHour == null || minute < 0 || minute > 59) return const [];

    if (is24HourMode) {
      if (rawHour < 0 || rawHour > 23) return const [];

      return [
        DateTime(baseDate.year, baseDate.month, baseDate.day, rawHour, minute),
      ];
    }

    if (hasPeriod) {
      final parsed = _parseFlexibleTimeInput(
        input: input,
        baseDate: baseDate,
        is24HourMode: false,
        fallbackPeriod: 'AM',
      );

      if (parsed == null) return const [];
      return [parsed];
    }

    if (rawHour >= 13 && rawHour <= 23) {
      return [
        DateTime(baseDate.year, baseDate.month, baseDate.day, rawHour, minute),
      ];
    }

    if (rawHour < 1 || rawHour > 12) return const [];

    final amHour = rawHour % 12;
    final pmHour = amHour + 12;

    return [
      DateTime(baseDate.year, baseDate.month, baseDate.day, amHour, minute),
      DateTime(baseDate.year, baseDate.month, baseDate.day, pmHour, minute),
    ];
  }

  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Select date',
    bool disablePastDates = true,
  }) async {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final minDate = disablePastDates
        ? today
        : firstDate ?? DateTime(now.year - 2, 1, 1);

    final maxDate = lastDate ?? DateTime(now.year + 5, 12, 31);

    DateTime selectedDate = _dateOnly(initialDate ?? today);

    if (selectedDate.isBefore(minDate)) {
      selectedDate = minDate;
    }

    if (selectedDate.isAfter(maxDate)) {
      selectedDate = maxDate;
    }

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .50),
      builder: (sheetContext) {
        DateTime tempSelectedDate = selectedDate;
        DateTime focusedWeekDate = selectedDate;
        DateTime visibleMonthDate = selectedDate;
        bool showMonthView = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final selectedWeek = _weekDays(focusedWeekDate);
            final monthTitle =
                '${_monthName(visibleMonthDate.month)} ${visibleMonthDate.year}';

            final canPreviousWeek = _canMoveToPreviousWeek(
              focusedWeekDate: focusedWeekDate,
              minDate: minDate,
            );

            final canNextWeek = _canMoveToNextWeek(
              focusedWeekDate: focusedWeekDate,
              maxDate: maxDate,
            );

            return Container(
              margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              constraints: BoxConstraints(maxHeight: 0.92.sh),
              decoration: BoxDecoration(
                color: appColors.cardBackground,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: appColors.divider.withValues(
                    alpha: isDark ? .40 : .56,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .28 : .12),
                    blurRadius: 30.r,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 46.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: appColors.divider.withValues(alpha: .80),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: appColors.accent.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: appColors.accent,
                              size: 23.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: appColors.primaryText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  showMonthView
                                      ? 'Monthly calendar'
                                      : 'Weekly quick selection',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.secondaryText,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(14.r),
                            onTap: () => Navigator.pop(sheetContext),
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: appColors.pageBackground.withValues(
                                  alpha: isDark ? .45 : .80,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: appColors.divider.withValues(
                                    alpha: .35,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: appColors.secondaryText,
                                size: 21.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(13.w),
                        decoration: BoxDecoration(
                          color: appColors.accent.withValues(
                            alpha: isDark ? .13 : .08,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: appColors.accent.withValues(alpha: .16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: appColors.accent.withValues(alpha: .14),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Text(
                                tempSelectedDate.day.toString().padLeft(2, '0'),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: appColors.accent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedDateLabel(tempSelectedDate),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: appColors.primaryText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    _shortDateLabel(tempSelectedDate),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: appColors.secondaryText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: appColors.pageBackground.withValues(
                              alpha: isDark ? .40 : .70,
                            ),
                            borderRadius: BorderRadius.circular(22.r),
                            border: Border.all(
                              color: appColors.divider.withValues(alpha: .36),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  if (!showMonthView) ...[
                                    _CalendarIconButton(
                                      icon: Icons.chevron_left_rounded,
                                      enabled: canPreviousWeek,
                                      onTap: () {
                                        if (!canPreviousWeek) return;

                                        setModalState(() {
                                          focusedWeekDate = focusedWeekDate
                                              .subtract(
                                                const Duration(days: 7),
                                              );

                                          final weekStart = _startOfWeek(
                                            focusedWeekDate,
                                          );
                                          final weekEnd = _endOfWeek(
                                            focusedWeekDate,
                                          );

                                          if (tempSelectedDate.isBefore(
                                                weekStart,
                                              ) ||
                                              tempSelectedDate.isAfter(
                                                weekEnd,
                                              )) {
                                            final selectable =
                                                _weekDays(
                                                  focusedWeekDate,
                                                ).firstWhere(
                                                  (day) => !_isDisabledDate(
                                                    date: day,
                                                    minDate: minDate,
                                                    maxDate: maxDate,
                                                  ),
                                                  orElse: () =>
                                                      tempSelectedDate,
                                                );

                                            tempSelectedDate = selectable;
                                          }

                                          visibleMonthDate = focusedWeekDate;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                  Expanded(
                                    child: Text(
                                      showMonthView
                                          ? monthTitle
                                          : _weekRangeLabel(focusedWeekDate),
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: appColors.primaryText,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.sp,
                                          ),
                                    ),
                                  ),
                                  if (!showMonthView) ...[
                                    SizedBox(width: 8.w),
                                    _CalendarIconButton(
                                      icon: Icons.chevron_right_rounded,
                                      enabled: canNextWeek,
                                      onTap: () {
                                        if (!canNextWeek) return;

                                        setModalState(() {
                                          focusedWeekDate = focusedWeekDate.add(
                                            const Duration(days: 7),
                                          );

                                          final weekStart = _startOfWeek(
                                            focusedWeekDate,
                                          );
                                          final weekEnd = _endOfWeek(
                                            focusedWeekDate,
                                          );

                                          if (tempSelectedDate.isBefore(
                                                weekStart,
                                              ) ||
                                              tempSelectedDate.isAfter(
                                                weekEnd,
                                              )) {
                                            final selectable =
                                                _weekDays(
                                                  focusedWeekDate,
                                                ).firstWhere(
                                                  (day) => !_isDisabledDate(
                                                    date: day,
                                                    minDate: minDate,
                                                    maxDate: maxDate,
                                                  ),
                                                  orElse: () =>
                                                      tempSelectedDate,
                                                );

                                            tempSelectedDate = selectable;
                                          }

                                          visibleMonthDate = focusedWeekDate;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                  _CalendarModeButton(
                                    label: showMonthView ? 'Week' : 'Month',
                                    icon: showMonthView
                                        ? Icons.view_week_rounded
                                        : Icons.calendar_view_month_rounded,
                                    onTap: () {
                                      setModalState(() {
                                        showMonthView = !showMonthView;
                                        visibleMonthDate = tempSelectedDate;
                                        focusedWeekDate = tempSelectedDate;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              if (!showMonthView)
                                _WeekDateSelector(
                                  days: selectedWeek,
                                  selectedDate: tempSelectedDate,
                                  today: today,
                                  minDate: minDate,
                                  maxDate: maxDate,
                                  onSelected: (day) {
                                    setModalState(() {
                                      tempSelectedDate = _dateOnly(day);
                                      focusedWeekDate = tempSelectedDate;
                                      visibleMonthDate = tempSelectedDate;
                                    });
                                  },
                                )
                              else
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18.r),
                                    child: SfDateRangePicker(
                                      view: DateRangePickerView.month,
                                      selectionMode:
                                          DateRangePickerSelectionMode.single,
                                      initialSelectedDate: tempSelectedDate,
                                      initialDisplayDate: visibleMonthDate,
                                      minDate: minDate,
                                      maxDate: maxDate,
                                      showNavigationArrow: true,
                                      headerHeight: 52.h,
                                      todayHighlightColor: appColors.accent,
                                      selectionColor: appColors.accent,
                                      backgroundColor: Colors.transparent,
                                      selectionTextStyle: theme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.sp,
                                          ),
                                      headerStyle: DateRangePickerHeaderStyle(
                                        backgroundColor: Colors.transparent,
                                        textAlign: TextAlign.center,
                                        textStyle: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: appColors.primaryText,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16.sp,
                                            ),
                                      ),
                                      monthViewSettings:
                                          DateRangePickerMonthViewSettings(
                                            firstDayOfWeek: 1,
                                            dayFormat: 'EEE',
                                            showTrailingAndLeadingDates: false,
                                            viewHeaderStyle:
                                                DateRangePickerViewHeaderStyle(
                                                  textStyle: theme
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: appColors
                                                            .secondaryText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11.sp,
                                                      ),
                                                ),
                                          ),
                                      monthCellStyle:
                                          DateRangePickerMonthCellStyle(
                                            textStyle: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: appColors.primaryText,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.sp,
                                                ),
                                            todayTextStyle: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: appColors.accent,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.sp,
                                                ),
                                            disabledDatesTextStyle: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: appColors.secondaryText
                                                      .withValues(alpha: .28),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13.sp,
                                                ),
                                            blackoutDateTextStyle: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: appColors.secondaryText
                                                      .withValues(alpha: .22),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13.sp,
                                                ),
                                            weekendTextStyle: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: appColors.primaryText
                                                      .withValues(alpha: .84),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.sp,
                                                ),
                                          ),
                                      onViewChanged:
                                          (
                                            DateRangePickerViewChangedArgs args,
                                          ) {
                                            if (args
                                                    .visibleDateRange
                                                    .startDate !=
                                                null) {
                                              visibleMonthDate = args
                                                  .visibleDateRange
                                                  .startDate!;
                                            }
                                          },
                                      onSelectionChanged:
                                          (
                                            DateRangePickerSelectionChangedArgs
                                            args,
                                          ) {
                                            final value = args.value;

                                            if (value is DateTime) {
                                              final clean = _dateOnly(value);

                                              if (_isDisabledDate(
                                                date: clean,
                                                minDate: minDate,
                                                maxDate: maxDate,
                                              )) {
                                                return;
                                              }

                                              setModalState(() {
                                                tempSelectedDate = clean;
                                                visibleMonthDate = clean;
                                                focusedWeekDate = clean;
                                              });
                                            }
                                          },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44.h,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(sheetContext),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: appColors.divider.withValues(
                                      alpha: .75,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: SizedBox(
                              height: 44.h,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(sheetContext, tempSelectedDate);
                                },
                                icon: Icon(Icons.check_rounded, size: 18.sp),
                                label: Text(
                                  'Apply',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return result == null ? null : _dateOnly(result);
  }

  static Future<DateTime?> _openWheelTimePicker({
    required BuildContext context,
    required DateTime baseDate,
    required DateTime initialTime,
    required String title,
    required bool is24HourMode,
    required int minutesInterval,
  }) async {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final result = await showOmniDateTimePicker(
      context: context,
      type: OmniDateTimePickerType.time,
      initialDate: initialTime,
      firstDate: DateTime(baseDate.year, baseDate.month, baseDate.day, 0, 0),
      lastDate: DateTime(baseDate.year, baseDate.month, baseDate.day, 23, 59),
      is24HourMode: is24HourMode,
      isShowSeconds: false,
      minutesInterval: minutesInterval,
      isForce2Digits: true,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: .55),
      borderRadius: BorderRadius.circular(24.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      title: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 8.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: appColors.accent.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.access_time_rounded,
                color: appColors.accent,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.sp,
                ),
              ),
            ),
          ],
        ),
      ),
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: appColors.accent,
          surface: appColors.cardBackground,
          onSurface: appColors.primaryText,
        ),
        dialogTheme: theme.dialogTheme.copyWith(
          backgroundColor: appColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: BorderSide(
              color: appColors.divider.withValues(alpha: isDark ? .42 : .56),
            ),
          ),
        ),
      ),
    );

    if (result == null) return null;

    return _mergeDateAndTime(date: baseDate, time: result);
  }

  static Future<DateTime?> pickTime({
    required BuildContext context,
    required DateTime date,
    DateTime? initialTime,
    String title = 'Select time',
    bool is24HourMode = false,
    int minutesInterval = 5,
  }) async {
    final base = _dateOnly(date);
    final selected = initialTime == null
        ? DateTime(base.year, base.month, base.day, DateTime.now().hour, 0)
        : _mergeDateAndTime(date: base, time: initialTime);

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .50),
      builder: (_) {
        return _TimePickerSheet(
          baseDate: base,
          selectedTime: selected,
          title: title,
          is24HourMode: is24HourMode,
          minutesInterval: minutesInterval,
        );
      },
    );

    return result == null ? null : _mergeDateAndTime(date: base, time: result);
  }

  static Future<DateTime?> pickDateTime({
    required BuildContext context,
    DateTime? initialDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Select date and time',
    bool is24HourMode = false,
    int minutesInterval = 5,
  }) async {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final now = DateTime.now();

    final result = await showOmniDateTimePicker(
      context: context,
      type: OmniDateTimePickerType.dateAndTime,
      initialDate: initialDateTime ?? now,
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? DateTime(now.year + 5, 12, 31),
      is24HourMode: is24HourMode,
      isShowSeconds: false,
      minutesInterval: minutesInterval,
      isForce2Digits: true,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: .55),
      borderRadius: BorderRadius.circular(24.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      title: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 8.h),
        child: Row(
          children: [
            Icon(
              Icons.event_available_rounded,
              color: appColors.accent,
              size: 24.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: appColors.accent,
          surface: appColors.cardBackground,
          onSurface: appColors.primaryText,
        ),
      ),
    );

    if (result == null) return null;

    return DateTime(
      result.year,
      result.month,
      result.day,
      result.hour,
      result.minute,
    );
  }
}

class _TimePickerSheet extends StatefulWidget {
  final DateTime baseDate;
  final DateTime selectedTime;
  final String title;
  final bool is24HourMode;
  final int minutesInterval;

  const _TimePickerSheet({
    required this.baseDate,
    required this.selectedTime,
    required this.title,
    required this.is24HourMode,
    required this.minutesInterval,
  });

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late final TextEditingController _manualController;
  late final FocusNode _focusNode;

  late DateTime _tempSelectedTime;
  late String _fallbackPeriod;

  String? _errorText;

  @override
  void initState() {
    super.initState();

    _tempSelectedTime = widget.selectedTime;
    _fallbackPeriod = _tempSelectedTime.hour >= 12 ? 'PM' : 'AM';

    _manualController = TextEditingController(
      text: AppDateTimePicker._timeLabel(
        _tempSelectedTime,
        is24HourMode: widget.is24HourMode,
      ),
    );

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _manualController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSelectedTime(DateTime value, {bool updateInput = true}) {
    _tempSelectedTime = AppDateTimePicker._mergeDateAndTime(
      date: widget.baseDate,
      time: value,
    );

    _fallbackPeriod = _tempSelectedTime.hour >= 12 ? 'PM' : 'AM';

    if (updateInput) {
      _manualController.text = AppDateTimePicker._timeLabel(
        _tempSelectedTime,
        is24HourMode: widget.is24HourMode,
      );

      _manualController.selection = TextSelection.collapsed(
        offset: _manualController.text.length,
      );
    }

    _errorText = null;
  }

  void _clearInput() {
    setState(() {
      _manualController.clear();
      _errorText = null;
    });

    _focusNode.requestFocus();
  }

  void _applyTypedOrSelected() {
    final typed = AppDateTimePicker._parseFlexibleTimeInput(
      input: _manualController.text,
      baseDate: widget.baseDate,
      is24HourMode: widget.is24HourMode,
      fallbackPeriod: _fallbackPeriod,
    );

    if (_manualController.text.trim().isNotEmpty && typed == null) {
      setState(() {
        _errorText = 'Try 09:00, 9:30 AM, 1730, 5pm, or 5.30pm';
      });
      return;
    }

    Navigator.pop(context, typed ?? _tempSelectedTime);
  }

  List<DateTime> _quickTimes() {
    final base = widget.baseDate;

    return [
      DateTime(base.year, base.month, base.day, 6, 0),
      DateTime(base.year, base.month, base.day, 7, 0),
      DateTime(base.year, base.month, base.day, 8, 0),
      DateTime(base.year, base.month, base.day, 9, 0),
      DateTime(base.year, base.month, base.day, 12, 0),
      DateTime(base.year, base.month, base.day, 13, 0),
      DateTime(base.year, base.month, base.day, 17, 0),
      DateTime(base.year, base.month, base.day, 18, 0),
      DateTime(base.year, base.month, base.day, 22, 0),
    ];
  }

  Future<void> _openWheel() async {
    FocusScope.of(context).unfocus();

    final wheelResult = await AppDateTimePicker._openWheelTimePicker(
      context: context,
      baseDate: widget.baseDate,
      initialTime: _tempSelectedTime,
      title: widget.title,
      is24HourMode: widget.is24HourMode,
      minutesInterval: widget.minutesInterval,
    );

    if (!mounted || wheelResult == null) return;

    setState(() {
      _updateSelectedTime(wheelResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    final recommendedTimes = AppDateTimePicker._recommendedTimesFromInput(
      input: _manualController.text,
      baseDate: widget.baseDate,
      is24HourMode: widget.is24HourMode,
    );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        margin: EdgeInsets.fromLTRB(
          10.w,
          0,
          10.w,
          keyboardInset > 0 ? 6.h : 10.h,
        ),
        constraints: BoxConstraints(
          maxHeight: keyboardInset > 0 ? 0.78.sh : 0.90.sh,
        ),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: appColors.divider.withValues(alpha: isDark ? .40 : .56),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .28 : .12),
              blurRadius: 30.r,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: appColors.divider.withValues(alpha: .80),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: appColors.accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.access_time_rounded,
                        color: appColors.accent,
                        size: 23.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: appColors.primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              height: 1.15,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Use wheel, quick times, or type manually',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appColors.secondaryText,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          color: appColors.pageBackground.withValues(
                            alpha: isDark ? .45 : .80,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: appColors.divider.withValues(alpha: .35),
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: appColors.secondaryText,
                          size: 21.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: appColors.accent.withValues(
                      alpha: isDark ? .13 : .08,
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: appColors.accent.withValues(alpha: .16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          color: appColors.accent.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Icon(
                          Icons.schedule_rounded,
                          color: appColors.accent,
                          size: 25.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          AppDateTimePicker._timeLabel(
                            _tempSelectedTime,
                            is24HourMode: widget.is24HourMode,
                          ),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.primaryText,
                            fontWeight: FontWeight.w700,
                            fontSize: 25.sp,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _openWheel,
                        icon: Icon(Icons.tune_rounded, size: 16.sp),
                        label: Text(
                          'Wheel',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                TextField(
                  controller: _manualController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9aApPmM:\.\-\s]'),
                    ),
                  ],
                  onChanged: (value) {
                    final parsed = AppDateTimePicker._parseFlexibleTimeInput(
                      input: value,
                      baseDate: widget.baseDate,
                      is24HourMode: widget.is24HourMode,
                      fallbackPeriod: _fallbackPeriod,
                    );

                    setState(() {
                      if (value.trim().isEmpty) {
                        _errorText = null;
                        return;
                      }

                      if (parsed == null) {
                        _errorText = 'Try 09:00, 9:30 AM, 1730, 5pm, or 5.30pm';
                        return;
                      }

                      _updateSelectedTime(parsed, updateInput: false);
                    });
                  },
                  onSubmitted: (_) => _applyTypedOrSelected(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Type time',
                    hintText: widget.is24HourMode
                        ? 'Example: 09:00 or 1730'
                        : 'Example: 9:30 AM, 1730, 5pm',
                    errorText: _errorText,
                    prefixIcon: Icon(
                      Icons.edit_calendar_rounded,
                      color: appColors.accent,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _clearInput,
                      icon: const Icon(Icons.close_rounded),
                    ),
                    filled: true,
                    fillColor: appColors.pageBackground.withValues(
                      alpha: isDark ? .42 : .75,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.r),
                      borderSide: BorderSide(
                        color: appColors.divider.withValues(alpha: .42),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.r),
                      borderSide: BorderSide(color: appColors.accent),
                    ),
                  ),
                ),
                if (recommendedTimes.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: appColors.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: recommendedTimes.map((time) {
                      return _TimeRecommendationChip(
                        label: AppDateTimePicker._timeLabel(
                          time,
                          is24HourMode: widget.is24HourMode,
                        ),
                        onTap: () {
                          setState(() {
                            _updateSelectedTime(time);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: 14.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quick times',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: appColors.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 9.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _quickTimes().map((time) {
                    final selectedTime =
                        time.hour == _tempSelectedTime.hour &&
                        time.minute == _tempSelectedTime.minute;

                    return ChoiceChip(
                      selected: selectedTime,
                      label: Text(
                        AppDateTimePicker._timeLabel(
                          time,
                          is24HourMode: widget.is24HourMode,
                        ),
                      ),
                      onSelected: (_) {
                        setState(() {
                          _updateSelectedTime(time);
                        });
                      },
                      labelStyle: TextStyle(
                        color: selectedTime
                            ? theme.colorScheme.onPrimary
                            : appColors.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      selectedColor: appColors.accent,
                      backgroundColor: appColors.pageBackground.withValues(
                        alpha: isDark ? .45 : .85,
                      ),
                      side: BorderSide(
                        color: selectedTime
                            ? appColors.accent
                            : appColors.divider.withValues(alpha: .50),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: appColors.divider.withValues(alpha: .75),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: ElevatedButton.icon(
                          onPressed: _applyTypedOrSelected,
                          icon: Icon(Icons.check_rounded, size: 18.sp),
                          label: Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarIconButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CalendarIconButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: appColors.cardBackground.withValues(alpha: .85),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: appColors.divider.withValues(alpha: .38)),
        ),
        child: Icon(
          icon,
          color: enabled
              ? appColors.primaryText
              : appColors.secondaryText.withValues(alpha: .35),
          size: 21.sp,
        ),
      ),
    );
  }
}

class _CalendarModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _CalendarModeButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      borderRadius: BorderRadius.circular(999.r),
      onTap: onTap,
      child: Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        decoration: BoxDecoration(
          color: appColors.accent.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: appColors.accent.withValues(alpha: .18)),
        ),
        child: Row(
          children: [
            Icon(icon, color: appColors.accent, size: 16.sp),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                color: appColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekDateSelector extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selectedDate;
  final DateTime today;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onSelected;

  const _WeekDateSelector({
    required this.days,
    required this.selectedDate,
    required this.today,
    required this.minDate,
    required this.maxDate,
    required this.onSelected,
  });

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDisabled(DateTime date) {
    final clean = DateTime(date.year, date.month, date.day);
    final min = DateTime(minDate.year, minDate.month, minDate.day);
    final max = DateTime(maxDate.year, maxDate.month, maxDate.day);

    return clean.isBefore(min) || clean.isAfter(max);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: days.map((day) {
        final disabled = _isDisabled(day);
        final selected = _isSameDate(day, selectedDate);
        final isToday = _isSameDate(day, today);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: disabled ? null : () => onSelected(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 78.h,
                decoration: BoxDecoration(
                  color: selected
                      ? appColors.accent
                      : isToday
                      ? appColors.accent.withValues(alpha: .10)
                      : appColors.cardBackground.withValues(
                          alpha: isDark ? .52 : .94,
                        ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: selected
                        ? appColors.accent
                        : isToday
                        ? appColors.accent.withValues(alpha: .30)
                        : appColors.divider.withValues(alpha: .32),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppDateTimePicker._shortWeekdayName(day.weekday),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? theme.colorScheme.onPrimary
                                  : disabled
                                  ? appColors.secondaryText.withValues(
                                      alpha: .32,
                                    )
                                  : appColors.secondaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.5.sp,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            day.day.toString(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: selected
                                  ? theme.colorScheme.onPrimary
                                  : disabled
                                  ? appColors.secondaryText.withValues(
                                      alpha: .32,
                                    )
                                  : appColors.primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isToday && !selected)
                      Positioned(
                        bottom: 7.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              color: appColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TimeRecommendationChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TimeRecommendationChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      borderRadius: BorderRadius.circular(999.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: appColors.accent.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: appColors.accent.withValues(alpha: .22)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: appColors.accent,
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
