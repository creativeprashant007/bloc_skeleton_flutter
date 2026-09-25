import 'package:flutter/material.dart';

class DailyShiftAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DailyShiftAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Daily Shifts'));
  }
}
