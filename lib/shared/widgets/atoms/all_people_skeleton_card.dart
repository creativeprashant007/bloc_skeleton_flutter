import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'skeleton_box.dart' show SkeletonBox;

class AllPeopleSkeletonCard extends StatelessWidget {
  const AllPeopleSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .55)),
      ),
      child: Row(
        children: [
          SkeletonBox(width: 52.r, height: 52.r, isCircle: true),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 130.w, height: 14.h),
                SizedBox(height: 8.h),
                SkeletonBox(width: 180.w, height: 12.h),
              ],
            ),
          ),
          SkeletonBox(width: 70.w, height: 24.h),
        ],
      ),
    );
  }
}
