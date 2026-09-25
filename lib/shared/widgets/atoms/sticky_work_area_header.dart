import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart'
    show AppShadows;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class StickyWorkAreaHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtentValue;
  final double maxExtentValue;
  final Widget child;

  const StickyWorkAreaHeaderDelegate({
    required this.minExtentValue,
    required this.maxExtentValue,
    required this.child,
  });

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.only(bottom: 8.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: overlapsContent
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant StickyWorkAreaHeaderDelegate oldDelegate) {
    return minExtentValue != oldDelegate.minExtentValue ||
        maxExtentValue != oldDelegate.maxExtentValue ||
        child != oldDelegate.child;
  }
}

class StickyWorkAreaHeader extends StatelessWidget {
  final String title;
  final int totalShifts;
  final bool isExpanded;
  final VoidCallback onTap;

  const StickyWorkAreaHeader({
    super.key,
    required this.title,
    required this.totalShifts,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final lineColor = appColors.divider.withValues(alpha: isDark ? 0.7 : 0.9);

    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        decoration: BoxDecoration(
          color: appColors.cardBackground.withValues(alpha: isDark ? 0.98 : 1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: appColors.divider.withValues(alpha: isDark ? 0.16 : 0.22),
          ),
          boxShadow: AppShadows.soft(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: index == 6
                          ? const SizedBox.shrink()
                          : Container(width: 0.7.w, color: lineColor),
                    ),
                  );
                }),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Container(
                      width: 5.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: appColors.accent,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: appColors.primaryText,
                        ),
                      ),
                    ),

                    AnimatedRotation(
                      duration: const Duration(milliseconds: 180),
                      turns: isExpanded ? 0 : -0.25,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22.sp,
                        color: appColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
