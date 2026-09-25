import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class SheetShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const SheetShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, keyboardInset > 0 ? 4.h : 8.h),
        constraints: BoxConstraints(
          maxHeight: keyboardInset > 0 ? 0.84.sh : 0.92.sh,
        ),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          border: Border.all(
            color: appColors.divider.withValues(alpha: isDark ? .42 : .58),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .24 : .10),
              blurRadius: 24.r,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              12.w,
              8.h,
              12.w,
              keyboardInset > 0 ? 18.h : 12.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: appColors.divider.withValues(alpha: .80),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                SizedBox(height: 9.h),
                Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: appColors.accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(icon, color: appColors.accent, size: 20.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: appColors.primaryText,
                              fontWeight: FontWeight.w800,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appColors.secondaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(13.r),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: appColors.pageBackground.withValues(
                            alpha: isDark ? .45 : .80,
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                          border: Border.all(
                            color: appColors.divider.withValues(alpha: .35),
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: appColors.secondaryText,
                          size: 19.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
