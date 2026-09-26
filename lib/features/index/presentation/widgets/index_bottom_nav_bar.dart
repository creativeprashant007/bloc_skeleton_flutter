import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';

class IndexBottomNavBar extends StatelessWidget {
  const IndexBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItemData> _items = [
    _NavItemData(
      label: 'Home',
      materialIcon: Icons.home_outlined,
      materialSelectedIcon: Icons.home_rounded,
      cupertinoIcon: CupertinoIcons.house,
      cupertinoSelectedIcon: CupertinoIcons.house_fill,
    ),
    _NavItemData(
      label: 'Inventory',
      materialIcon: Icons.inventory_2_outlined,
      materialSelectedIcon: Icons.inventory_2_rounded,
      cupertinoIcon: CupertinoIcons.cube_box,
      cupertinoSelectedIcon: CupertinoIcons.cube_box_fill,
    ),
    _NavItemData(
      label: 'Stock',
      materialIcon: Icons.inventory_outlined,
      materialSelectedIcon: Icons.inventory_rounded,
      cupertinoIcon: CupertinoIcons.square_list,
      cupertinoSelectedIcon: CupertinoIcons.square_list_fill,
    ),
    _NavItemData(
      label: 'Reports',
      materialIcon: Icons.bar_chart_outlined,
      materialSelectedIcon: Icons.bar_chart_rounded,
      cupertinoIcon: CupertinoIcons.chart_bar,
      cupertinoSelectedIcon: CupertinoIcons.chart_bar_fill,
    ),
    _NavItemData(
      label: 'Account',
      materialIcon: Icons.person_outline_rounded,
      materialSelectedIcon: Icons.person_rounded,
      cupertinoIcon: CupertinoIcons.person,
      cupertinoSelectedIcon: CupertinoIcons.person_fill,
    ),
  ];

  int get _safeIndex {
    if (currentIndex < 0) {
      return 0;
    }

    if (currentIndex >= _items.length) {
      return _items.length - 1;
    }

    return currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      return _IOSFloatingGlassNavigationBar(
        currentIndex: _safeIndex,
        items: _items,
        onTap: onTap,
      );
    }

    return _AndroidBottomNavigationBar(
      currentIndex: _safeIndex,
      items: _items,
      onTap: onTap,
    );
  }
}

// ============================================================================
// ANDROID NAVIGATION
// ============================================================================

class _AndroidBottomNavigationBar extends StatelessWidget {
  const _AndroidBottomNavigationBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<_NavItemData> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: appColors.navBackground,
      indicatorColor: appColors.selectedItem.withValues(alpha: 0.14),
      destinations: items.map((item) {
        return NavigationDestination(
          icon: Icon(item.materialIcon, color: appColors.unselectedItem),
          selectedIcon: Icon(
            item.materialSelectedIcon,
            color: appColors.selectedItem,
          ),
          label: item.label,
        );
      }).toList(),
    );
  }
}

// ============================================================================
// IOS FLOATING GLASS NAVIGATION
// ============================================================================

class _IOSFloatingGlassNavigationBar extends StatelessWidget {
  const _IOSFloatingGlassNavigationBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<_NavItemData> items;
  final ValueChanged<int> onTap;

  static const double _barHeight = 64;
  static const double _horizontalMargin = 14;
  static const double _bottomSpacing = 6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      // This is the important fix.
      //
      // The bottom navigation can no longer expand vertically
      // across the whole iPhone / iPad screen.
      height: _barHeight + bottomSafeArea + _bottomSpacing,
      child: Padding(
        padding: EdgeInsets.only(
          left: _horizontalMargin,
          right: _horizontalMargin,
          bottom: bottomSafeArea + _bottomSpacing,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            // Keeps navigation compact on iPad.
            constraints: const BoxConstraints(maxWidth: 560),
            child: SizedBox(
              height: _barHeight,
              child: _IOSGlassContainer(
                appColors: appColors,
                isDark: isDark,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _IOSAnimatedSelection(
                      currentIndex: currentIndex,
                      itemCount: items.length,
                      appColors: appColors,
                      isDark: isDark,
                    ),
                    Row(
                      children: List.generate(items.length, (index) {
                        return Expanded(
                          child: _IOSNavigationItem(
                            item: items[index],
                            selected: index == currentIndex,
                            selectedColor: appColors.selectedItem,
                            unselectedColor: appColors.unselectedItem,
                            onTap: () {
                              if (index == currentIndex) {
                                return;
                              }

                              HapticFeedback.selectionClick();

                              onTap(index);
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// GLASS BACKGROUND
// ============================================================================

class _IOSGlassContainer extends StatelessWidget {
  const _IOSGlassContainer({
    required this.child,
    required this.appColors,
    required this.isDark,
  });

  final Widget child;
  final AppThemeColors appColors;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final glassBase = Color.lerp(
      appColors.navBackground,
      theme.colorScheme.surface,
      isDark ? 0.20 : 0.45,
    )!;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.10),
            blurRadius: 28,
            spreadRadius: -6,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              color: glassBase.withValues(alpha: isDark ? 0.44 : 0.36),
              border: Border.all(
                color: appColors.navBorder.withValues(
                  alpha: isDark ? 0.42 : 0.58,
                ),
                width: 0.7,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.10 : 0.28),
                          Colors.white.withValues(alpha: 0.02),
                          Colors.black.withValues(alpha: isDark ? 0.08 : 0.015),
                        ],
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MOVING SELECTED GLASS CAPSULE
// ============================================================================

class _IOSAnimatedSelection extends StatelessWidget {
  const _IOSAnimatedSelection({
    required this.currentIndex,
    required this.itemCount,
    required this.appColors,
    required this.isDark,
  });

  final int currentIndex;
  final int itemCount;
  final AppThemeColors appColors;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final alignmentX = _calculateAlignment();

    return Padding(
      padding: const EdgeInsets.all(4),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
        alignment: Alignment(alignmentX, 0),
        child: FractionallySizedBox(
          widthFactor: 1 / itemCount,
          heightFactor: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _IOSSelectionCapsule(appColors: appColors, isDark: isDark),
          ),
        ),
      ),
    );
  }

  double _calculateAlignment() {
    if (itemCount <= 1) {
      return 0;
    }

    return -1 + ((2 * currentIndex) / (itemCount - 1));
  }
}

class _IOSSelectionCapsule extends StatelessWidget {
  const _IOSSelectionCapsule({required this.appColors, required this.isDark});

  final AppThemeColors appColors;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;

    final topColor = Color.lerp(
      appColors.navBackground,
      surface,
      isDark ? 0.35 : 0.75,
    )!;

    final bottomColor = Color.lerp(
      appColors.navBackground,
      appColors.selectedItem,
      isDark ? 0.08 : 0.05,
    )!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                topColor.withValues(alpha: isDark ? 0.40 : 0.58),
                bottomColor.withValues(alpha: isDark ? 0.30 : 0.42),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.13 : 0.42),
              width: 0.7,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: appColors.selectedItem.withValues(alpha: 0.07),
                blurRadius: 14,
                spreadRadius: -5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// IOS NAVIGATION ITEM
// ============================================================================

class _IOSNavigationItem extends StatelessWidget {
  const _IOSNavigationItem({
    required this.item,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  final _NavItemData item;

  final bool selected;

  final Color selectedColor;
  final Color unselectedColor;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : unselectedColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          offset: selected ? const Offset(0, -0.025) : Offset.zero,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            scale: selected ? 1.05 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: Icon(
                    selected ? item.cupertinoSelectedIcon : item.cupertinoIcon,
                    key: ValueKey(selected),
                    color: color,
                    size: 21,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: color,
                    fontSize: selected ? 10 : 9,
                    height: 1,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
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

// ============================================================================
// NAVIGATION MODEL
// ============================================================================

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.materialIcon,
    required this.materialSelectedIcon,
    required this.cupertinoIcon,
    required this.cupertinoSelectedIcon,
  });

  final String label;

  final IconData materialIcon;
  final IconData materialSelectedIcon;

  final IconData cupertinoIcon;
  final IconData cupertinoSelectedIcon;
}
