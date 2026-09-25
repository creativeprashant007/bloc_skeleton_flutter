import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class QuickDayButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const QuickDayButton({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: selected
              ? appColors.accent
              : appColors.accent.withValues(alpha: .075),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: appColors.accent.withValues(alpha: selected ? 1 : .18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15.sp,
              color: selected ? theme.colorScheme.onPrimary : appColors.accent,
            ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : appColors.accent,
                fontWeight: FontWeight.w800,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
