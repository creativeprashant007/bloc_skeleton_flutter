import 'package:stock_control_master/shared/widgets/atoms/profile_image.dart'
    show ProfileImage;
import 'package:stock_control_master/features/home/domain/entities/team_mates/today_team_mates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart'
    show AppShadows;
import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class TeammateAvatarItem extends StatelessWidget {
  final TodayTeammate teammate;

  const TeammateAvatarItem({super.key, required this.teammate});

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  Color _statusColor(BuildContext context) {
    final appColors = context.appColors;
    final status = teammate.status.toLowerCase().trim();

    if (status == 'late') return appColors.warning;
    if (status == 'shift_on' || status == 'on_shift' || status == 'active') {
      return appColors.success;
    }

    return appColors.secondaryText;
  }

  String _timeText() {
    final start = teammate.startTime.trim();
    final end = teammate.endTime.trim();

    if (start.isEmpty && end.isEmpty) return 'No time';
    if (start.isEmpty) return end;
    if (end.isEmpty) return start;

    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);
    final statusColor = _statusColor(context);

    return Container(
      width: isIOS ? 110.w : 106.w,
      margin: EdgeInsets.only(bottom: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? 0.96 : 1),
        borderRadius: BorderRadius.circular(isIOS ? 22.r : 18.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isIOS ? 0.34 : 0.62),
        ),
        boxShadow: AppShadows.soft(context),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: isIOS ? 50.w : 48.w,
                height: isIOS ? 50.w : 48.w,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColors.accent.withValues(
                    alpha: isDark ? 0.20 : 0.12,
                  ),
                  border: Border.all(
                    color: appColors.accent.withValues(alpha: 0.18),
                    width: 1.2.w,
                  ),
                ),
                child: ClipOval(
                  child: SizedBox.expand(
                    child: ProfileImage(
                      imageUrl: teammate.image,
                      name: teammate.name,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -1.w,
                bottom: -1.h,
                child: Container(
                  width: 13.w,
                  height: 13.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: appColors.cardBackground,
                      width: 2.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            teammate.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: 9.5.sp,
              color: appColors.primaryText,
              fontWeight: FontWeight.w800,
              height: 1.1.h,
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: appColors.primaryText.withValues(
                alpha: isDark ? .06 : .04,
              ),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              _timeText(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9.8.sp,
                color: appColors.secondaryText,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            teammate.workAreaName.trim().isEmpty
                ? teammate.branchName
                : teammate.workAreaName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
              color: appColors.secondaryText,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
