import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class DurationSummaryCard extends StatelessWidget {
  final String totalDuration;
  final String paidDuration;
  final String breakSummary;
  final bool hasError;
  final bool isMultiDay;

  const DurationSummaryCard({
    required this.totalDuration,
    required this.paidDuration,
    required this.breakSummary,
    required this.hasError,
    required this.isMultiDay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: hasError
            ? appColors.error.withValues(alpha: .07)
            : appColors.accent.withValues(alpha: .065),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: hasError
              ? appColors.error.withValues(alpha: .18)
              : appColors.accent.withValues(alpha: .13),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                hasError
                    ? Icons.error_outline_rounded
                    : isMultiDay
                    ? Icons.nights_stay_rounded
                    : Icons.timelapse_rounded,
                size: 16.sp,
                color: hasError ? appColors.error : appColors.accent,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  hasError
                      ? 'Invalid date/time range'
                      : isMultiDay
                      ? 'Overnight duration'
                      : 'Shift duration',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: hasError ? appColors.error : appColors.secondaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              Text(
                totalDuration,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: hasError ? appColors.error : appColors.primaryText,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Divider(color: appColors.divider.withValues(alpha: .45), height: 1),
          SizedBox(height: 7.h),
          Row(
            children: [
              Icon(
                Icons.payments_rounded,
                size: 16.sp,
                color: hasError ? appColors.error : appColors.accent,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  breakSummary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 9.8.sp,
                  ),
                ),
              ),
              Text(
                paidDuration,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: hasError ? appColors.error : appColors.primaryText,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
