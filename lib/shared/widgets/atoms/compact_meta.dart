import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';

class CompactMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const CompactMeta({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: appColors.secondaryText.withValues(alpha: .86),
          size: 12.sp,
        ),
        SizedBox(width: 3.w),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: appColors.secondaryText,
              fontWeight: FontWeight.w500,
              fontSize: 9.5.sp,
            ),
          ),
        ),
      ],
    );
  }
}
