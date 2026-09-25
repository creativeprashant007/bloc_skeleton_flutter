import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_bloc.dart';
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_event.dart';
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_state.dart';

import 'package:stock_control_master/shared/widgets/molecules/index_bottom_nav_bar.dart';

import '../../../features/index/presentation/widgets/index_pages.dart'
    show buildIndexPages;

/// The main tabbed scaffold: an [IndexedStack] of pages above a bottom nav
/// bar, driven by [BottomNavState].
class IndexScaffold extends StatelessWidget {
  const IndexScaffold({super.key, required this.state});

  final BottomNavState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(bottom: 75.h),
        child: IndexedStack(
          index: state.selectedIndex,
          children: buildIndexPages(),
        ),
      ),
      bottomNavigationBar: IndexBottomNavBar(
        currentIndex: state.selectedIndex,
        pendingTimesheetCount: state.pendingTimesheetCount,
        messageCount: state.messageCount,
        onTap: (index) => _handleBottomNavTap(context, index),
      ),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    context.read<BottomNavBloc>().add(BottomNavTabChanged(index));

    if (index == 1) {
      context.read<BottomNavBloc>().add(LoadNotificationCountEvent());
    }
  }
}
