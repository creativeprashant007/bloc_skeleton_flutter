import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class AppVersionAndUpdateCard extends StatelessWidget {
  final Future<String> versionFuture;
  final VoidCallback onCheckUpdate;

  const AppVersionAndUpdateCard({
    super.key,
    required this.versionFuture,
    required this.onCheckUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: appColors.divider.withValues(alpha: isDark ? .42 : .58),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .14 : .04),
              blurRadius: 14.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: appColors.accent.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                Icons.system_update_alt_rounded,
                color: appColors.accent,
                size: 21.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: FutureBuilder<String>(
                future: versionFuture,
                builder: (context, snapshot) {
                  final version = snapshot.data ?? 'Loading...';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App version',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: appColors.primaryText,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        version,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.secondaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(width: 10.w),
            SizedBox(
              height: 34.h,
              child: OutlinedButton.icon(
                onPressed: onCheckUpdate,
                icon: Icon(Icons.refresh_rounded, size: 15.sp),
                label: Text(
                  'Check Update',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
