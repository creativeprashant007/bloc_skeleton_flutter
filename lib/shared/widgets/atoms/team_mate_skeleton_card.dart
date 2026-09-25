import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/shared/widgets/atoms/simmer_line_skeleton.dart';

class TeammateSectionSkeleton extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color highlight;

  const TeammateSectionSkeleton({
    super.key,
    required this.controller,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .35)),
        boxShadow: AppShadows.soft(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLine(
            controller: controller,
            base: base,
            highlight: highlight,
            width: 145.w,
            height: 22.h,
            radius: 8.r,
          ),
          SizedBox(height: 14.h),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 2 ? 0 : 12.h),
              child: Row(
                children: [
                  ShimmerLine(
                    controller: controller,
                    base: base,
                    highlight: highlight,
                    width: 42.w,
                    height: 42.w,
                    radius: 999.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ShimmerLine(
                      controller: controller,
                      base: base,
                      highlight: highlight,
                      width: double.infinity,
                      height: 36.h,
                      radius: 12.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
