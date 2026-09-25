import 'package:flutter/material.dart';

class AccountCompanyCard extends StatelessWidget {
  final List<Widget> children;

  const AccountCompanyCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : theme.dividerColor.withValues(alpha: 0.22),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class AccountCardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final Widget? trailing;
  final bool showDivider;
  final VoidCallback? onTap;

  const AccountCardTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailing,
    this.showDivider = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget trailingWidget;
    if (trailing != null) {
      trailingWidget = trailing!;
    } else if (trailingText != null) {
      trailingWidget = Text(
        trailingText!,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      trailingWidget = Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: trailing == null ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: theme.colorScheme.onSurface),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailingWidget,
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.35)),
      ],
    );
  }
}
