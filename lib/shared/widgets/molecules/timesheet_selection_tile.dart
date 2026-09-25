import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

import 'package:stock_control_master/core/theme/theme_extension.dart';

/// A single tappable row used inside selection bottom sheets
/// (branch locations, work areas) to represent one selectable option.
class SelectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.accent.withValues(alpha: .10)
              : appColors.pageBackground.withValues(alpha: isDark ? .42 : .72),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected
                ? appColors.accent.withValues(alpha: .45)
                : appColors.divider.withValues(alpha: .45),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: appColors.accent, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: appColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: isSelected ? appColors.accent : appColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
