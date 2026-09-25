import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class ShiftFormHeader extends StatelessWidget {
  final bool isEdit;
  final String totalDuration;
  final String paidDuration;
  final bool hasError;
  final bool isMultiDay;

  const ShiftFormHeader({
    required this.isEdit,
    required this.totalDuration,
    required this.paidDuration,
    required this.hasError,
    required this.isMultiDay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: appColors.accent.withValues(alpha: isDark ? .12 : .075),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: appColors.accent.withValues(alpha: .15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .11 : .03),
            blurRadius: 12.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: appColors.accent.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              isEdit
                  ? Icons.edit_calendar_rounded
                  : isMultiDay
                  ? Icons.nights_stay_rounded
                  : Icons.event_available_rounded,
              color: appColors.accent,
              size: 21.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit
                      ? 'Update shift'
                      : isMultiDay
                      ? 'Overnight shift'
                      : 'Create shift',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  hasError
                      ? 'Please fix the selected date and time.'
                      : 'Total $totalDuration • Paid $paidDuration',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: hasError ? appColors.error : appColors.secondaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
