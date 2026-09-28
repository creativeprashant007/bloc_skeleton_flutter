import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========================
  // LIGHT THEME
  // ========================
  static const Color lightPrimary = Color.fromARGB(255, 5, 50, 40);
  static const Color lightSecondary = Color(0xFF16384A);

  static const Color lightBackground = Color(0xFFF8FBFD);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF0E1B24);
  static const Color lightTextSecondary = Color(0xFF5F7280);

  static const Color lightBorder = Color(0xFFD9E4EA);

  static const Color lightNavBackground = Color(0xFFFFFFFF);
  static const Color lightNavBorder = Color(0xFFE1EAF0);

  // ========================
  // DARK THEME
  // ========================
  static const Color darkPrimary = Color(
    0xFF27EFC4,
  ); // keep SAME as light (important)
  static const Color darkSecondary = Color(0xFF16384A);

  static const Color darkBackground = Color(0xFF04111B);
  static const Color darkSurface = Color(0xFF0D2333);
  static const Color darkCard = Color(0xFF10283A);

  static const Color darkTextPrimary = Color(0xFFF4F8FB);
  static const Color darkTextSecondary = Color(0xFFA8BAC6);

  static const Color darkBorder = Color(0xFF21485C);

  static const Color darkNavBackground = Color(0xFF123147);
  static const Color darkNavBorder = Color(0xFF21485C);

  // ========================
  // SHARED (FIXED)
  // ========================
  static const Color success = Color(0xFF1E8E3E); // FIXED (was too dark)
  static const Color warning = Color(0xFFF5C451);

  static const Color error = Color(0xFFE53935); // FIXED (usable red)

  static const Color purpleChip = Color(0xFF32275B);

  // ========================
  // OPTIONAL UTIL COLORS
  // ========================
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
