import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/extension/color_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/summary_card_skeleton.dart';
import 'package:stock_control_master/shared/widgets/atoms/team_mate_skeleton_card.dart';
import 'package:stock_control_master/shared/widgets/molecules/next_shift_skeleton_card.dart';
import 'package:stock_control_master/shared/widgets/molecules/shift_skeleton_status_card.dart';

class HomeLoadingView extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const HomeLoadingView({super.key, this.onRefresh});

  @override
  State<HomeLoadingView> createState() => _HomeLoadingViewState();
}

class _HomeLoadingViewState extends State<HomeLoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.shimmerBase;
    final highlight = context.shimmerHighlight;

    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 28.h),
        children: [
          ShiftStatusCardSkeleton(
            controller: _controller,
            base: base,
            highlight: highlight,
          ),
          SizedBox(height: 16.h),
          NextShiftCardSkeleton(
            controller: _controller,
            base: base,
            highlight: highlight,
          ),
          SizedBox(height: 16.h),
          SummaryCardSkeleton(
            controller: _controller,
            base: base,
            highlight: highlight,
          ),
          SizedBox(height: 16.h),
          TeammateSectionSkeleton(
            controller: _controller,
            base: base,
            highlight: highlight,
          ),
        ],
      ),
    );
  }
}
