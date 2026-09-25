import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class AppFormSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const AppFormSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: appColors.accent.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 14.sp, color: appColors.accent),
          ),
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: RichText(
            text: TextSpan(
              text: title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: appColors.primaryText,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
                height: 1.22,
              ),
              children: [
                if (subtitle != null)
                  TextSpan(
                    text: subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appColors.secondaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      height: 1.22,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
