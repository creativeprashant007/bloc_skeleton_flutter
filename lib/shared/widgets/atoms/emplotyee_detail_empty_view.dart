import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class EmployeeDetailsEmptyView extends StatelessWidget {
  final VoidCallback onRetry;

  const EmployeeDetailsEmptyView({super.key, required this.onRetry});

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
              Icons.person_search_rounded,
              size: 58.sp,
              color: appColors.secondaryText,
            ),
            SizedBox(height: 14.h),
            Text(
              'No employee details found.',
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: appColors.secondaryText,
              ),
            ),
            SizedBox(height: 18.h),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
