import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class TimesheetSectionTile extends StatelessWidget {
  const TimesheetSectionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.extraText,
    this.linkText,
    this.linkColor,
    this.workAreaText,
    this.locationText,
    this.onTap,
    this.onWorkAreaTap,
    this.onLocationTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? extraText;
  final String? linkText;
  final Color? linkColor;

  /// Example: "Bar", "Kitchen", "Floor"
  final String? workAreaText;

  /// Example: "Fait Maison Branch 1"
  final String? locationText;

  /// Whole tile tap
  final VoidCallback? onTap;

  /// Work area tap
  final VoidCallback? onWorkAreaTap;

  /// Location / branch tap
  final VoidCallback? onLocationTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: theme.dividerColor.withValues(alpha: 0.95),
            ),
            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  if (extraText != null && extraText!.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      extraText!,
                      style: textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  if ((workAreaText != null &&
                          workAreaText!.trim().isNotEmpty) ||
                      (locationText != null &&
                          locationText!.trim().isNotEmpty)) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (workAreaText != null &&
                            workAreaText!.trim().isNotEmpty)
                          _TimesheetActionChip(
                            icon: Icons.workspaces_rounded,
                            label: workAreaText!,
                            color: theme.colorScheme.primary,
                            onTap: onWorkAreaTap,
                          ),

                        if (locationText != null &&
                            locationText!.trim().isNotEmpty)
                          _TimesheetActionChip(
                            icon: Icons.location_on_rounded,
                            label: locationText!,
                            color: theme.colorScheme.tertiary,
                            onTap: onWorkAreaTap,
                          ),
                      ],
                    ),
                  ],

                  if (linkText != null && linkText!.trim().isNotEmpty) ...[
                    const SizedBox(height: 18),
                    InkWell(
                      onTap: onLocationTap,
                      child: Text(
                        linkText!,
                        style: textTheme.titleSmall?.copyWith(
                          color: linkColor ?? theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              Icons.chevron_right_rounded,
              size: 34,
              color: theme.dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimesheetActionChip extends StatelessWidget {
  const _TimesheetActionChip({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12.sp, color: color),
               SizedBox(width: 5.w),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 7.5.sp
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
