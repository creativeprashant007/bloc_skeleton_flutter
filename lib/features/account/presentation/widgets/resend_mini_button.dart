import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';

class ResendMiniButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const ResendMiniButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    return Tooltip(
      message: 'Resend invitation',
      child: Material(
        color: appColors.accent.withValues(alpha: .10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.r),
          side: BorderSide(color: appColors.accent.withValues(alpha: .18)),
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(13.r),
          child: SizedBox(
            width: 36.w,
            height: 36.w,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: const CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      Icons.refresh_rounded,
                      color: appColors.accent,
                      size: 18.sp,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
