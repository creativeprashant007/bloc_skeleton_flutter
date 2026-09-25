import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SimpleDatePickerField extends StatelessWidget {
  const SimpleDatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
    this.isError = false,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isError ? appColors.error : appColors.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: appColors.cardBackground.withValues(
              alpha: isDark ? 0.96 : 1,
            ),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: activeColor.withValues(alpha: isError ? .44 : .18),
            ),
            boxShadow: AppShadows.soft(context),
          ),
          child: Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: activeColor,
                  size: 17.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: appColors.secondaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      date == null
                          ? 'Select date'
                          : DateFormat('dd MMM yyyy').format(date!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: date == null
                            ? appColors.secondaryText
                            : appColors.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: activeColor,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
