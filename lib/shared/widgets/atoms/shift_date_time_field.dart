import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class ShiftDateTimeField extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  final String? label;
  final String? helperText;
  final bool isError;
  final bool compact;
  final bool enabled;

  const ShiftDateTimeField({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.label,
    this.helperText,
    this.isError = false,
    this.compact = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final hasLabel = label != null && label!.trim().isNotEmpty;

    final borderColor = isError
        ? appColors.error
        : appColors.divider.withValues(alpha: isDark ? .48 : .70);

    final activeColor = isError ? appColors.error : appColors.accent;

    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12.w : 14.w,
          vertical: compact ? 12.h : 14.h,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? appColors.cardBackground.withValues(alpha: isDark ? .76 : 1)
              : appColors.divider.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 34.w : 38.w,
              height: compact ? 34.w : 38.w,
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(
                icon,
                size: compact ? 17.sp : 19.sp,
                color: activeColor,
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasLabel) ...[
                    Text(
                      label!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.secondaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isError
                          ? appColors.error
                          : enabled
                          ? appColors.primaryText
                          : appColors.secondaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 13.sp : 14.sp,
                      height: 1.18,
                    ),
                  ),
                  if (helperText != null && helperText!.trim().isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      helperText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appColors.secondaryText.withValues(alpha: .82),
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        height: 1.18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 21.sp,
              color: appColors.secondaryText.withValues(alpha: .75),
            ),
          ],
        ),
      ),
    );
  }
}
