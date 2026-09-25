import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart';

class TimesheetEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const TimesheetEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
          decoration: BoxDecoration(
            color: appColors.cardBackground.withValues(
              alpha: isDark ? 0.96 : 1,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: appColors.divider.withValues(alpha: isDark ? 0.42 : 0.70),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.05),
                blurRadius: 16.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60.w,
                width: 60.w,
                decoration: BoxDecoration(
                  color: appColors.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  Icons.schedule_rounded,
                  size: 28.sp,
                  color: appColors.accent,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'No timesheets found',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: appColors.primaryText,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your submitted shifts and worked hours will appear here once available.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appColors.secondaryText,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 18.h),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh_rounded, size: 18.sp),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140.w, 46.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
