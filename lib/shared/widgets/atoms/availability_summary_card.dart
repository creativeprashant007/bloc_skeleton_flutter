import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart';

class AvailabilitySummaryCard extends StatelessWidget {
  final int availableDays;
  final int unavailableDays;

  const AvailabilitySummaryCard({
    super.key,
    required this.availableDays,
    required this.unavailableDays,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: appColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: appColors.accent.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.event_available_rounded,
              color: appColors.accent,
              size: 25.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$availableDays days available',
                  style: context.text.titleMedium?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  unavailableDays == 0
                      ? 'You are available every week.'
                      : '$unavailableDays unavailable day${unavailableDays == 1 ? '' : 's'} every week.',
                  style: context.text.bodySmall?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w500,
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
