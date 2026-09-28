import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/features/splash/presentation/widgets/onboarding_page_data.dart';

/// Renders a single onboarding page: illustration, title, and subtitle.
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({super.key, required this.page});

  final OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final secondaryText =
        textTheme.bodyMedium?.color ??
        colorScheme.onSurface.withValues(alpha: 0.7);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              height: 240.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(35.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35.r),
                child: Image.asset(page.asset, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: secondaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
