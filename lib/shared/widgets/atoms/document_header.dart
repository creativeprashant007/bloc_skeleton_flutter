import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/document_mini_summary_tile.dart';

class DocumentsHeader extends StatelessWidget {
  final bool isLoading;
  final int total;
  final int uploaded;
  final int missing;
  final int nearExpiry;
  final int expired;
  final String lastUpdated;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const DocumentsHeader({
    super.key,
    required this.isLoading,
    required this.total,
    required this.uploaded,
    required this.missing,
    required this.nearExpiry,
    required this.expired,
    required this.lastUpdated,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progress = total <= 0 ? 0.0 : uploaded / total;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: appColors.primaryText,
              ),
            ),
            Expanded(
              child: Text(
                'Documents',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: appColors.primaryText,
                  fontSize: 20.sp,
                ),
              ),
            ),
            IconButton(
              onPressed: isLoading ? null : onRefresh,
              icon: Icon(
                Icons.refresh_rounded,
                color: isLoading ? appColors.secondaryText : appColors.accent,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: appColors.divider.withValues(alpha: isDark ? .44 : .58),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$uploaded of $total uploaded',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                lastUpdated.trim().isEmpty
                    ? 'No recent update'
                    : 'Last updated $lastUpdated',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: appColors.secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.5.sp,
                ),
              ),
              SizedBox(height: 14.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  minHeight: 7.h,
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: appColors.divider.withValues(alpha: .36),
                  color: appColors.accent,
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: MiniSummaryTile(
                      label: 'Missing',
                      value: missing.toString(),
                      color: appColors.warning,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: MiniSummaryTile(
                      label: 'Expiring',
                      value: nearExpiry.toString(),
                      color: appColors.accent,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: MiniSummaryTile(
                      label: 'Expired',
                      value: expired.toString(),
                      color: appColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
