import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimesheetActionBar extends StatelessWidget {
  const TimesheetActionBar({
    super.key,
    required this.onHistoryTap,
    required this.onApproveTap,
    required this.onSavedTap,
    this.isSaving = false,
    this.isApproved = false,
    required this.isLoading,
  });

  final VoidCallback? onHistoryTap;
  final VoidCallback? onApproveTap;
  final VoidCallback? onSavedTap;
  final bool isSaving;
  final bool isApproved;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border(
            top: BorderSide(
              color: appColors.divider.withValues(alpha: isDark ? .42 : .55),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .28 : .07),
              blurRadius: 24.r,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56.w,
              child: _ActionIconButton(
                tooltip: 'History',
                icon: Icons.history_rounded,
                color: appColors.secondaryText,
                backgroundColor: appColors.warning,
                borderColor: appColors.divider,
                isDisabled: isSaving,
                onTap: onHistoryTap,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Visibility(
                visible: !isLoading,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: ActionTextButton(
                  text: 'Save',
                  icon: Icons.save_rounded,
                  color: appColors.accent,
                  isLoading: isSaving,
                  onTap: onSavedTap,
                ),
              ),
            ),
            if (!isApproved) ...[
              SizedBox(width: 14.w),
              Expanded(
                child: Visibility(
                  visible: !isLoading,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: ActionTextButton(
                    text: 'Approve',
                    icon: Icons.verified_rounded,
                    color: appColors.success,
                    isLoading: isSaving,
                    onTap: onApproveTap,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _ActionIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = isDisabled || onTap == null;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        height: 48.h,
        child: ElevatedButton(
          onPressed: disabled ? null : onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            backgroundColor: backgroundColor,
            foregroundColor: color,
            disabledBackgroundColor: backgroundColor.withValues(alpha: .55),
            disabledForegroundColor: color.withValues(alpha: .45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(
                color: borderColor.withValues(alpha: disabled ? .25 : .55),
              ),
            ),
          ),
          child: Icon(icon, size: 19.sp),
        ),
      ),
    );
  }
}

class ActionTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback? onTap;

  const ActionTextButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = isLoading || onTap == null;

    return SizedBox(
      height: 48.h,
      child: ElevatedButton.icon(
        onPressed: disabled ? null : onTap,
        icon: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: .95),
                  ),
                ),
              )
            : Icon(icon, size: 15.sp),
        label: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: color.withValues(alpha: .50),
          disabledForegroundColor: Colors.white.withValues(alpha: .82),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
