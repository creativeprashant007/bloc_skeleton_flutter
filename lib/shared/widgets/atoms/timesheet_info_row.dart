import 'package:flutter/material.dart';

class TimesheetInfoRow extends StatelessWidget {
  const TimesheetInfoRow({super.key, required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 28,
            color: theme.dividerColor.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(child: child),
      ],
    );
  }
}
