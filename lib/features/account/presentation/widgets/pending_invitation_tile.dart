import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:stock_control_master/features/account/domain/entities/pending_invitations_response.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart';
import 'package:stock_control_master/features/account/presentation/widgets/compact_meta.dart';
import 'package:stock_control_master/features/account/presentation/widgets/resend_mini_button.dart';
import 'package:stock_control_master/features/account/presentation/widgets/tiny_status_chip.dart';

class PendingInvitationTile extends StatelessWidget {
  final PendingInvitationData invitation;
  final bool isResending;

  const PendingInvitationTile({
    super.key,
    required this.invitation,
    required this.isResending,
  });

  Color _statusColor(AppThemeColors appColors) {
    if (invitation.isExpired) return appColors.error;
    return appColors.accent;
  }

  String get _initial {
    final name = invitation.name.trim();
    if (name.isEmpty) return '?';

    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(appColors);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? .38 : .50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .13 : .035),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(13.r),
            ),
            alignment: Alignment.center,
            child: Text(
              _initial,
              style: theme.textTheme.titleSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w800,
                fontSize: 13.sp,
              ),
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        invitation.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: appColors.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    TinyStatusChip(text: invitation.status, color: statusColor),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  invitation.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.5.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: CompactMeta(
                        icon: Icons.store_mall_directory_rounded,
                        text: invitation.branchDisplayName,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CompactMeta(
                        icon: Icons.schedule_rounded,
                        text: invitation.expiresAt,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          ResendMiniButton(
            isLoading: isResending,
            onTap: () {
              context.read<AccountBloc>().add(
                ResendInvitationPressed(invitationId: invitation.id),
              );
            },
          ),
        ],
      ),
    );
  }
}
