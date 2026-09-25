import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart'
    show AppThemeColors;

class AddEmployeeButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddEmployeeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: appColors.accent.withValues(alpha: isDark ? .16 : .10),
      borderRadius: BorderRadius.circular(999.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        splashColor: appColors.accent.withValues(alpha: .10),
        highlightColor: appColors.accent.withValues(alpha: .06),
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
              color: appColors.accent.withValues(alpha: isDark ? .26 : .18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: appColors.accent.withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: appColors.accent,
                  size: 15.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Add employee',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
