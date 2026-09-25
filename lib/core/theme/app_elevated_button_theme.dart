import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/constants/app_colors.dart';
import 'package:stock_control_master/core/constants/app_sizes.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static final ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: _buttonStyle(
          primaryColor: AppColors.lightPrimary,
          disabledBackgroundColor: AppColors.lightBorder.withValues(alpha: .75),
          disabledForegroundColor: AppColors.lightTextSecondary.withValues(
            alpha: .70,
          ),
          foregroundColor: AppColors.darkTextPrimary,
          overlayColor: AppColors.darkTextPrimary,
          shadowColor: AppColors.lightPrimary,
          textColor: AppColors.darkTextPrimary,
        ),
      );

  static final ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: _buttonStyle(
          primaryColor: AppColors.darkPrimary,
          disabledBackgroundColor: AppColors.darkBorder.withValues(alpha: .80),
          disabledForegroundColor: AppColors.darkTextSecondary.withValues(
            alpha: .65,
          ),
          foregroundColor: AppColors.darkBackground,
          overlayColor: AppColors.darkBackground,
          shadowColor: AppColors.darkPrimary,
          textColor: AppColors.darkBackground,
        ),
      );

  static ButtonStyle _buttonStyle({
    required Color primaryColor,
    required Color disabledBackgroundColor,
    required Color disabledForegroundColor,
    required Color foregroundColor,
    required Color overlayColor,
    required Color shadowColor,
    required Color textColor,
  }) {
    return ButtonStyle(
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        if (states.contains(WidgetState.disabled)) return 0;
        if (states.contains(WidgetState.pressed)) return 1.5;
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return 4;
        }

        return 2.5;
      }),

      minimumSize: WidgetStateProperty.all(Size(0, AppSizes.buttonHeight.h)),

      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      ),

      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBackgroundColor;
        }

        if (states.contains(WidgetState.pressed)) {
          return primaryColor.withValues(alpha: .88);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return primaryColor.withValues(alpha: .96);
        }

        return primaryColor;
      }),

      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }

        return foregroundColor;
      }),

      iconColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }

        return foregroundColor;
      }),

      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return overlayColor.withValues(alpha: .12);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return overlayColor.withValues(alpha: .06);
        }

        return Colors.transparent;
      }),

      shadowColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }

        if (states.contains(WidgetState.pressed)) {
          return shadowColor.withValues(alpha: .16);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return shadowColor.withValues(alpha: .28);
        }

        return shadowColor.withValues(alpha: .22);
      }),

      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),

      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      ),

      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          letterSpacing: .1,
          color: textColor,
        ),
      ),

      iconSize: WidgetStateProperty.all(19.sp),

      visualDensity: VisualDensity.standard,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: const Duration(milliseconds: 160),
    );
  }
}
