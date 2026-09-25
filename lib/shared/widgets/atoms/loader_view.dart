import 'package:flutter/material.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';

class LoaderView extends StatelessWidget {
  const LoaderView({super.key, required this.appColors});
  final AppThemeColors appColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: .18),
      child: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(appColors.accent),
        ),
      ),
    );
  }
}
