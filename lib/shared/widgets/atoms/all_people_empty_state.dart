import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class AllPeopleEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const AllPeopleEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: 44.sp,
              color: appColors.accent,
            ),
            SizedBox(height: 14.h),
            Text(
              'No people found',
              textAlign: TextAlign.center,
              style: context.text.titleLarge?.copyWith(
                color: appColors.primaryText,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try changing search or filters.',
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: appColors.secondaryText,
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(onPressed: onRefresh, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
