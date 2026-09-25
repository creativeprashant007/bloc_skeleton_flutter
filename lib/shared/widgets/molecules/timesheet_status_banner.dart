import 'package:flutter/material.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class TimesheetStatusBanner extends StatelessWidget {
  const TimesheetStatusBanner({super.key, required this.text});

  final String text;

  bool get _isApproved => text.toLowerCase() == 'approved';
  bool get _isPending => text.toLowerCase() == 'pending';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final Color baseColor = _isApproved
        ? appColors.success
        : _isPending
        ? appColors.warning
        : appColors.primaryText;

    final Color backgroundColor = baseColor.withValues(
      alpha: isDark ? 0.18 : 0.10,
    );
    final Color borderColor = baseColor.withValues(alpha: 0.35);

    final IconData icon = _isApproved
        ? Icons.check_circle_rounded
        : _isPending
        ? Icons.access_time_filled_rounded
        : Icons.info_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Status Icon
          Icon(icon, size: 18, color: baseColor),

          const SizedBox(width: 10),

          /// Status Text
          Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: baseColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
