import 'package:stock_control_master/core/theme/app_theme_colors.dart'
    show AppThemeColors;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.black.withValues(alpha: 0.35), // 👈 dim background
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: appColors.divider.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔥 Wave Spinner
              SpinKitWaveSpinner(
                color: appColors.accent,
                size: 60,
                waveColor: appColors.accent.withValues(alpha: 0.3),
              ),

              const SizedBox(height: 18),

              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
