import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart'
    show AppThemeColors;

class PendingHeader extends StatelessWidget {
  final int count;
  final bool isLoading;

  const PendingHeader({
    super.key,
    required this.count,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: appColors.accent.withValues(alpha: .11),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.mark_email_unread_rounded,
              color: appColors.accent,
              size: 17.sp,
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending invitations',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  isLoading ? 'Refreshing list...' : 'Pull down to refresh',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: appColors.cardBackground,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: appColors.divider.withValues(alpha: .65),
              ),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryText,
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
