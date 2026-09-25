import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class DialogInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DialogInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: appColors.accent, size: 17.sp),
        SizedBox(width: 8.w),
        Text(
          '$label:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: appColors.secondaryText,
            fontWeight: FontWeight.w700,
            fontSize: 10.5.sp,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors.primaryText,
              fontWeight: FontWeight.w800,
              fontSize: 10.5.sp,
            ),
          ),
        ),
      ],
    );
  }
}
