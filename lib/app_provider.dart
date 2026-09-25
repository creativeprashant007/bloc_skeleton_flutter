import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart';

import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_bloc.dart';

import 'package:stock_control_master/features/splash/presentation/bloc/splash_bloc.dart';

import 'app_view.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AccountBloc()..add(const LoadAccount())),
          BlocProvider(create: (_) => OnboardingBloc(totalPages: 3)),

          BlocProvider(create: (_) => BottomNavBloc()),
        ],
        child: const AppView(),
      ),
    );
  }
}
