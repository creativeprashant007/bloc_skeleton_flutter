import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class DocumentEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;

  const DocumentEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: appColors.accent, size: 44.sp),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: appColors.primaryText,
                fontWeight: FontWeight.w900,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: appColors.secondaryText,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 14.h),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: Icon(Icons.refresh_rounded, size: 18.sp),
              label: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }
}
