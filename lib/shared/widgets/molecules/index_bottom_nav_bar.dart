import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:stock_control_master/shared/widgets/atoms/glass_nav_item_data.dart';

class IndexBottomNavBar extends StatelessWidget {
  const IndexBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.messageCount,
    required this.pendingTimesheetCount,
  });

  final int messageCount;
  final int pendingTimesheetCount;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<NavItemData> _items = [
    NavItemData(label: 'Dashboard', icon: Icons.space_dashboard_rounded),
    NavItemData(label: 'Inbox', icon: Icons.markunread_rounded),
    NavItemData(label: 'Shifts', icon: Icons.event_note_rounded),
    NavItemData(label: 'Work Log', icon: Icons.timeline_rounded),
    NavItemData(label: 'Leave', icon: Icons.flight),
  ];

  static const double _selectedFlex = 1.22;
  static const double _normalFlex = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeColors>()!;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final barBase = colors.navBackground;
    final borderColor = colors.navBorder;
    final selectedColor = colors.selectedItem;
    final unselectedColor = colors.unselectedItem;

    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 22.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34.r),
                border: Border.all(
                  color: borderColor.withValues(alpha: isDark ? 0.55 : 0.70),
                  width: 0.8.w,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _mix(barBase, Colors.white, isDark ? 0.10 : 0.25),
                    barBase.withValues(alpha: isDark ? 0.94 : 0.96),
                    _mix(barBase, Colors.black, isDark ? 0.10 : 0.04),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.10),
                    blurRadius: 24.r,
                    offset: const Offset(0, 12),
                  ),
                  if (!isDark)
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.60),
                      blurRadius: 8.r,
                      offset: const Offset(0, -1),
                    ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalFlex = _calculateTotalFlex();

                  return Row(
                    children: _buildNavItems(
                      constraints: constraints,
                      totalFlex: totalFlex,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      navBackground: barBase,
                      navBorder: borderColor,
                      textTheme: textTheme,
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems({
    required BoxConstraints constraints,
    required double totalFlex,
    required Color selectedColor,
    required Color unselectedColor,
    required Color navBackground,
    required Color navBorder,
    required TextTheme textTheme,
    required bool isDark,
  }) {
    return List.generate(_items.length, (index) {
      final item = _items[index];
      final isSelected = index == currentIndex;
      final flex = isSelected ? _selectedFlex : _normalFlex;
      final width = constraints.maxWidth * (flex / totalFlex);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: GlassNavItem(
          data: item,
          isSelected: isSelected,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
          navBackground: navBackground,
          navBorder: navBorder,
          textTheme: textTheme,
          onTap: () => onTap(index),
          messageCount: messageCount,
          pendingTimesheetCount: pendingTimesheetCount,
        ),
      );
    });
  }

  double _calculateTotalFlex() {
    return List.generate(
      _items.length,
      (index) => index == currentIndex ? _selectedFlex : _normalFlex,
    ).fold<double>(0, (sum, item) => sum + item);
  }

  static Color _mix(Color a, Color b, double amount) {
    return Color.lerp(a, b, amount)!;
  }
}
