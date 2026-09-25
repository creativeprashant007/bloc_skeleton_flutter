import 'package:flutter/material.dart';

class AccountSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AccountSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 0),
          Icon(icon, color: const Color(0xFF8CA0B3), size: 24),
          const SizedBox(width: 18),
          const Expanded(
            child: Text(
              'Dark mode',
              style: TextStyle(
                color: Color(0xFFE7EEF5),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF27EFC4),
            activeTrackColor: const Color(0xFF27EFC4).withValues(alpha: 0.35),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF2A4255),
          ),
        ],
      ),
    );
  }
}
