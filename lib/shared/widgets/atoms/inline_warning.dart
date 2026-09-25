import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class InlineWarning extends StatelessWidget {
  final String text;

  const InlineWarning({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(Icons.error_outline_rounded, color: appColors.error, size: 14.sp),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors.error,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ),
        ),
      ],
    );
  }
}
