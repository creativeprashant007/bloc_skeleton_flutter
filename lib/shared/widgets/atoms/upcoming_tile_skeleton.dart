import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/shared/widgets/atoms/simmer_line_skeleton.dart';

class UpcomingTileSkeleton extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color highlight;

  const UpcomingTileSkeleton({
    super.key,
    required this.controller,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShimmerLine(
          controller: controller,
          base: base,
          highlight: highlight,
          width: 38.w,
          height: 38.w,
          radius: 12.r,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLine(
                controller: controller,
                base: base,
                highlight: highlight,
                width: double.infinity,
                height: 14.h,
                radius: 7.r,
              ),
              SizedBox(height: 6.h),
              ShimmerLine(
                controller: controller,
                base: base,
                highlight: highlight,
                width: 130.w,
                height: 12.h,
                radius: 7.r,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
