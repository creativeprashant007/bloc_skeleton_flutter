import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class GlassNavItem extends StatelessWidget {
  const GlassNavItem({
    super.key,
    required this.data,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.navBackground,
    required this.navBorder,
    required this.textTheme,
    required this.onTap,
    required this.messageCount,
    required this.pendingTimesheetCount,
  });

  final NavItemData data;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final Color navBackground;
  final Color navBorder;
  final TextTheme textTheme;
  final VoidCallback onTap;
  final int messageCount;
  final int pendingTimesheetCount;

  int get _badgeCount {
    if (data.label == 'Inbox') return messageCount;
    if (data.label == 'Work Log') return pendingTimesheetCount;
    return 0;
  }

  bool get _showBadge => _badgeCount > 0;

  Color _badgeColorFor(BuildContext context) {
    return data.label == 'Work Log'
        ? context.appColors.warning
        : context.appColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedTop = Color.lerp(
      navBackground,
      Colors.white,
      isDark ? 0.08 : 0.28,
    )!;
    final selectedMid = Color.lerp(
      navBackground,
      Colors.white,
      isDark ? 0.05 : 0.18,
    )!;
    final selectedBottom = Color.lerp(
      navBackground,
      Colors.black,
      isDark ? 0.08 : 0.02,
    )!;

    final badgeColor = _badgeColorFor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 8.w : 4.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      selectedTop.withValues(alpha: isDark ? 0.94 : 1),
                      selectedMid.withValues(alpha: isDark ? 0.90 : 0.96),
                      selectedBottom.withValues(alpha: isDark ? 0.94 : 0.98),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            border: isSelected
                ? Border.all(
                    color: navBorder.withValues(alpha: isDark ? 0.55 : 0.40),
                    width: 0.8,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.22 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      data.icon,
                      size: isSelected ? 21.sp : 19.sp,
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                    if (_showBadge)
                      Positioned(
                        right: -12.w,
                        top: -4.h,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: navBackground.withValues(alpha: 0.85),
                              width: .5.w,
                            ),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18.w,
                            minHeight: 18.h,
                          ),
                          child: Text(
                            _badgeCount > 99 ? '99+' : _badgeCount.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                    fontSize: isSelected ? 8.sp : 7.sp,
                    color: isSelected ? selectedColor : unselectedColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavItemData {
  final String label;
  final IconData icon;

  const NavItemData({required this.label, required this.icon});
}
