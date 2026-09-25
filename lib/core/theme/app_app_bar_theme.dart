import 'package:flutter/material.dart';
import 'package:stock_control_master/core/constants/app_colors.dart';

class AppAppBarTheme {
  AppAppBarTheme._();

  static const AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.lightTextPrimary,
    elevation: 0,
    centerTitle: false,
    surfaceTintColor: Colors.transparent,
  );

  static const AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.darkTextPrimary,
    elevation: 0,
    centerTitle: false,
    surfaceTintColor: Colors.transparent,
  );
}
