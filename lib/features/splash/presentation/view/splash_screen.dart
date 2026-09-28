import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_control_master/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:stock_control_master/features/splash/presentation/bloc/splash_event.dart';
import 'package:stock_control_master/features/splash/presentation/bloc/splash_state.dart'
    show OnboardingState;
import 'package:stock_control_master/features/splash/presentation/widgets/onboarding_bottom_actions.dart';
import 'package:stock_control_master/features/splash/presentation/widgets/onboarding_page_data.dart';
import 'package:stock_control_master/features/splash/presentation/widgets/onboarding_page_indicator.dart';
import 'package:stock_control_master/features/splash/presentation/widgets/onboarding_skip_button.dart';
import 'package:stock_control_master/features/splash/presentation/widgets/onboarding_page_content.dart';

import '../../../../main.dart' show storageService;
import '../../../auth/presentation/view/sign_in_screen.dart' show SignInScreen;
import '../../../index/presentation/view/index_screen.dart' show IndexScreen;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  final List<OnboardingPageData> _pages = kOnboardingPages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToAuth() {
    if (!mounted) return;

    final routeName = storageService.getIsLoggedIn()
        ? IndexScreen.routeName
        : SignInScreen.routeName;

    Navigator.of(context).pushNamedAndRemoveUntil(routeName, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(totalPages: _pages.length),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listenWhen: (prev, curr) =>
            prev.completed != curr.completed ||
            prev.pageIndex != curr.pageIndex,
        listener: (context, state) {
          if (state.completed) {
            _navigateToAuth();
          } else {
            if (_pageController.hasClients &&
                _pageController.page?.round() != state.pageIndex) {
              _pageController.animateToPage(
                state.pageIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    OnboardingSkipButton(
                      onSkip: () => context.read<OnboardingBloc>().add(
                        const OnboardingSkipPressed(),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _pages.length,
                        onPageChanged: (index) {
                          context.read<OnboardingBloc>().add(
                            OnboardingPageSwiped(index),
                          );
                        },
                        itemBuilder: (context, index) {
                          return OnboardingPageContent(page: _pages[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    OnboardingPageIndicator(
                      pageCount: _pages.length,
                      currentIndex: state.pageIndex,
                    ),
                    const SizedBox(height: 32),
                    OnboardingBottomActions(
                      isLastPage: state.isLastPage,
                      onNext: () => context.read<OnboardingBloc>().add(
                        const OnboardingNextPressed(),
                      ),
                      onActivate: _navigateToAuth,
                      onLogin: _navigateToAuth,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
