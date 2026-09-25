import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/extension/user_extension.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:stock_control_master/features/home/presentation/helper/home_page_helper.dart';
import 'package:stock_control_master/features/home/presentation/home/bloc/home_bloc.dart';
import 'package:stock_control_master/features/home/presentation/home/bloc/home_event.dart';
import 'package:stock_control_master/features/home/presentation/home/bloc/home_state.dart';
import 'package:stock_control_master/shared/widgets/atoms/home_header.dart'
    show HomeTopAppBar;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()..add(const HomeStarted())),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  bool _locationPromptVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Scaffold(
      backgroundColor: appColors.pageBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.h),
        child: SafeArea(
          bottom: false,
          child: BlocConsumer<HomeBloc, HomeState>(
            listenWhen: (previous, current) {
              return previous.shouldShowLocationPrompt !=
                      current.shouldShowLocationPrompt ||
                  previous.availableLocations != current.availableLocations;
            },
            listener: (context, state) {
              showLocationSelectionDialogIfNeeded(
                context,
                state,
                _locationPromptVisible,
                (value) {
                  _locationPromptVisible = value;
                },
              );
            },
            builder: (context, state) {
              return HomeTopAppBar(
                branchName: context.currentUser.branchName,
                onBranchTap: () async {
                  await showLocationBottomSheet(context, state);
                },
                onProfileTap: () {
                  context.read<HomeBloc>().add(const HomeProfileTapped());
                },
              );
            },
          ),
        ),
      ),
      body: Container(),
    );
  }
}
