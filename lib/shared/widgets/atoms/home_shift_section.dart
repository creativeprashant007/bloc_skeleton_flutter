// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:stock_control_master/core/theme/app_theme_colors.dart';
// import 'package:stock_control_master/features/home/presentation/home/bloc/home_state.dart';
// import 'shift_status_card.dart';

// class HomeShiftSection extends StatelessWidget {
//   final HomeState state;
//   final VoidCallback onPrimaryPressed;
//   final VoidCallback onSecondaryPressed;
//   final VoidCallback onRetryPressed;

//   const HomeShiftSection({
//     super.key,
//     required this.state,
//     required this.onPrimaryPressed,
//     required this.onSecondaryPressed,
//     required this.onRetryPressed,
//   });

//   ShiftCardState _mapCardState(HomeShiftActionState state) {
//     switch (state) {
//       case HomeShiftActionState.upcoming:
//         return ShiftCardState.upcoming;
//       case HomeShiftActionState.active:
//         return ShiftCardState.active;
//       case HomeShiftActionState.onBreak:
//         return ShiftCardState.onBreak;
//       case HomeShiftActionState.completed:
//       case HomeShiftActionState.noShift:
//         return ShiftCardState.completed;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (state.isLoading && !state.hasCurrentShift) {
//       return const _HomeShiftLoadingCard();
//     }

//     if (state.hasCurrentShift) {
//       return ShiftStatusCard(
//         shift: state.currentShift!,
//         state: _mapCardState(state.shiftActionState),
//         onPrimaryPressed: onPrimaryPressed,
//         onSecondaryPressed: onSecondaryPressed,
//       );
//     }

//     return const _HomeNoShiftCard();
//   }
// }

// class _HomeShiftLoadingCard extends StatelessWidget {
//   const _HomeShiftLoadingCard();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.extension<AppThemeColors>()!;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: colors.cardBackground,
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: theme.colorScheme.outline.withValues(alpha:.08)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 90.w,
//             height: 28.h,
//             decoration: BoxDecoration(
//               color: theme.colorScheme.onSurface.withValues(alpha:.06),
//               borderRadius: BorderRadius.circular(100.r),
//             ),
//           ),
//           SizedBox(height: 18.h),
//           Container(
//             width: 170.w,
//             height: 24.h,
//             decoration: BoxDecoration(
//               color: theme.colorScheme.onSurface.withValues(alpha:.06),
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//           ),
//           SizedBox(height: 10.h),
//           Container(
//             width: 130.w,
//             height: 16.h,
//             decoration: BoxDecoration(
//               color: theme.colorScheme.onSurface.withValues(alpha:.05),
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//           ),
//           SizedBox(height: 20.h),
//           const Center(child: CircularProgressIndicator.adaptive()),
//         ],
//       ),
//     );
//   }
// }

// class _HomeNoShiftCard extends StatelessWidget {
//   const _HomeNoShiftCard();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.extension<AppThemeColors>()!;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: colors.cardBackground,
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: theme.colorScheme.outline.withValues(alpha:.08)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.event_available_rounded,
//             size: 28.sp,
//             color: colors.accent,
//           ),
//           SizedBox(height: 14.h),
//           Text(
//             'No shift for today',
//             style: theme.textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.w800,
//               color: colors.primaryText,
//             ),
//           ),
//           SizedBox(height: 6.h),
//           Text(
//             'You do not have any scheduled shift right now.',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: colors.secondaryText,
//               height: 1.45,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HomeShiftErrorCard extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetryPressed;

//   const _HomeShiftErrorCard({
//     required this.message,
//     required this.onRetryPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.extension<AppThemeColors>()!;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: colors.cardBackground,
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: theme.colorScheme.error.withValues(alpha:.16)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.error_outline_rounded,
//             size: 28.sp,
//             color: theme.colorScheme.error,
//           ),
//           SizedBox(height: 14.h),
//           Text(
//             'Could not load today shift',
//             style: theme.textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.w800,
//               color: colors.primaryText,
//             ),
//           ),
//           SizedBox(height: 6.h),
//           Text(
//             message,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: colors.secondaryText,
//               height: 1.45,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           ElevatedButton.icon(
//             onPressed: onRetryPressed,
//             icon: const Icon(Icons.refresh_rounded),
//             label: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
// }
