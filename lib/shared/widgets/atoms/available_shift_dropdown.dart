import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

import 'package:stock_control_master/features/home/presentation/models/shift_ui_model.dart'
    show ShiftUiModel;
import 'app_box_shadow.dart' show AppShadows;

class AvailableShiftDropdown extends StatelessWidget {
  final List<ShiftUiModel> shifts;

  const AvailableShiftDropdown({super.key, required this.shifts});

  String _formatTime(BuildContext context, DateTime value) {
    return TimeOfDay.fromDateTime(value).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final appColors = context.appColors;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? 0.96 : 1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? 0.42 : 0.68),
        ),
        boxShadow: AppShadows.soft(context),
      ),
      child: shifts.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'No available shifts',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appColors.secondaryText,
                  ),
                ),
              ),
            )
          : Column(
              children: List.generate(shifts.length, (index) {
                final item = shifts[index];
                final isLast = index == shifts.length - 1;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: appColors.divider.withValues(
                          alpha: isDark ? 0.42 : 0.62,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: appColors.accent.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.work_history_rounded,
                            color: appColors.accent,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: appColors.primaryText,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.location,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: appColors.secondaryText,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${_formatTime(context, item.start)} - ${_formatTime(context, item.end)}',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: appColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(74.w, 40.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }
}
