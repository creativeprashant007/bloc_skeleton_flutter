import 'package:flutter/material.dart';

import 'package:stock_control_master/core/constants/app_colors.dart';

class AppChipTheme {
  AppChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    backgroundColor: AppColors.lightSurface,
    selectedColor: AppColors.lightPrimary,
    disabledColor: AppColors.lightBorder,
    secondarySelectedColor: AppColors.lightPrimary,
    checkmarkColor: Colors.black,
    deleteIconColor: AppColors.lightTextSecondary,
    side: const BorderSide(color: AppColors.lightBorder),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    labelStyle: const TextStyle(
      color: AppColors.lightTextPrimary,
      fontFamily: 'Inter',
    ),
    secondaryLabelStyle: const TextStyle(
      color: Colors.black,
      fontFamily: 'Inter',
    ),
    brightness: Brightness.light,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedColor: AppColors.darkPrimary,
    disabledColor: AppColors.darkBorder,
    secondarySelectedColor: AppColors.darkPrimary,
    checkmarkColor: Colors.black,
    deleteIconColor: AppColors.darkTextSecondary,
    side: const BorderSide(color: AppColors.darkBorder),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    labelStyle: const TextStyle(
      color: AppColors.darkTextPrimary,
      fontFamily: 'Inter',
    ),
    secondaryLabelStyle: const TextStyle(
      color: Colors.black,
      fontFamily: 'Inter',
    ),
    brightness: Brightness.dark,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
