import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class AppFormDropdownField<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  final String? label;
  final String? helperText;
  final IconData? prefixIcon;
  final bool enabled;
  final bool isError;

  const AppFormDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.helperText,
    this.prefixIcon,
    this.enabled = true,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isError
        ? appColors.error
        : appColors.divider.withValues(alpha: isDark ? .48 : .70);

    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: enabled ? onChanged : null,
      isExpanded: true,
      dropdownColor: appColors.cardBackground,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: appColors.secondaryText.withValues(alpha: .75),
      ),
      style: theme.textTheme.titleSmall?.copyWith(
        color: appColors.primaryText,
        fontWeight: FontWeight.w800,
        fontSize: 13.sp,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        filled: true,
        fillColor: enabled
            ? appColors.cardBackground.withValues(alpha: isDark ? .76 : 1)
            : appColors.divider.withValues(alpha: .12),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: isError ? appColors.error : appColors.accent,
                size: 20.sp,
              ),
        hintStyle: theme.textTheme.titleSmall?.copyWith(
          color: appColors.secondaryText,
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: appColors.accent, width: 1.3),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: appColors.divider.withValues(alpha: .35),
          ),
        ),
      ),
      items: items,
    );
  }
}
