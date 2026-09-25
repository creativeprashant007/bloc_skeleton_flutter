import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/extension/platform_extension.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart';

class LocationCard extends StatelessWidget {
  final AvailableBranch location;
  final bool selected;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.location,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = context.isIOS;

    final title = location.branchName.trim().isNotEmpty
        ? location.branchName.trim()
        : "Unknown Location";

    final subtitle = location.role.trim().isNotEmpty
        ? location.role.trim()
        : "Work Area";

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: selected
                ? appColors.accent.withValues(alpha: isDark ? .12 : .07)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: selected
                  ? appColors.accent.withValues(alpha: .45)
                  : appColors.divider.withValues(alpha: .15),
              width: selected ? 1.3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: .22)
                    : Colors.black.withValues(alpha: .04),
                blurRadius: selected ? 16 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ICON
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: selected
                        ? [
                            appColors.accent,
                            appColors.accent.withValues(alpha: .72),
                          ]
                        : [
                            appColors.primaryText.withValues(alpha: .06),
                            appColors.primaryText.withValues(alpha: .03),
                          ],
                  ),
                ),
                child: Icon(
                  Icons.location_city_rounded,
                  color: selected ? Colors.white : appColors.secondaryText,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 12.w),

              // TEXTS
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: appColors.primaryText,
                        letterSpacing: isIOS ? -0.2 : 0,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 13.sp,
                          color: appColors.secondaryText,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: appColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              // STATUS
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: selected
                      ? appColors.accent.withValues(alpha: .14)
                      : appColors.primaryText.withValues(alpha: .05),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: selected
                            ? appColors.accent
                            : appColors.secondaryText.withValues(alpha: .5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      selected ? 'Active' : 'Select',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: selected
                            ? appColors.accent
                            : appColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 6.w),

              Icon(
                isIOS
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.chevron_right_rounded,
                size: isIOS ? 14.sp : 20.sp,
                color: selected
                    ? appColors.accent
                    : appColors.secondaryText.withValues(alpha: .5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
