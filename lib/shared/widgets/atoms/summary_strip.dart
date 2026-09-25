import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class SummaryStrip extends StatelessWidget {
  final String label;
  final String value;
  final bool hasError;

  const SummaryStrip({
    super.key,
    required this.label,
    required this.value,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: hasError
            ? appColors.error.withValues(alpha: .08)
            : appColors.accent.withValues(alpha: .075),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: hasError
              ? appColors.error.withValues(alpha: .20)
              : appColors.accent.withValues(alpha: .15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasError ? Icons.error_outline_rounded : Icons.timelapse_rounded,
            color: hasError ? appColors.error : appColors.accent,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: hasError ? appColors.error : appColors.secondaryText,
                fontWeight: FontWeight.w700,
                fontSize: 10.5.sp,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: hasError ? appColors.error : appColors.primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 11.5.sp,
            ),
          ),
        ],
      ),
    );
  }
}
