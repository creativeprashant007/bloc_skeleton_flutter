import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/shared/widgets/atoms/simmer_line_skeleton.dart';

class ShiftStatusCardSkeleton extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color highlight;

  const ShiftStatusCardSkeleton({
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
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .35)),
        boxShadow: AppShadows.soft(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerLine(
                controller: controller,
                base: base,
                highlight: highlight,
                width: 92.w,
                height: 30.h,
                radius: 999.r,
              ),
              const Spacer(),
              ShimmerLine(
                controller: controller,
                base: base,
                highlight: highlight,
                width: 72.w,
                height: 30.h,
                radius: 999.r,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ShimmerLine(
            controller: controller,
            base: base,
            highlight: highlight,
            width: 210.w,
            height: 26.h,
            radius: 10.r,
          ),
          SizedBox(height: 8.h),
          ShimmerLine(
            controller: controller,
            base: base,
            highlight: highlight,
            width: 150.w,
            height: 18.h,
            radius: 8.r,
          ),
          SizedBox(height: 12.h),
          ShimmerLine(
            controller: controller,
            base: base,
            highlight: highlight,
            width: double.infinity,
            height: 34.h,
            radius: 12.r,
          ),
          SizedBox(height: 18.h),
          ShimmerLine(
            controller: controller,
            base: base,
            highlight: highlight,
            width: double.infinity,
            height: 12.h,
            radius: 999.r,
          ),
          SizedBox(height: 18.h),
          Wrap(
            spacing: 9.w,
            runSpacing: 9.h,
            children: [
              ShimmerLine(
                controller: controller,
                base: base,
                highlight: highlight,
                width: 125.w,
                height: 38.h,
                radius: 14.r,
              ),
              ShimmerLine(
                controller: controller,
                base: base,
                highlight: highlight,
                width: 96.w,
                height: 38.h,
                radius: 14.r,
              ),
              ShimmerLine(
                controller: controller,
                base: base,
                highlight: highlight,
                width: 112.w,
                height: 38.h,
                radius: 14.r,
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Expanded(
                child: ShimmerLine(
                  controller: controller,
                  base: base,
                  highlight: highlight,
                  width: double.infinity,
                  height: 50.h,
                  radius: 16.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ShimmerLine(
                  controller: controller,
                  base: base,
                  highlight: highlight,
                  width: double.infinity,
                  height: 50.h,
                  radius: 16.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
