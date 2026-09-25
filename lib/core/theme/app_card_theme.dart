import 'package:flutter/material.dart';
import 'package:stock_control_master/core/constants/app_colors.dart';

class AppCardTheme {
  AppCardTheme._();

  static CardThemeData lightCardTheme = CardThemeData(
    color: AppColors.lightCard,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: EdgeInsets.zero,
  );

  static CardThemeData darkCardTheme = CardThemeData(
    color: AppColors.darkCard,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: EdgeInsets.zero,
  );
}
