import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class TimeHelpBanner extends StatelessWidget {
  final bool isOvernight;

  const TimeHelpBanner({required this.isOvernight});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: appColors.accent.withValues(alpha: .065),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: appColors.accent.withValues(alpha: .13)),
      ),
      child: Row(
        children: [
          Icon(
            isOvernight ? Icons.nights_stay_rounded : Icons.info_outline,
            color: appColors.accent,
            size: 15.sp,
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              'You can edit clock-in date/time and clock-out date/time.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: appColors.secondaryText,
                fontWeight: FontWeight.w600,
                fontSize: 9.2.sp,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
