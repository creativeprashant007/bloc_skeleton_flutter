import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class TimeSummaryHeader extends StatelessWidget {
  final String totalDuration;
  final bool isOvernight;
  final bool hasError;

  const TimeSummaryHeader({
    super.key,
    required this.totalDuration,
    required this.isOvernight,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    final color = hasError
        ? appColors.error
        : isOvernight
        ? appColors.accent
        : appColors.success;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(
              hasError
                  ? Icons.error_outline_rounded
                  : isOvernight
                  ? Icons.nights_stay_rounded
                  : Icons.timelapse_rounded,
              color: color,
              size: 17.sp,
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasError
                      ? 'Invalid time range'
                      : isOvernight
                      ? 'Overnight shift'
                      : 'Worked duration',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: hasError ? appColors.error : appColors.primaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  isOvernight
                      ? 'Clock-out date is different from clock-in date'
                      : 'Clock-out is on the same day',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            totalDuration,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
