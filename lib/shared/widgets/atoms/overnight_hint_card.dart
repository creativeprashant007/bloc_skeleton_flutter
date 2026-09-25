import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class OvernightHintCard extends StatelessWidget {
  const OvernightHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: appColors.accent.withValues(alpha: .065),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: appColors.accent.withValues(alpha: .13)),
      ),
      child: Row(
        children: [
          Icon(Icons.nights_stay_rounded, size: 15.sp, color: appColors.accent),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              'Overnight shift enabled. End date is different from start date.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: appColors.secondaryText,
                fontWeight: FontWeight.w600,
                fontSize: 9.8.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
