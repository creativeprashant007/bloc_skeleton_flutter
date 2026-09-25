import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'timesheet_compact_date_time_tile.dart';

class TimesheetCompactDateRangeStrip extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isMultiDay;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final String Function(DateTime?) formatShortDate;
  final String Function(DateTime?) formatTinyDate;

  const TimesheetCompactDateRangeStrip({
    required this.startDate,
    required this.endDate,
    required this.isMultiDay,
    required this.onStartTap,
    required this.onEndTap,
    required this.formatShortDate,
    required this.formatTinyDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: appColors.pageBackground.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .42)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TimesheetCompactDateTimeTile(
              label: 'Start date',
              value: formatShortDate(startDate),
              helper: formatTinyDate(startDate),
              icon: Icons.calendar_month_rounded,
              onTap: onStartTap,
              flat: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: isMultiDay
                    ? appColors.accent.withValues(alpha: .12)
                    : appColors.divider.withValues(alpha: .20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isMultiDay
                    ? Icons.nights_stay_rounded
                    : Icons.arrow_forward_rounded,
                size: 14.sp,
                color: isMultiDay ? appColors.accent : appColors.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: TimesheetCompactDateTimeTile(
              label: 'End date',
              value: formatShortDate(endDate),
              helper: isMultiDay ? 'Next day' : 'Same day',
              icon: Icons.event_repeat_rounded,
              onTap: onEndTap,
              isHighlighted: isMultiDay,
              flat: true,
            ),
          ),
        ],
      ),
    );
  }
}
