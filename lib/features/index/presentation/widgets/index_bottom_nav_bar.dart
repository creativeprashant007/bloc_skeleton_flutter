// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:stock_control_master/core/theme/app_theme_colors.dart';
// import 'package:stock_control_master/shared/widgets/atoms/glass_nav_item.dart';
// import 'package:stock_control_master/shared/widgets/atoms/glass_nav_item_data.dart';

// class IndexBottomNavBar extends StatelessWidget {
//   const IndexBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//     required this.messageCount,
//     required this.pendingTimesheetCount,
//   });

//   final int currentIndex;
//   final int messageCount;
//   final int pendingTimesheetCount;
//   final ValueChanged<int> onTap;

//   static const Duration _indicatorDuration = Duration(milliseconds: 360);

//   static const Curve _indicatorCurve = Curves.easeOutCubic;

//   static const List<NavItemData> _items = [
//     NavItemData(label: 'Home', icon: Icons.home_rounded),
//     NavItemData(label: 'Messaging', icon: Icons.chat_bubble_rounded),
//     NavItemData(label: 'Schedule', icon: Icons.calendar_month_rounded),
//     NavItemData(label: 'Timesheets', icon: Icons.access_time_filled_rounded),
//     NavItemData(label: 'People', icon: Icons.badge_rounded),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.extension<AppThemeColors>()!;
//     final isDark = theme.brightness == Brightness.dark;

//     final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

//     return Padding(
//       padding: EdgeInsets.only(
//         left: 12.w,
//         right: 12.w,
//         bottom: bottomSafeArea > 0 ? 8.h : 14.h,
//       ),
//       child: _NavigationShadow(
//         isDark: isDark,
//         selectedColor: colors.selectedItem,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(32.r),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
//             child: Container(
//               height: 72.h,
//               decoration: _buildBarDecoration(context, colors, isDark),
//               child: Padding(
//                 padding: EdgeInsets.all(5.w),
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     final itemWidth = constraints.maxWidth / _items.length;

//                     return Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         _buildSelectionIndicator(
//                           context: context,
//                           itemWidth: itemWidth,
//                           colors: colors,
//                           isDark: isDark,
//                         ),

//                         Row(
//                           children: List.generate(_items.length, (index) {
//                             return SizedBox(
//                               width: itemWidth,
//                               child: GlassNavItem(
//                                 data: _items[index],
//                                 isSelected: index == currentIndex,
//                                 selectedColor: colors.selectedItem,
//                                 unselectedColor: colors.unselectedItem,
//                                 messageCount: messageCount,
//                                 pendingTimesheetCount: pendingTimesheetCount,
//                                 onTap: () => onTap(index),
//                               ),
//                             );
//                           }),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSelectionIndicator({
//     required BuildContext context,
//     required double itemWidth,
//     required AppThemeColors colors,
//     required bool isDark,
//   }) {
//     return AnimatedPositioned(
//       duration: _indicatorDuration,
//       curve: _indicatorCurve,
//       left: currentIndex * itemWidth,
//       top: 0,
//       bottom: 0,
//       width: itemWidth,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 2.w),
//         child: IgnorePointer(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(27.r),

//               // Translucent on purpose.
//               // BackdropFilter cannot look like glass if
//               // the surface placed above it is fully opaque.
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: isDark
//                     ? [
//                         Colors.white.withValues(alpha: 0.12),
//                         colors.selectedItem.withValues(alpha: 0.10),
//                         Colors.white.withValues(alpha: 0.055),
//                       ]
//                     : [
//                         Colors.white.withValues(alpha: 0.72),
//                         colors.selectedItem.withValues(alpha: 0.065),
//                         Colors.white.withValues(alpha: 0.46),
//                       ],
//               ),

//               border: Border.all(
//                 color: isDark
//                     ? Colors.white.withValues(alpha: 0.12)
//                     : Colors.white.withValues(alpha: 0.85),
//                 width: 0.8,
//               ),

//               boxShadow: [
//                 BoxShadow(
//                   color: colors.selectedItem.withValues(
//                     alpha: isDark ? 0.08 : 0.07,
//                   ),
//                   blurRadius: 15.r,
//                   spreadRadius: 0,
//                   offset: Offset(0, 3.h),
//                 ),
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.045),
//                   blurRadius: 9.r,
//                   offset: Offset(0, 4.h),
//                 ),
//               ],
//             ),

//             // Very subtle top glass reflection.
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 height: 1.h,
//                 margin: EdgeInsets.symmetric(horizontal: 15.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: Colors.white.withValues(alpha: isDark ? 0.16 : 0.75),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   BoxDecoration _buildBarDecoration(
//     BuildContext context,
//     AppThemeColors colors,
//     bool isDark,
//   ) {
//     return BoxDecoration(
//       borderRadius: BorderRadius.circular(32.r),

//       // Keep this translucent.
//       color: isDark
//           ? colors.navBackground.withValues(alpha: 0.72)
//           : colors.navBackground.withValues(alpha: 0.70),

//       border: Border.all(
//         color: isDark
//             ? colors.navBorder.withValues(alpha: 0.40)
//             : Colors.white.withValues(alpha: 0.72),
//         width: 0.8,
//       ),
//     );
//   }
// }

// class _NavigationShadow extends StatelessWidget {
//   const _NavigationShadow({
//     required this.child,
//     required this.isDark,
//     required this.selectedColor,
//   });

//   final Widget child;
//   final bool isDark;
//   final Color selectedColor;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(32.r),
//         boxShadow: [
//           // Main floating shadow
//           BoxShadow(
//             color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.09),
//             blurRadius: 26.r,
//             spreadRadius: -4.r,
//             offset: Offset(0, 10.h),
//           ),

//           // Very subtle theme-colored ambient shadow
//           BoxShadow(
//             color: selectedColor.withValues(alpha: isDark ? 0.06 : 0.035),
//             blurRadius: 20.r,
//             spreadRadius: -5.r,
//             offset: Offset(0, 3.h),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
