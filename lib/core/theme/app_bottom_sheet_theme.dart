import 'package:flutter/material.dart';

import 'package:stock_control_master/core/constants/app_colors.dart';

class AppBottomSheetTheme {
  AppBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: AppColors.lightSurface,
    modalBackgroundColor: AppColors.lightSurface,
    dragHandleColor: AppColors.lightTextSecondary,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: AppColors.darkSurface,
    modalBackgroundColor: AppColors.darkSurface,
    dragHandleColor: AppColors.darkTextSecondary,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
