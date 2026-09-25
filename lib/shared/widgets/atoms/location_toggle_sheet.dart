import 'package:stock_control_master/core/extension/platform_extension.dart';
import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart'
    show AppShadows;
import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;
import 'location_card.dart' show LocationCard;

class LocationToggleSheet extends StatelessWidget {
  final List<AvailableBranch> locations;
  final ValueChanged<AvailableBranch> onSelected;
  final int? selectedLocationId;

  const LocationToggleSheet({
    super.key,
    required this.locations,
    required this.onSelected,
    this.selectedLocationId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = context.isDark;
    final isIOS = context.isIOS;

    return Container(
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? 0.98 : 1),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isIOS ? 34.r : 28.r),
        ),
        boxShadow: AppShadows.soft(context),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.78,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
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

                SizedBox(height: 18.h),

                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: appColors.accent.withValues(
                          alpha: isDark ? .16 : .10,
                        ),
                        shape: isIOS ? BoxShape.circle : BoxShape.rectangle,
                        borderRadius: isIOS
                            ? null
                            : BorderRadius.circular(17.r),
                      ),
                      child: Icon(
                        Icons.storefront_rounded,
                        size: 23.sp,
                        color: appColors.accent,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Switch location',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 20.sp,
                              fontWeight: isIOS
                                  ? FontWeight.w800
                                  : FontWeight.w900,
                              color: appColors.primaryText,
                              letterSpacing: isIOS ? -0.2 : 0,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Choose which branch dashboard to view.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.5.sp,
                              color: appColors.secondaryText,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        size: 22.sp,
                        color: appColors.secondaryText,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.accent.withValues(
                      alpha: isDark ? .10 : .06,
                    ),
                    borderRadius: BorderRadius.circular(isIOS ? 22.r : 18.r),
                    border: Border.all(
                      color: appColors.accent.withValues(
                        alpha: isIOS ? .16 : .20,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18.sp,
                        color: appColors.accent,
                      ),
                      SizedBox(width: 9.w),
                      Expanded(
                        child: Text(
                          'Changing location updates home data, open shifts and today’s team.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: appColors.secondaryText,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                Flexible(
                  child: locations.isEmpty
                      ? const _LocationEmptyState()
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: locations.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final location = locations[index];
                            final selected =
                                selectedLocationId == location.branchId;

                            return LocationCard(
                              location: location,
                              selected: selected,
                              onTap: () => onSelected(location),
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

class _LocationEmptyState extends StatelessWidget {
  const _LocationEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: appColors.secondaryText.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.store_mall_directory_outlined,
              size: 34.sp,
              color: appColors.secondaryText,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'No locations available',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: appColors.primaryText,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'You do not have access to another branch right now.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              color: appColors.secondaryText,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
