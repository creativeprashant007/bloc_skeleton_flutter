import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:intl/intl.dart';

class WeekDayItem extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool isFocused;
  final VoidCallback? onTap;

  const WeekDayItem({
    super.key,
    required this.day,
    required this.isToday,
    required this.isFocused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final bgColor = isToday
        ? appColors.accent
        : isFocused
        ? appColors.accent.withValues(alpha: 0.07)
        : Colors.transparent;

    final borderColor = isFocused && !isToday
        ? appColors.accent.withValues(alpha: 0.22)
        : Colors.transparent;

    final primaryTextColor = isToday
        ? theme.colorScheme.onPrimary
        : isFocused
        ? appColors.accent
        : appColors.primaryText;

    final secondaryTextColor = isToday
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.82)
        : isFocused
        ? appColors.accent.withValues(alpha: 0.82)
        : appColors.secondaryText;

    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: EdgeInsets.symmetric(vertical: 7.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('E').format(day).toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 8.8.sp,
                letterSpacing: 0.25,
                color: secondaryTextColor,
                height: 1,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${day.day}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
                color: primaryTextColor,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
