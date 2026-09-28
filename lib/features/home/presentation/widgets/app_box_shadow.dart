import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class AppShadows {
  const AppShadows._();

  /// Standard elevated card shadow (used across app)
  static List<BoxShadow> soft(BuildContext context) {
    final cs = context.appColors;

    return [
      BoxShadow(
        color: Colors.black12.withValues(alpha: 0.11),
        blurRadius: 2.r,

        offset: const Offset(0, 1),
      ),
    ];
  }

  /// Slightly stronger shadow (for modals / featured cards)
  static List<BoxShadow> medium(BuildContext context) {
    final cs = context.appColors;

    return [
      BoxShadow(
        color: Colors.black12.withValues(alpha: 0.3),
        blurRadius: 10.r,
        offset: const Offset(0, 14),
      ),
    ];
  }

  /// Light shadow (chips, small tiles)
  static List<BoxShadow> light(BuildContext context) {
    final cs = context.appColors;
    return [
      BoxShadow(
        color: Colors.black12.withValues(alpha: 0.5),
        blurRadius: 15.r,
        offset: const Offset(0, 6),
      ),
    ];
  }
}
