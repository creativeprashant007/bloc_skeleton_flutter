import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class SmallValueButton extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const SmallValueButton({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  bool get _isEditable => onTap != null;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: _isEditable
                ? appColors.cardBackground.withValues(alpha: .88)
                : appColors.pageBackground.withValues(alpha: .52),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _isEditable
                  ? color.withValues(alpha: .22)
                  : appColors.divider.withValues(alpha: .36),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _isEditable ? icon : Icons.lock_outline_rounded,
                color: _isEditable ? color : appColors.secondaryText,
                size: 13.sp,
              ),
              SizedBox(width: 5.w),
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
                        fontSize: 8.2.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.primaryText,
                        fontWeight: FontWeight.w900,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isEditable)
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Icon(Icons.edit_rounded, color: color, size: 11.sp),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
