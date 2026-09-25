import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/employee_avatar.dart';

class TimesheetEmployeeHeader extends StatelessWidget {
  final String employeeName;
  final String employeeImage;

  const TimesheetEmployeeHeader({
    super.key,
    required this.employeeName,
    required this.employeeImage,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final displayName = employeeName.trim().isEmpty
        ? 'Unknown Employee'
        : employeeName.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: appColors.divider.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          EmployeeAvatar(name: displayName, image: employeeImage, size: 58.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Team member timesheet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
