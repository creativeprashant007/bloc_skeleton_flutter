import 'package:flutter/material.dart';
import 'package:stock_control_master/shared/widgets/atoms/summary_card_skeleton.dart';
import 'package:stock_control_master/shared/widgets/molecules/shimmer_builder_home.dart';

class HomeSmallSectionShimmer extends StatelessWidget {
  const HomeSmallSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBuilder(
      builder: (context, controller, base, highlight) {
        return SummaryCardSkeleton(
          controller: controller,
          base: base,
          highlight: highlight,
        );
      },
    );
  }
}
