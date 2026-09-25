import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/account/presentation/view/add_user.dart'
    show AddPeoplePage;
import 'package:stock_control_master/features/account/presentation/view/account_page.dart'
    show AccountPage;

import 'package:stock_control_master/features/auth/presentation/enter_otp/bloc/enter_otp_bloc.dart'
    show EnterOtpBloc;
import 'package:stock_control_master/features/auth/presentation/enter_otp/enter_otp_screen.dart'
    show EnterOtpScreen;

import 'package:stock_control_master/features/auth/presentation/sign_in/bloc/sign_in_bloc.dart'
    show SignInBloc;
import 'package:stock_control_master/features/auth/presentation/sign_in/sign_in_screen.dart'
    show SignInScreen;

import 'package:stock_control_master/features/auth/presentation/sign_up/bloc/sign_up_bloc.dart'
    show SignUpBloc;
import 'package:stock_control_master/features/auth/presentation/sign_up/sign_up_screen.dart'
    show SignUpScreen;

import 'package:stock_control_master/features/home/presentation/home/bloc/home_bloc.dart';

import 'package:stock_control_master/features/index/presentation/view/index_screen.dart'
    show IndexScreen;

class Routes {
  Routes._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // =========================
      // AUTH
      // =========================

      case SignUpScreen.routeName:
        return _registerBlocView(
          view: SignUpScreen(),
          bloc: SignUpBloc(),
          settings: settings,
        );

      case SignInScreen.routeName:
        return _registerBlocView(
          view: SignInScreen(),
          bloc: SignInBloc(),
          settings: settings,
        );

      case EnterOtpScreen.routeName:
        final email = settings.arguments as String;

        return _registerBlocView(
          view: EnterOtpScreen(email: email),
          bloc: EnterOtpBloc(),
          settings: settings,
        );

      // =========================
      // INDEX
      // =========================

      case IndexScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => IndexScreen(),
        );

      // =========================
      // ACCOUNT
      // =========================

      case AccountPage.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AccountPage(),
        );

      case AddPeoplePage.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AddPeoplePage(),
        );

      // =========================
      // HOME
      // =========================

      // =========================
      // DEFAULT
      // =========================

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static MaterialPageRoute _registerBlocView<T extends Bloc>({
    required Widget view,
    required T bloc,
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider<T>(create: (context) => bloc, child: view),
    );
  }
}
