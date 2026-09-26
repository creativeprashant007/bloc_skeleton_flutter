import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_bloc.dart';
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_event.dart';
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_state.dart';
import 'package:stock_control_master/features/index/presentation/widgets/index_back_handler.dart';
import 'package:stock_control_master/features/index/presentation/widgets/index_upgrade_alert.dart';
import 'package:stock_control_master/features/index/presentation/widgets/index_scaffold.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  static const String routeName = '/index';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavBloc()..add(LoadNotificationCountEvent()),
      child: const _IndexScreenView(),
    );
  }
}

class _IndexScreenView extends StatelessWidget {
  const _IndexScreenView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        return IndexBackHandler(
          child: IndexUpgradeAlert(child: IndexScaffold(state: state)),
        );
      },
    );
  }
}
