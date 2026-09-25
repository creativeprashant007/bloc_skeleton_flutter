import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class DocumentSkeletonCard extends StatelessWidget {
  const DocumentSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 92.h,
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .90 : 1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .42)),
      ),
    );
  }
}
