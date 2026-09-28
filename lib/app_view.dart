import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:stock_control_master/main.dart';

import 'package:stock_control_master/core/routes.dart';
import 'package:stock_control_master/core/services/navigation_service/i_navigation_service.dart';
import 'package:stock_control_master/core/theme/theme.dart';

import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_state.dart';

import 'package:stock_control_master/features/index/presentation/view/index_screen.dart';
import 'package:stock_control_master/features/splash/presentation/view/splash_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  Brightness _brightness(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final brightness = _brightness(context, state.themeMode);

        final isDark = brightness == Brightness.dark;

        final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

        final color = theme.scaffoldBackgroundColor;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: color,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: color,
            systemNavigationBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarDividerColor: color,
          ),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HR Master',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          locale: const Locale('en', 'GB'),
          supportedLocales: const [Locale('en', 'GB')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorKey: INavigationService.navigatorKey,
          scaffoldMessengerKey: INavigationService.snackbarKey,
          onGenerateRoute: Routes.onGenerateRoute,
          home: storageService.getIsLoggedIn()
              ? const IndexScreen()
              : const OnboardingScreen(),
        );
      },
    );
  }
}
