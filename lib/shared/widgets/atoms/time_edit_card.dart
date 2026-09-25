import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/small_value_button.dart';

class TimeEditCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateLabel;
  final String dateValue;
  final String timeValue;
  final IconData icon;
  final Color color;
  final bool isError;
  final VoidCallback? onDateTap;
  final VoidCallback onTimeTap;

  const TimeEditCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.dateValue,
    required this.timeValue,
    required this.icon,
    required this.color,
    required this.isError,
    required this.onDateTap,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    final borderColor = isError ? appColors.error : color;

    return Container(
      padding: EdgeInsets.all(9.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .075),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: borderColor.withValues(alpha: .30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 27.w,
                height: 27.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: isError ? appColors.error : color,
                  size: 15.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isError
                            ? appColors.error
                            : appColors.primaryText,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.4.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: appColors.secondaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 8.2.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SmallValueButton(
            label: dateLabel,
            value: dateValue,
            icon: Icons.calendar_month_rounded,
            color: color,
            onTap: onDateTap,
          ),
          SizedBox(height: 6.h),
          SmallValueButton(
            label: 'Time',
            value: timeValue,
            icon: Icons.access_time_rounded,
            color: color,
            onTap: onTimeTap,
          ),
        ],
      ),
    );
  }
}
