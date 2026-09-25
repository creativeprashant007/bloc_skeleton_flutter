import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/constants/app_colors.dart';

class IndexNumberTile extends StatelessWidget {
  const IndexNumberTile({super.key, required this.index, this.size = 82});

  final int index;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: size.h,
        width: size.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: cs.onSecondary.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          index.toString().padLeft(2, '0'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSecondary,
          ),
        ),
      ),
    );
  }
}
