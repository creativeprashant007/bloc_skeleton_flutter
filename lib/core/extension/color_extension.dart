// lib/core/utils/shimmer_colors.dart  (or wherever fits your structure)
import 'package:flutter/material.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

extension ShimmerColors on BuildContext {
  Color get shimmerBase {
    final appColors = this.appColors;
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return appColors.primaryText.withValues(alpha: isDark ? .08 : .055);
  }

  Color get shimmerHighlight {
    final appColors = this.appColors;
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return appColors.primaryText.withValues(alpha: isDark ? .17 : .12);
  }
}
