import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';

class EmptyUpcomingShifts extends StatelessWidget {
  const EmptyUpcomingShifts({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.all(24.w),
      children: [
        SizedBox(height: 120.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: appColors.divider.withValues(alpha: 0.55),
            ),
            boxShadow: AppShadows.soft(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_busy_rounded,
                color: appColors.accent,
                size: 40.sp,
              ),
              SizedBox(height: 14.h),
              Text(
                'No upcoming shifts',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Pull down to refresh your upcoming shifts.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: appColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
