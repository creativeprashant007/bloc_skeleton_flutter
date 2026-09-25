import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class CompactDateTimeTile extends StatelessWidget {
  final String label;
  final String value;
  final String? helper;
  final IconData icon;
  final VoidCallback onTap;
  final bool isError;
  final bool isHighlighted;
  final bool flat;

  const CompactDateTimeTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.helper,
    this.isError = false,
    this.isHighlighted = false,
    this.flat = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final color = isError
        ? appColors.error
        : isHighlighted
        ? appColors.accent
        : appColors.secondaryText;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: flat
                ? Colors.transparent
                : appColors.pageBackground.withValues(alpha: .52),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isError
                  ? appColors.error.withValues(alpha: .32)
                  : isHighlighted
                  ? appColors.accent.withValues(alpha: .24)
                  : appColors.divider.withValues(alpha: flat ? .0 : .38),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(icon, size: 15.sp, color: color),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: appColors.secondaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 8.8.sp,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isError
                            ? appColors.error
                            : appColors.primaryText,
                        fontWeight: FontWeight.w800,
                        fontSize: 10.5.sp,
                        height: 1.05,
                      ),
                    ),
                    if (helper != null && helper!.trim().isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        helper!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 8.5.sp,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
