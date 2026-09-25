import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/shared/widgets/atoms/simmer_line_skeleton.dart';

class SmallSummarySkeleton extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color highlight;

  const SmallSummarySkeleton({
    super.key,
    required this.controller,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLine(
      controller: controller,
      base: base,
      highlight: highlight,
      width: double.infinity,
      height: 74.h,
      radius: 18.r,
    );
  }
}
