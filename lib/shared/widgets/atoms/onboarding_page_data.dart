import 'package:stock_control_master/core/constants/app_assets.dart';

/// Immutable data for a single onboarding page.
class OnboardingPageData {
  final String title;
  final String subtitle;
  final String asset;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.asset,
  });
}

/// The fixed set of onboarding pages shown to the user.
const List<OnboardingPageData> kOnboardingPages = [
  OnboardingPageData(
    title: 'Your Schedule, Anytime',
    subtitle:
        'Check your upcoming shifts in seconds.Stay updated with your work schedule and never miss a shift again.',
    asset: AppAssets.onBoarding1,
  ),
  OnboardingPageData(
    title: 'Track Your Work Hours',
    subtitle:
        'Clock in and out effortlessly.Keep track of your working hours, breaks, and timesheets all in one place.',
    asset: AppAssets.onBoarding2,
  ),
  OnboardingPageData(
    title: 'Stay in the Loop',
    subtitle:
        'Get instant updates, shift changes, and important notifications.Stay connected with your team and workplace anytime.',
    asset: AppAssets.onBoarding3,
  ),
];
