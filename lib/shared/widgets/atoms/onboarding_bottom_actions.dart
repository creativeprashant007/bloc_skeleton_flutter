import 'package:flutter/material.dart';

/// Bottom action area: a single "Next" button on intermediate pages, or
/// "Activate" / "Log in" buttons side-by-side on the last page.
class OnboardingBottomActions extends StatelessWidget {
  const OnboardingBottomActions({
    super.key,
    required this.isLastPage,
    required this.onNext,
    required this.onActivate,
    required this.onLogin,
  });

  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onActivate;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: isLastPage
          ? Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onActivate,
                    child: const Text('Activate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onLogin,
                    child: const Text('Log in'),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(15.r),
                  // ),
                ),
                onPressed: onNext,
                child: const Text('Next'),
              ),
            ),
    );
  }
}
