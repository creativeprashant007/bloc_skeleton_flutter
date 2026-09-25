import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/shared/widgets/atoms/simmer_line_skeleton.dart';

class NextShiftCardSkeleton extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color highlight;

  const NextShiftCardSkeleton({
    super.key,
    required this.controller,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .35)),
        boxShadow: AppShadows.soft(context),
      ),
      child: Row(
        children: [
          ShimmerLine(
            controller: controller,
            base: base,
            highlight: highlight,
            width: 48.w,
            height: 48.w,
            radius: 16.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(
                  controller: controller,
                  base: base,
                  highlight: highlight,
                  width: 170.w,
                  height: 18.h,
                  radius: 8.r,
                ),
                SizedBox(height: 8.h),
                ShimmerLine(
                  controller: controller,
                  base: base,
                  highlight: highlight,
                  width: 125.w,
                  height: 15.h,
                  radius: 8.r,
                ),
              ],
            ),
          ),
          ShimmerLine(
            controller: controller,
            base: base,
            highlight: highlight,
            width: 52.w,
            height: 28.h,
            radius: 999.r,
          ),
        ],
      ),
    );
  }
}
