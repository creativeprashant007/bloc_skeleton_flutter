import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class InlineError extends StatelessWidget {
  final String text;

  const InlineError({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Row(
      children: [
        Icon(Icons.error_outline_rounded, color: appColors.error, size: 14.sp),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors.error,
              fontWeight: FontWeight.w600,
              fontSize: 9.5.sp,
            ),
          ),
        ),
      ],
    );
  }
}
