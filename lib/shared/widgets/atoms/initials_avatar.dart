import 'package:flutter/material.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class InitialsAvatar extends StatelessWidget {
  final String name;

  const InitialsAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      alignment: Alignment.center,
      color: appColors.accent.withValues(alpha: 0.14),
      child: Text(
        _initials(name),
        style: context.text.titleMedium?.copyWith(
          color: appColors.accent,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _initials(String value) {
    final words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().isNotEmpty)
        .toList();

    if (words.isEmpty) return 'NA';

    if (words.length == 1) {
      final word = words.first;
      if (word.length == 1) return word[0].toUpperCase();

      return word.substring(0, 2).toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
