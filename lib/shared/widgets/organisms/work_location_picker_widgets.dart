import 'package:stock_control_master/features/home/domain/entities/branch/available_branch_response.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkLocationChooseDialog extends StatelessWidget {
  final List<AvailableBranch> locations;
  final int selectedLocationId;
  final String roleLabel;
  final ValueChanged<AvailableBranch> onSelected;
  final VoidCallback onKeepCurrent;

  const WorkLocationChooseDialog({
    super.key,
    required this.locations,
    required this.selectedLocationId,
    required this.roleLabel,
    required this.onSelected,
    required this.onKeepCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      backgroundColor: Colors.transparent,
      child: _WorkLocationPickerFrame(
        title: 'Choose today’s location',
        subtitle:
            'You are assigned to multiple branches. Select where you are working today.',
        icon: Icons.storefront_rounded,
        maxHeightFactor: .78,
        locations: locations,
        selectedLocationId: selectedLocationId,
        roleLabel: roleLabel,
        selectedText: 'Currently selected branch ',
        unselectedText: 'Use this branch today',
        onSelected: onSelected,
        footer: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 14.h),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onKeepCurrent,
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: Text('Keep current', style: TextStyle(fontSize: 12.5.sp)),
            ),
          ),
        ),
      ),
    );
  }
}

class WorkLocationSwitchSheet extends StatelessWidget {
  final List<AvailableBranch> locations;
  final int selectedLocationId;
  final String roleLabel;
  final ValueChanged<AvailableBranch> onSelected;

  const WorkLocationSwitchSheet({
    super.key,
    required this.locations,
    required this.selectedLocationId,
    required this.roleLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
        child: _WorkLocationPickerFrame(
          title: 'Switch location',
          subtitle:
              'Change the branch used for schedules, clock-in and team visibility.',
          icon: Icons.swap_horiz_rounded,
          maxHeightFactor: .82,
          locations: locations,
          selectedLocationId: selectedLocationId,
          roleLabel: roleLabel,
          selectedText: 'Active working branch',
          unselectedText: 'Tap to switch location',
          onSelected: onSelected,
          footer: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 14.h),
            child: _RoleInfoCard(roleLabel: roleLabel),
          ),
        ),
      ),
    );
  }
}

class _WorkLocationPickerFrame extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double maxHeightFactor;
  final List<AvailableBranch> locations;
  final int selectedLocationId;
  final String roleLabel;
  final String selectedText;
  final String unselectedText;
  final ValueChanged<AvailableBranch> onSelected;
  final Widget footer;

  const _WorkLocationPickerFrame({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.maxHeightFactor,
    required this.locations,
    required this.selectedLocationId,
    required this.roleLabel,
    required this.selectedText,
    required this.unselectedText,
    required this.onSelected,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeightFactor.sh),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? .42 : .62),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .34 : .16),
            blurRadius: 32.r,
            offset: Offset(0, 16.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PickerHeader(
              title: title,
              subtitle: subtitle,
              icon: icon,
              roleLabel: roleLabel,
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 10.h),
                itemCount: locations.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final location = locations[index];
                  final isSelected = location.branchId == selectedLocationId;

                  return WorkLocationTile(
                    location: location,
                    isSelected: isSelected,
                    roleLabel: roleLabel,
                    selectedText: "$selectedText/ ${location.role}",
                    unselectedText: "$unselectedText / ${location.role}",
                    onTap: () => onSelected(location),
                  );
                },
              ),
            ),
            footer,
          ],
        ),
      ),
    );
  }
}

class _PickerHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String roleLabel;

  const _PickerHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.roleLabel,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 14.h),
      decoration: BoxDecoration(
        color: appColors.accent.withValues(alpha: .10),
        border: Border(
          bottom: BorderSide(color: appColors.divider.withValues(alpha: .45)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: appColors.accent.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(17.r),
            ),
            child: Icon(icon, color: appColors.accent, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8.h),
                _RolePill(roleLabel: roleLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkLocationTile extends StatelessWidget {
  final AvailableBranch location;
  final bool isSelected;
  final String roleLabel;
  final String selectedText;
  final String unselectedText;
  final VoidCallback onTap;

  const WorkLocationTile({
    super.key,
    required this.location,
    required this.isSelected,
    required this.roleLabel,
    required this.selectedText,
    required this.unselectedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final activeColor = appColors.accent;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: .13)
                : appColors.pageBackground,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? activeColor.withValues(alpha: .65)
                  : appColors.divider.withValues(alpha: .72),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withValues(alpha: .16)
                      : appColors.cardBackground,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: isSelected
                        ? activeColor.withValues(alpha: .25)
                        : appColors.divider.withValues(alpha: .55),
                  ),
                ),
                child: Icon(
                  isSelected
                      ? Icons.location_on_rounded
                      : Icons.location_on_outlined,
                  color: isSelected ? activeColor : appColors.secondaryText,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.branchName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelLarge?.copyWith(
                        color: isSelected
                            ? appColors.primaryText
                            : appColors.secondaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      isSelected ? selectedText : unselectedText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: isSelected
                            ? activeColor
                            : appColors.secondaryText,
                        fontWeight: FontWeight.w500,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? activeColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? activeColor
                        : appColors.divider.withValues(alpha: .85),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16.sp,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleInfoCard extends StatelessWidget {
  final String roleLabel;

  const _RoleInfoCard({required this.roleLabel});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: appColors.pageBackground,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .52)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.admin_panel_settings_rounded,
            color: appColors.accent,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Role: $roleLabel',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(
                color: appColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String roleLabel;

  const _RolePill({required this.roleLabel});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: .80),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: appColors.accent.withValues(alpha: .18)),
      ),
      child: Text(
        'Role: $roleLabel',
        style: context.text.labelSmall?.copyWith(
          color: appColors.accent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
