import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class TimesheetsSkeletonList extends StatelessWidget {
  const TimesheetsSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 24.h),
      itemCount: 4,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (_, _) => const _TimesheetWeekSkeletonCard(),
    );
  }
}

class _TimesheetWeekSkeletonCard extends StatelessWidget {
  const _TimesheetWeekSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? .35 : .55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 140.w, height: 16.h),
          SizedBox(height: 14.h),
          _SkeletonBox(width: double.infinity, height: 54.h),
          SizedBox(height: 10.h),
          _SkeletonBox(width: double.infinity, height: 54.h),
          SizedBox(height: 10.h),
          _SkeletonBox(width: 220.w, height: 54.h),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;

  const _SkeletonBox({required this.width, required this.height});

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    _opacity = Tween<double>(
      begin: .35,
      end: .75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: appColors.primaryText.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}
