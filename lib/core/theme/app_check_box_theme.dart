import 'package:flutter/material.dart';
import 'package:stock_control_master/core/constants/app_colors.dart';

class AppCheckBoxTheme {
  AppCheckBoxTheme._();

  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: const BorderSide(color: AppColors.lightPrimary, width: 1.2),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lightPrimary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.black),
  );

  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: const BorderSide(color: AppColors.darkPrimary, width: 1.2),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.darkPrimary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.black),
  );
}
