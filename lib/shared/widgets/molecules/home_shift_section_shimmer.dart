import 'package:flutter/material.dart';
import 'package:stock_control_master/shared/widgets/molecules/shift_skeleton_status_card.dart';
import 'package:stock_control_master/shared/widgets/molecules/shimmer_builder_home.dart';

class HomeShiftSectionShimmer extends StatelessWidget {
  const HomeShiftSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBuilder(
      builder: (context, controller, base, highlight) {
        return ShiftStatusCardSkeleton(
          controller: controller,
          base: base,
          highlight: highlight,
        );
      },
    );
  }
}
