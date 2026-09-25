import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class CreateShiftBanner extends StatelessWidget {
  const CreateShiftBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        height: 58.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: appColors.warning.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16.r),

          // 👇 very light border (professional look)
          border: Border.all(color: appColors.divider),

          // 👇 soft elevation (NOT heavy shadow)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// LEFT ICON (subtle, not loud)
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: appColors.primaryText.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 22.sp,
                color: appColors.primaryText.withValues(alpha: 0.85),
              ),
            ),

            SizedBox(width: 14.w),

            /// TEXT
            Expanded(
              child: Text(
                'Create Shift',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            /// RIGHT ARROW (very subtle)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: appColors.secondaryText.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
