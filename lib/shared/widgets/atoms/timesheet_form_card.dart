import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/app_form_section_title.dart';

class TimesheetFormCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const TimesheetFormCard({
    required this.title,
    required this.icon,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? .36 : .52),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .12 : .032),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFormSectionTitle(title: title, icon: icon),
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }
}
