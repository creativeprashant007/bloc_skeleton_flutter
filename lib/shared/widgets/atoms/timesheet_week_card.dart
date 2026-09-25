// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stock_control_master/features/time_sheets/presentation/widgets/timesheet_entrytile.dart'
//     show TimesheetEntryTile;
// import 'package:intl/intl.dart';

// import 'package:stock_control_master/core/theme/theme_extension.dart';
// import 'package:stock_control_master/features/time_sheets/presentation/models/timesheet_item_ui_model.dart';
// import 'package:stock_control_master/features/time_sheets/presentation/models/timesheet_week_group_ui_model.dart';

// class TimesheetWeekCard extends StatelessWidget {
//   final TimesheetWeekGroupUiModel week;
//   final VoidCallback onTap;
//   final ValueChanged<String> onTapTimesheet;
//   final bool isManagerView;

//   final bool isDailyView;
//   final String? periodLabel;
//   final String? totalWorkedLabel;

//   const TimesheetWeekCard({
//     super.key,
//     required this.week,
//     required this.onTap,
//     required this.onTapTimesheet,
//     this.isManagerView = false,
//     this.isDailyView = false,
//     this.periodLabel,
//     this.totalWorkedLabel,
//   });

//   String _formatDuration(Duration duration) {
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes.remainder(60);

//     if (hours <= 0 && minutes <= 0) return '0m';
//     if (minutes == 0) return '${hours}h';

//     return '${hours}h ${minutes}m';
//   }

//   String _formatWeekRange(DateTime start, DateTime end) {
//     return '${DateFormat('d MMM').format(start)} - ${DateFormat('d MMM yyyy').format(end)}';
//   }

//   String _formatShiftTime(TimesheetItemUiModel item) {
//     final start = DateFormat('HH:mm').format(item.startTime);

//     if (item.endTime == null) {
//       return '$start - Open · ${item.breakMinutes}m break';
//     }

//     final end = DateFormat('HH:mm').format(item.endTime!);
//     return '$start - $end · ${item.breakMinutes}m break';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final displayPeriod =
//         periodLabel ?? _formatWeekRange(week.weekStart, week.weekEnd);

//     final displayTotalLabel =
//         totalWorkedLabel ??
//         (isDailyView ? 'Total worked this day' : 'Total worked this week');

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(24.r),
//         onTap: onTap,
//         child: Ink(
//           width: double.infinity,
//           padding: EdgeInsets.all(15.w),
//           decoration: BoxDecoration(
//             color: appColors.cardBackground.withValues(
//               alpha: isDark ? 0.97 : 1,
//             ),
//             borderRadius: BorderRadius.circular(24.r),
//             border: Border.all(
//               color: appColors.divider.withValues(alpha: isDark ? 0.34 : 0.55),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.075),
//                 blurRadius: 22.r,
//                 spreadRadius: -4.r,
//                 offset: Offset(0, 12.h),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _WeekCardHeader(
//                 totalWorked: _formatDuration(week.totalWorkedDuration),
//                 periodLabel: displayPeriod,
//                 totalWorkedLabel: displayTotalLabel,
//                 isDailyView: isDailyView,
//               ),
//               SizedBox(height: 14.h),
//               Container(
//                 height: 1,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       appColors.divider.withValues(alpha: 0),
//                       appColors.divider.withValues(alpha: isDark ? .45 : .70),
//                       appColors.divider.withValues(alpha: 0),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               ...List.generate(week.items.length, (index) {
//                 final item = week.items[index];
//                 final isLast = index == week.items.length - 1;

//                 return Padding(
//                   padding: EdgeInsets.only(top: 8.h, bottom: isLast ? 0 : 8.h),
//                   child: TimesheetEntryTile(
//                     item: item,
//                     shiftTime: _formatShiftTime(item),
//                     isManagerView: isManagerView,
//                     onTap: () => onTapTimesheet(item.id),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _WeekCardHeader extends StatelessWidget {
//   final String totalWorked;
//   final String periodLabel;
//   final String totalWorkedLabel;
//   final bool isDailyView;

//   const _WeekCardHeader({
//     required this.totalWorked,
//     required this.periodLabel,
//     required this.totalWorkedLabel,
//     required this.isDailyView,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = context.appColors;
//     final isDark = theme.brightness == Brightness.dark;

//     return Row(
//       children: [
//         Container(
//           height: 46.w,
//           width: 46.w,
//           decoration: BoxDecoration(
//             color: appColors.accent.withValues(alpha: isDark ? 0.16 : 0.11),
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(color: appColors.accent.withValues(alpha: .18)),
//           ),
//           child: Icon(
//             isDailyView ? Icons.today_rounded : Icons.timer_outlined,
//             color: appColors.accent,
//             size: 21.sp,
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 totalWorked,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   color: appColors.accent,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18.sp,
//                   height: 1.1,
//                 ),
//               ),
//               SizedBox(height: 4.h),
//               Text(
//                 totalWorkedLabel,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.bodySmall?.copyWith(
//                   color: appColors.secondaryText,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 10.sp,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(width: 10.w),
//         Container(
//           constraints: BoxConstraints(maxWidth: 145.w),
//           padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
//           decoration: BoxDecoration(
//             color: appColors.pageBackground.withValues(alpha: isDark ? .45 : 1),
//             borderRadius: BorderRadius.circular(15.r),
//             border: Border.all(
//               color: appColors.divider.withValues(alpha: isDark ? .35 : .58),
//             ),
//           ),
//           child: Text(
//             periodLabel,
//             textAlign: TextAlign.right,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: theme.textTheme.labelMedium?.copyWith(
//               color: appColors.primaryText,
//               fontWeight: FontWeight.w900,
//               fontSize: 11.sp,
//               height: 1.18,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
