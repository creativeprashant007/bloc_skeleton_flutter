import 'package:flutter/material.dart';

class ScreenActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isInverse;

  const ScreenActionButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isInverse = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isInverse) {
      // Outlined style
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(onPressed: onTap, child: Text(title)),
      );
    }

    // Primary filled button – let the theme decide the color
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        //  no backgroundColor here
        child: Text(title, maxLines: 1, style: TextStyle()),
      ),
    );
  }
}
