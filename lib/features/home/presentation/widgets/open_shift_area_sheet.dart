import 'package:stock_control_master/features/home/presentation/widgets/app_box_shadow.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/features/home/presentation/models/home_open_work_area_ui_model.dart';

class OpenShiftAreaSheet extends StatelessWidget {
  final List<HomeOpenWorkAreaUiModel> areas;
  final ValueChanged<HomeOpenWorkAreaUiModel> onSelected;

  const OpenShiftAreaSheet({
    super.key,
    required this.areas,
    required this.onSelected,
  });

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    return Container(
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? 0.98 : 1),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isIOS ? 32.r : 26.r),
        ),
        boxShadow: AppShadows.soft(context),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.74,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isIOS ? 42.w : 46.w,
                  height: isIOS ? 4.h : 5.h,
                  decoration: BoxDecoration(
                    color: appColors.divider.withValues(
                      alpha: isIOS ? 0.55 : 0.8,
                    ),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),

                SizedBox(height: 16.h),

                Row(
                  children: [
                    SizedBox(width: isIOS ? 42.w : 0),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Select work area',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 20.sp,
                              fontWeight: isIOS
                                  ? FontWeight.w700
                                  : FontWeight.w900,
                              color: appColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Choose a work area to start an unscheduled shift.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              color: appColors.secondaryText,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isIOS)
                      SizedBox(
                        width: 42.w,
                        height: 42.w,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 21.sp,
                            color: appColors.secondaryText,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 18.h),

                Flexible(
                  child: areas.isEmpty
                      ? const _OpenShiftAreaEmptyState()
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: areas.length,
                          separatorBuilder: (_, _) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final area = areas[index];

                            return _OpenShiftAreaTile(
                              area: area,
                              onTap: () => onSelected(area),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OpenShiftAreaTile extends StatelessWidget {
  final HomeOpenWorkAreaUiModel area;
  final VoidCallback onTap;

  const _OpenShiftAreaTile({required this.area, required this.onTap});

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    final tileRadius = isIOS ? 20.r : 18.r;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(tileRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(tileRadius),
        onTap: onTap,
        splashColor: isIOS ? Colors.transparent : null,
        highlightColor: isIOS
            ? appColors.primaryText.withValues(alpha: 0.04)
            : null,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isIOS ? 14.w : 16.w,
            vertical: isIOS ? 13.h : 14.h,
          ),
          decoration: BoxDecoration(
            color: isIOS
                ? appColors.primaryText.withValues(
                    alpha: isDark ? 0.045 : 0.035,
                  )
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(tileRadius),
            border: Border.all(
              color: appColors.divider.withValues(
                alpha: isIOS ? (isDark ? 0.26 : 0.36) : (isDark ? 0.45 : 0.65),
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: appColors.accent.withValues(
                    alpha: isIOS ? 0.09 : 0.11,
                  ),
                  borderRadius: BorderRadius.circular(isIOS ? 15.r : 14.r),
                ),
                child: Icon(
                  isIOS
                      ? Icons.work_outline_rounded
                      : Icons.work_history_rounded,
                  size: 20.sp,
                  color: appColors.accent,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: isIOS ? FontWeight.w700 : FontWeight.w800,
                        color: appColors.primaryText,
                      ),
                    ),
                    if (area.branchName.trim().isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        area.branchName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: appColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              Icon(
                isIOS
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.chevron_right_rounded,
                size: isIOS ? 15.sp : 22.sp,
                color: appColors.secondaryText.withValues(
                  alpha: isIOS ? 0.72 : 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpenShiftAreaEmptyState extends StatelessWidget {
  const _OpenShiftAreaEmptyState();

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isIOS = _isIOS(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62.w,
              height: 62.w,
              decoration: BoxDecoration(
                color: appColors.secondaryText.withValues(alpha: 0.08),
                shape: isIOS ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isIOS ? null : BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.work_off_rounded,
                size: 30.sp,
                color: appColors.secondaryText,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'No work areas available',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: appColors.primaryText,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'There are no open-shift work areas available right now.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: appColors.secondaryText,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
