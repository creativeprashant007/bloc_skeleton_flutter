import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color navBackground;
  final Color navBorder;
  final Color selectedItem;
  final Color unselectedItem;
  final Color pageBackground;
  final Color cardBackground;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
  final Color success;
  final Color warning;
  final Color error;
  final Color purpleChip;
  final Color divider;

  const AppThemeColors({
    required this.navBackground,
    required this.navBorder,
    required this.selectedItem,
    required this.unselectedItem,
    required this.pageBackground,
    required this.cardBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
    required this.success,
    required this.warning,
    required this.error,
    required this.purpleChip,
    required this.divider,
  });

  @override
  AppThemeColors copyWith({
    Color? navBackground,
    Color? navBorder,
    Color? selectedItem,
    Color? unselectedItem,
    Color? pageBackground,
    Color? cardBackground,
    Color? primaryText,
    Color? secondaryText,
    Color? accent,
    Color? success,
    Color? warning,
    Color? error,
    Color? purpleChip,
    Color? divider,
  }) {
    return AppThemeColors(
      navBackground: navBackground ?? this.navBackground,
      navBorder: navBorder ?? this.navBorder,
      selectedItem: selectedItem ?? this.selectedItem,
      unselectedItem: unselectedItem ?? this.unselectedItem,
      pageBackground: pageBackground ?? this.pageBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      purpleChip: purpleChip ?? this.purpleChip,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navBorder: Color.lerp(navBorder, other.navBorder, t)!,
      selectedItem: Color.lerp(selectedItem, other.selectedItem, t)!,
      unselectedItem: Color.lerp(unselectedItem, other.unselectedItem, t)!,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      purpleChip: Color.lerp(purpleChip, other.purpleChip, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
