import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomActions extends StatelessWidget {
  final bool isLoading;
  final bool canPublish;
  final VoidCallback onPublish;
  final VoidCallback onCancel;

  const BottomActions({super.key, 
    required this.isLoading,
    required this.canPublish,
    required this.onPublish,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 42.h,
            child: OutlinedButton(
              onPressed: isLoading ? null : onCancel,
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 9.w),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 42.h,
            child: ElevatedButton.icon(
              onPressed: canPublish ? onPublish : null,
              icon: isLoading
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.send_rounded, size: 17.sp),
              label: Text(
                isLoading ? 'Publishing...' : 'Publish',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
