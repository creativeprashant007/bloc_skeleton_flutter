import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class AddDateRangeButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddDateRangeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Material(
      color: appColors.error.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(999.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        splashColor: appColors.error.withValues(alpha: .08),
        highlightColor: appColors.error.withValues(alpha: .05),
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: appColors.error.withValues(alpha: .18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: appColors.error, size: 18.sp),
              SizedBox(width: 4.w),
              Text(
                'Add',
                style: context.text.labelMedium?.copyWith(
                  color: appColors.error,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
