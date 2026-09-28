import 'package:flutter/material.dart';

/// Top-right "Skip" action shown above the onboarding page view.
class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final secondaryText =
        textTheme.bodyMedium?.color ??
        colorScheme.onSurface.withValues(alpha: 0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          const Spacer(),
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Skip',
              style: textTheme.bodyMedium?.copyWith(
                color: secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
