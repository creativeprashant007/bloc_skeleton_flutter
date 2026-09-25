import 'package:flutter/material.dart';
import 'package:stock_control_master/core/constants/app_colors.dart'
    show AppColors;
import 'package:stock_control_master/core/theme/app_elevated_button_theme.dart';
import 'package:stock_control_master/core/theme/app_outlined_button_theme.dart';
import 'app_app_bar_theme.dart';
import 'app_card_theme.dart';
import 'app_check_box_theme.dart';
import 'app_input_decoration_theme.dart';
import 'app_switch_theme.dart';
import 'app_text_theme.dart';
import 'app_theme_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      error: AppColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      onError: Colors.white,
    ),
    dividerColor: AppColors.lightBorder,
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    appBarTheme: AppAppBarTheme.lightAppBarTheme,
    cardTheme: AppCardTheme.lightCardTheme,
    inputDecorationTheme: AppInputDecorationTheme.lightInputDecorationTheme,
    checkboxTheme: AppCheckBoxTheme.lightCheckboxTheme,
    switchTheme: AppSwitchTheme.lightSwitchTheme,
    textTheme: AppTextTheme.lightTextTheme,
    extensions: const [
      AppThemeColors(
        navBackground: AppColors.lightNavBackground,
        navBorder: AppColors.lightNavBorder,
        selectedItem: AppColors.lightPrimary,
        unselectedItem: AppColors.lightTextSecondary,
        pageBackground: AppColors.lightBackground,
        cardBackground: AppColors.lightCard,
        primaryText: AppColors.lightTextPrimary,
        secondaryText: AppColors.lightTextSecondary,
        accent: AppColors.lightPrimary,
        success: AppColors.success,
        warning: AppColors.warning,
        error: AppColors.error,
        purpleChip: AppColors.purpleChip,
        divider: AppColors.lightBorder,
      ),
    ],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
      onError: Colors.white,
    ),
    dividerColor: AppColors.darkBorder,
    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    appBarTheme: AppAppBarTheme.darkAppBarTheme,
    cardTheme: AppCardTheme.darkCardTheme,
    inputDecorationTheme: AppInputDecorationTheme.darkInputDecorationTheme,
    checkboxTheme: AppCheckBoxTheme.darkCheckboxTheme,
    switchTheme: AppSwitchTheme.darkSwitchTheme,
    textTheme: AppTextTheme.darkTextTheme,
    extensions: const [
      AppThemeColors(
        navBackground: AppColors.darkNavBackground,
        navBorder: AppColors.darkNavBorder,
        selectedItem: AppColors.darkPrimary,
        unselectedItem: AppColors.darkTextSecondary,
        pageBackground: AppColors.darkBackground,
        cardBackground: AppColors.darkCard,
        primaryText: AppColors.darkTextPrimary,
        secondaryText: AppColors.darkTextSecondary,
        accent: AppColors.darkPrimary,
        success: AppColors.success,
        warning: AppColors.warning,
        error: AppColors.error,
        purpleChip: AppColors.purpleChip,
        divider: AppColors.darkBorder,
      ),
    ],
  );
}
