import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class EmployeeDetailsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const EmployeeDetailsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: appColors.divider),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 54.sp,
                color: appColors.error,
              ),
              SizedBox(height: 14.h),
              Text(
                message.isEmpty ? 'Something went wrong.' : message,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: appColors.secondaryText,
                ),
              ),
              SizedBox(height: 18.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
