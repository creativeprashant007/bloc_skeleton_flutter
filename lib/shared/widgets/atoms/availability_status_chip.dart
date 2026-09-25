import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart';

class AvailabilityStatusChip extends StatelessWidget {
  final bool isAvailable;

  const AvailabilityStatusChip({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final color = isAvailable ? appColors.success : appColors.purpleChip;
    final label = isAvailable ? 'Available' : 'Unavailable';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withValues(alpha: .55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 7.w),
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: appColors.primaryText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
