import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class BranchChip extends StatelessWidget {
  final String branchName;
  final VoidCallback? onTap;

  const BranchChip({super.key, required this.branchName, required this.onTap});

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isIOS = _isIOS(context);
    final isDark = theme.brightness == Brightness.dark;

    final label = branchName.trim().isEmpty
        ? 'Select branch'
        : branchName.trim();

    final enabled = onTap != null;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 39.h, maxWidth: 152.w),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999.r),
          splashColor: isIOS ? Colors.transparent : null,
          highlightColor: appColors.accent.withValues(alpha: .06),
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: appColors.accent.withValues(alpha: isDark ? .13 : .075),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: appColors.accent.withValues(alpha: isDark ? .24 : .18),
                width: .9.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: appColors.accent.withValues(alpha: isDark ? .08 : .05),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: appColors.accent.withValues(alpha: .13),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: appColors.accent.withValues(alpha: .12),
                      width: .8.w,
                    ),
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 11.5.sp,
                    color: appColors.accent,
                  ),
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enabled ? 'Change location' : 'Current location',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: appColors.accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 7.4.sp,
                          height: 1.0,
                          letterSpacing: .05,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: appColors.primaryText,
                          fontWeight: FontWeight.w900,
                          fontSize: 8.sp,
                          height: 1.05,
                          letterSpacing: -.05,
                        ),
                      ),
                    ],
                  ),
                ),
                if (enabled) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    isIOS
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.expand_more_rounded,
                    size: 15.sp,
                    color: appColors.accent,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
