import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/constants/app_colors.dart';
import 'package:stock_control_master/core/constants/app_sizes.dart';

class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  static final OutlinedButtonThemeData lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: _buttonStyle(
          primaryColor: AppColors.lightPrimary,
          disabledForegroundColor: AppColors.lightTextSecondary.withValues(
            alpha: .68,
          ),
          disabledBackgroundColor: AppColors.lightBorder.withValues(alpha: .34),
          disabledBorderColor: AppColors.lightBorder.withValues(alpha: .80),
          normalBackgroundColor: AppColors.lightPrimary.withValues(alpha: .075),
          pressedBackgroundColor: AppColors.lightPrimary.withValues(alpha: .18),
          hoveredBackgroundColor: AppColors.lightPrimary.withValues(alpha: .12),
          shadowColor: AppColors.lightPrimary,
        ),
      );

  static final OutlinedButtonThemeData darkOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: _buttonStyle(
          primaryColor: AppColors.darkPrimary,
          disabledForegroundColor: AppColors.darkTextSecondary.withValues(
            alpha: .62,
          ),
          disabledBackgroundColor: AppColors.darkBorder.withValues(alpha: .38),
          disabledBorderColor: AppColors.darkBorder.withValues(alpha: .78),
          normalBackgroundColor: AppColors.darkPrimary.withValues(alpha: .105),
          pressedBackgroundColor: AppColors.darkPrimary.withValues(alpha: .20),
          hoveredBackgroundColor: AppColors.darkPrimary.withValues(alpha: .15),
          shadowColor: AppColors.darkPrimary,
        ),
      );

  static ButtonStyle _buttonStyle({
    required Color primaryColor,
    required Color disabledForegroundColor,
    required Color disabledBackgroundColor,
    required Color disabledBorderColor,
    required Color normalBackgroundColor,
    required Color pressedBackgroundColor,
    required Color hoveredBackgroundColor,
    required Color shadowColor,
  }) {
    return ButtonStyle(
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        if (states.contains(WidgetState.disabled)) return 0;
        if (states.contains(WidgetState.pressed)) return 1;
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return 3;
        }

        return 1.5;
      }),

      minimumSize: WidgetStateProperty.all(Size(0, AppSizes.buttonHeight.h)),

      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      ),

      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }

        return primaryColor;
      }),

      iconColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }

        return primaryColor;
      }),

      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBackgroundColor;
        }

        if (states.contains(WidgetState.pressed)) {
          return pressedBackgroundColor;
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return hoveredBackgroundColor;
        }

        return normalBackgroundColor;
      }),

      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return primaryColor.withValues(alpha: .12);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return primaryColor.withValues(alpha: .07);
        }

        return Colors.transparent;
      }),

      side: WidgetStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: disabledBorderColor, width: 1.1.w);
        }

        if (states.contains(WidgetState.pressed)) {
          return BorderSide(color: primaryColor, width: 1.35.w);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return BorderSide(
            color: primaryColor.withValues(alpha: .92),
            width: 1.25.w,
          );
        }

        return BorderSide(
          color: primaryColor.withValues(alpha: .78),
          width: 1.15.w,
        );
      }),

      shadowColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }

        if (states.contains(WidgetState.pressed)) {
          return shadowColor.withValues(alpha: .10);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return shadowColor.withValues(alpha: .18);
        }

        return shadowColor.withValues(alpha: .12);
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
        ),
      ),

      iconSize: WidgetStateProperty.all(19.sp),

      visualDensity: VisualDensity.standard,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: const Duration(milliseconds: 160),
    );
  }
}
