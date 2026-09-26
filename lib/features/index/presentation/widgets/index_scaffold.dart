import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_bloc.dart';
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_event.dart';
import 'package:stock_control_master/features/index/presentation/bloc/bottom_nav_state.dart';
import 'package:stock_control_master/features/index/presentation/widgets/index_bottom_nav_bar.dart';
import 'package:stock_control_master/features/index/presentation/widgets/index_pages.dart';

class IndexScaffold extends StatelessWidget {
  const IndexScaffold({super.key, required this.state});

  final BottomNavState state;

  @override
  Widget build(BuildContext context) {
    final pages = buildIndexPages();

    final selectedIndex = _getSafeIndex(state.selectedIndex, pages.length);

    return Scaffold(
      // Allows the actual page to continue behind
      // the floating iOS glass navigation bar.
      extendBody: true,

      body: IndexedStack(index: selectedIndex, children: pages),

      bottomNavigationBar: IndexBottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          _handleBottomNavigationTap(context, index);
        },
      ),
    );
  }

  int _getSafeIndex(int index, int pageCount) {
    if (pageCount <= 0) {
      return 0;
    }

    if (index < 0) {
      return 0;
    }

    if (index >= pageCount) {
      return pageCount - 1;
    }

    return index;
  }

  void _handleBottomNavigationTap(BuildContext context, int index) {
    context.read<BottomNavBloc>().add(BottomNavTabChanged(index));
  }
}
