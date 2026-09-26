import 'package:flutter/material.dart';

class AccountHeader extends StatelessWidget {
  final VoidCallback onClose;

  const AccountHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close_rounded,
                color: theme.colorScheme.primary,
                size: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
