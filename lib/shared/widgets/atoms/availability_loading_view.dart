import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class AvailabilityLoadingView extends StatelessWidget {
  const AvailabilityLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
      itemCount: 3,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (_, index) {
        return Container(
          height: index == 0 ? 82.h : 96.h,
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: appColors.divider),
          ),
          child: const Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }
}
