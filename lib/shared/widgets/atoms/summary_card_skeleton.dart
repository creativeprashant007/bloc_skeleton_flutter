import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/shared/widgets/atoms/simmer_line_skeleton.dart';
import 'package:stock_control_master/shared/widgets/atoms/small_summary_skeleton_card.dart';
import 'package:stock_control_master/shared/widgets/atoms/upcoming_tile_skeleton.dart';

class SummaryCardSkeleton extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color highlight;

  const SummaryCardSkeleton({
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
            width: 160.w,
            height: 22.h,
            radius: 8.r,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: SmallSummarySkeleton(
                  controller: controller,
                  base: base,
                  highlight: highlight,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SmallSummarySkeleton(
                  controller: controller,
                  base: base,
                  highlight: highlight,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SmallSummarySkeleton(
                  controller: controller,
                  base: base,
                  highlight: highlight,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          UpcomingTileSkeleton(
            controller: controller,
            base: base,
            highlight: highlight,
          ),
          SizedBox(height: 10.h),
          UpcomingTileSkeleton(
            controller: controller,
            base: base,
            highlight: highlight,
          ),
        ],
      ),
    );
  }
}
