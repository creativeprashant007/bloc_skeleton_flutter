import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartBreakTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isPaid;
  final VoidCallback onStartTap;

  const StartBreakTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isPaid,
    required this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final chipBg = isPaid
        ? appColors.success.withValues(alpha: 0.12)
        : appColors.warning.withValues(alpha: 0.12);

    final chipColor = isPaid ? appColors.success : appColors.warning;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? 0.96 : 1),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? 0.45 : 0.65),
        ),
        boxShadow: AppShadows.soft(context),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              isPaid ? Icons.coffee_rounded : Icons.lunch_dining_rounded,
              size: 22.sp,
              color: chipColor,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: appColors.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: onStartTap,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}
