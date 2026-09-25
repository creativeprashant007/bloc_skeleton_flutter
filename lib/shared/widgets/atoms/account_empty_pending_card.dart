import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart'
    show AppThemeColors;

class EmptyPendingCard extends StatelessWidget {
  final AppThemeColors appColors;

  const EmptyPendingCard({super.key, required this.appColors});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .55)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.mark_email_read_rounded,
            color: appColors.secondaryText,
            size: 30.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            'No pending invitations',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: appColors.primaryText,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Tap Add employee to invite someone.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors.secondaryText,
              fontWeight: FontWeight.w500,
              fontSize: 10.5.sp,
            ),
          ),
        ],
      ),
    );
  }
}
