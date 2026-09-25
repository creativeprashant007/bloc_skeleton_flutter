import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftsSummaryCard extends StatelessWidget {
  const ShiftsSummaryCard({
    super.key,
    required this.upcomingCount,
    required this.shifts,
    required this.onUpcomingTap,
    required this.onAvailableTap,
    required this.onTimesheetsTap,
  });

  final int upcomingCount;
  final Widget shifts;
  final VoidCallback onUpcomingTap;
  final VoidCallback onAvailableTap;
  final VoidCallback onTimesheetsTap;

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isIOS ? 10.sp : 11.sp),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? 0.96 : 1),
        borderRadius: BorderRadius.circular(isIOS ? 30.r : 28.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isIOS ? 0.34 : 0.55),
        ),
        boxShadow: AppShadows.soft(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(upcomingCount: upcomingCount, onUpcomingTap: onUpcomingTap),
          SizedBox(height: 16.h),
          _UpcomingPanel(child: shifts),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _ActionTab(
                  icon: Icons.add_task_rounded,
                  title: 'Available',
                  subtitle: 'Open shifts',
                  tint: appColors.success,
                  onTap: onAvailableTap,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ActionTab(
                  icon: Icons.receipt_long_rounded,
                  title: 'Timesheets',
                  subtitle: 'Worked hours',
                  tint: appColors.warning,
                  onTap: onTimesheetsTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int upcomingCount;
  final VoidCallback onUpcomingTap;

  const _Header({required this.upcomingCount, required this.onUpcomingTap});

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isIOS = _isIOS(context);

    return Row(
      children: [
        Container(
          width: isIOS ? 52.w : 50.w,
          height: isIOS ? 52.w : 50.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                appColors.accent,
                appColors.accent.withValues(alpha: 0.68),
              ],
            ),
            shape: isIOS ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isIOS ? null : BorderRadius.circular(18.r),
            boxShadow: AppShadows.soft(context),
          ),
          child: Icon(
            isIOS ? Icons.event_note_rounded : Icons.work_history_rounded,
            color: appColors.pageBackground,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shift hub',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  color: appColors.primaryText,
                  fontWeight: isIOS ? FontWeight.w700 : FontWeight.w800,
                  letterSpacing: isIOS ? -0.2 : 0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                upcomingCount == 0
                    ? 'No upcoming shifts scheduled'
                    : '$upcomingCount upcoming shift${upcomingCount == 1 ? '' : 's'} scheduled',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10.sp,
                  color: appColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onUpcomingTap,
            borderRadius: BorderRadius.circular(999.r),
            splashColor: isIOS ? Colors.transparent : null,
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: appColors.accent.withValues(alpha: isIOS ? 0.10 : 0.13),
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(
                  color: appColors.accent.withValues(
                    alpha: isIOS ? 0.18 : 0.22,
                  ),
                ),
              ),
              child: Text(
                'View all',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 12.sp,
                  color: appColors.accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UpcomingPanel extends StatelessWidget {
  final Widget child;

  const _UpcomingPanel({required this.child});

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isIOS ? 15.w : 14.w),
      decoration: BoxDecoration(
        color: isDark
            ? appColors.pageBackground.withValues(alpha: 0.54)
            : appColors.accent.withValues(alpha: isIOS ? 0.040 : 0.055),
        borderRadius: BorderRadius.circular(isIOS ? 24.r : 22.r),
        border: Border.all(
          color: appColors.accent.withValues(alpha: isDark ? 0.18 : 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isIOS ? 6.w : 5.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: appColors.accent,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Upcoming schedule',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    color: appColors.primaryText,
                    fontWeight: isIOS ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _ActionTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;
  final VoidCallback onTap;

  const _ActionTab({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tint,
    required this.onTap,
  });

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(isIOS ? 24.r : 22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isIOS ? 24.r : 22.r),
        splashColor: isIOS ? Colors.transparent : null,
        child: Ink(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark
                ? appColors.pageBackground.withValues(alpha: 0.42)
                : tint.withValues(alpha: isIOS ? 0.055 : 0.075),
            borderRadius: BorderRadius.circular(isIOS ? 24.r : 22.r),
            border: Border.all(
              color: tint.withValues(alpha: isDark ? 0.24 : 0.16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.14),
                  shape: isIOS ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isIOS ? null : BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: tint, size: 20.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: appColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
