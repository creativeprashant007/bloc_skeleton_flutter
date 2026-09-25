import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

import 'package:stock_control_master/core/theme/theme_extension.dart';

/// Displays the employee comment and manager notes cards side by side
/// (stacked) on the timesheet detail screen.
class NotesPanel extends StatelessWidget {
  final String employeeNotes;
  final String managerNotes;
  final bool canManageTimesheet;
  final VoidCallback? onManagerNotesTap;

  const NotesPanel({
    super.key,
    required this.employeeNotes,
    required this.managerNotes,
    required this.canManageTimesheet,
    required this.onManagerNotesTap,
  });

  String _display(String value, String emptyText) {
    final clean = value.trim();

    if (clean.isEmpty) return emptyText;

    return clean;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NoteCard(
          icon: Icons.person_rounded,
          title: 'Team member comment',
          subtitle: 'Submitted by employee',
          value: _display(employeeNotes, 'No team member comment'),
          accentType: _NoteAccentType.employee,
          linkText: null,
          onTap: null,
        ),
        SizedBox(height: 12.h),
        _NoteCard(
          icon: Icons.admin_panel_settings_rounded,
          title: 'Manager notes',
          subtitle: canManageTimesheet
              ? 'Visible to employee'
              : 'Shared by manager',
          value: _display(managerNotes, 'No manager notes'),
          accentType: _NoteAccentType.manager,
          linkText: canManageTimesheet ? 'Edit notes' : null,
          onTap: onManagerNotesTap,
        ),
      ],
    );
  }
}

enum _NoteAccentType { employee, manager }

class _NoteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final _NoteAccentType accentType;
  final String? linkText;
  final VoidCallback? onTap;

  const _NoteCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accentType,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final Color accentColor = accentType == _NoteAccentType.employee
        ? appColors.accent
        : appColors.success;

    final bool isEmpty = value.toLowerCase().startsWith('no ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: appColors.cardBackground.withValues(alpha: isDark ? .92 : 1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: appColors.divider.withValues(alpha: .48)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .12 : .035),
                blurRadius: 14.r,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: accentColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: appColors.primaryText,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: appColors.secondaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (linkText != null && onTap != null) ...[
                          SizedBox(width: 8.w),
                          Text(
                            linkText!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isEmpty
                            ? appColors.secondaryText
                            : appColors.primaryText,
                        fontWeight: isEmpty ? FontWeight.w600 : FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
