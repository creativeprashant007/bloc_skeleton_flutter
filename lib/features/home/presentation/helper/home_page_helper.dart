import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_control_master/core/extension/user_extension.dart';
import 'package:stock_control_master/features/home/presentation/bloc/start_break/start_break_bloc.dart';
import 'package:stock_control_master/features/home/presentation/bloc/start_break/start_break_event.dart';
import 'package:stock_control_master/features/home/presentation/bloc/start_break/start_break_state.dart';
import 'package:stock_control_master/features/home/presentation/view/start_break_bottom_sheet.dart';
import 'package:stock_control_master/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:stock_control_master/features/home/presentation/bloc/home/home_event.dart';
import 'package:stock_control_master/features/home/presentation/bloc/home/home_state.dart';
import 'package:stock_control_master/features/home/presentation/models/home_action_type.dart';
import 'package:stock_control_master/features/home/presentation/widgets/open_shift_area_sheet.dart';
import 'package:stock_control_master/features/home/presentation/widgets/shift_action_confirmation_sheet.dart';
import 'package:stock_control_master/features/home/presentation/widgets/work_location_picker_widgets.dart';

String _roleLabel(BuildContext context) {
  final user = context.currentUser;
  final value = user.role.trim();

  if (value.isEmpty) return 'Staff';

  return value
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.trim().isNotEmpty)
      .map((part) {
        final clean = part.trim();
        return '${clean[0].toUpperCase()}${clean.substring(1).toLowerCase()}';
      })
      .join(' ');
}

Future<void> _showConfirmSheet({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String primaryLabel,
  required ValueChanged<String> onConfirm,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ShiftActionConfirmSheet(
      title: title,
      subtitle: subtitle,
      primaryLabel: primaryLabel,
      onConfirm: onConfirm,
    ),
  );
}

Future<StartBreakSelection?> _showBreakSelector(
  BuildContext context, {
  required int? allocatedBreakMinutes,
}) async {
  return showModalBottomSheet<StartBreakSelection?>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) {
      return BlocProvider(
        create: (_) => StartBreakBloc()..add(const StartBreakStarted()),
        child: StartBreakBottomSheet(
          allocatedBreakMinutes: allocatedBreakMinutes,
        ),
      );
    },
  );
}

Future<void> showLocationSelectionDialogIfNeeded(
  BuildContext context,
  HomeState state,
  bool locationPromptVisible,
  ValueChanged<bool> callBack,
) async {
  if (locationPromptVisible) return;
  if (!state.shouldShowLocationPrompt) return;
  if (state.availableLocations.length <= 1) return;

  locationPromptVisible = true;

  await Future<void>.delayed(const Duration(milliseconds: 220));

  if (!context.mounted) {
    locationPromptVisible = false;
    return;
  }

  final currentBranchId = context.currentUser.branchId;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return WorkLocationChooseDialog(
        locations: state.availableLocations,
        selectedLocationId: currentBranchId,
        roleLabel: _roleLabel(context),
        onSelected: (location) {
          Navigator.pop(dialogContext);

          if (location.branchId == currentBranchId) {
            context.read<HomeBloc>().add(
              HomeLocationPromptHandled(branchId: currentBranchId),
            );
            return;
          }

          context.read<HomeBloc>().add(
            HomeChangeLocation(
              branchId: location.branchId,
              context: context,
              markPromptHandled: true,
            ),
          );
        },
        onKeepCurrent: () {
          Navigator.pop(dialogContext);

          context.read<HomeBloc>().add(
            HomeLocationPromptHandled(branchId: currentBranchId),
          );
        },
      );
    },
  );

  locationPromptVisible = false;
  callBack(locationPromptVisible);
}

Future<void> showLocationBottomSheet(BuildContext context, HomeState state) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => WorkLocationSwitchSheet(
      locations: state.availableLocations,
      selectedLocationId: context.currentUser.branchId,
      roleLabel: _roleLabel(context),
      onSelected: (location) {
        Navigator.pop(context);

        if (location.branchId == context.currentUser.branchId) return;

        context.read<HomeBloc>().add(
          HomeChangeLocation(branchId: location.branchId, context: context),
        );
      },
    ),
  );
}

Future<void> handlePrimaryAction(BuildContext context, HomeState state) async {
  if (state.isActionLoading) return;

  switch (state.primaryAction) {
    case HomeActionType.startShift:
      final shift = state.todayShift;
      if (shift == null) return;

      await _showConfirmSheet(
        context: context,
        title: 'Start scheduled shift?',
        subtitle: '${shift.title} • ${shift.location}\n${shift.timeRangeLabel}',
        primaryLabel: state.primaryAction.label,
        onConfirm: (comment) {
          Navigator.pop(context);

          context.read<HomeBloc>().add(
            HomePrimaryActionPressed(comment: comment),
          );
        },
      );
      break;

    case HomeActionType.startBreak:
    case HomeActionType.startOpenBreak:
      final todayShift = state.todayShift;

      final breakSelection = await _showBreakSelector(
        context,
        allocatedBreakMinutes: todayShift?.breakMinutes,
      );

      if (!context.mounted || breakSelection == null) return;

      context.read<HomeBloc>().add(
        HomePrimaryActionPressed(
          breakId: breakSelection.breakId,
          comment: breakSelection.comment,
        ),
      );
      break;

    case HomeActionType.endBreak:
    case HomeActionType.endOpenBreak:
      await _showConfirmSheet(
        context: context,
        title: 'Resume work?',
        subtitle: 'This will end your current break.',
        primaryLabel: state.primaryAction.label,
        onConfirm: (comment) {
          Navigator.pop(context);

          context.read<HomeBloc>().add(
            HomePrimaryActionPressed(comment: comment),
          );
        },
      );
      break;

    case HomeActionType.startOpenShift:
      final selectedArea = await showModalBottomSheet<dynamic>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => OpenShiftAreaSheet(
          areas: state.openShiftWorkAreas,
          onSelected: (area) => Navigator.pop(context, area),
        ),
      );

      if (!context.mounted || selectedArea == null) return;

      await _showConfirmSheet(
        context: context,
        title: 'Start open shift?',
        subtitle:
            '${selectedArea.name} • ${selectedArea.branchName}\nUnscheduled shift.',
        primaryLabel: state.primaryAction.label,
        onConfirm: (comment) {
          Navigator.pop(context);

          context.read<HomeBloc>().add(
            HomePrimaryActionPressed(
              workAreaId: selectedArea.id,
              workAreaName: selectedArea.name,
              comment: comment,
            ),
          );
        },
      );
      break;

    case HomeActionType.endShift:
    case HomeActionType.endOpenShift:
      await _showConfirmSheet(
        context: context,
        title: 'End shift?',
        subtitle: 'Please confirm to clock out.',
        primaryLabel: state.primaryAction.label,
        onConfirm: (comment) {
          Navigator.pop(context);

          context.read<HomeBloc>().add(
            HomePrimaryActionPressed(comment: comment),
          );
        },
      );
      break;

    case HomeActionType.none:
      break;
  }
}

Future<void> handleSecondaryAction(
  BuildContext context,
  HomeState state,
) async {
  if (state.secondaryAction.isNone || state.isActionLoading) return;

  await _showConfirmSheet(
    context: context,
    title: 'Confirm action',
    subtitle: 'Are you sure?',
    primaryLabel: state.secondaryAction.label,
    onConfirm: (comment) {
      Navigator.pop(context);

      context.read<HomeBloc>().add(
        HomeSecondaryActionPressed(comment: comment),
      );
    },
  );
}

Future<void> refreshHome(BuildContext context) async {
  context.read<HomeBloc>().add(const HomeRefreshRequested());

  await context.read<HomeBloc>().stream.firstWhere(
    (state) => !state.isLoading && !state.isActionLoading,
  );
}
