import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_state.dart';
import 'package:stock_control_master/shared/widgets/atoms/account_empty_pending_card.dart';
import 'package:stock_control_master/shared/widgets/atoms/account_pending_header.dart';
import 'package:stock_control_master/shared/widgets/atoms/pending_invitation_tile.dart';

class PendingInvitationsSection extends StatelessWidget {
  final AccountState state;

  const PendingInvitationsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PendingHeader(
          count: state.pendingInvitations.length,
          isLoading: state.isPendingInvitationsLoading,
        ),
        SizedBox(height: 10.h),
        if (state.isPendingInvitationsLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        else if (state.pendingInvitations.isEmpty)
          EmptyPendingCard(appColors: appColors)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.pendingInvitations.length,
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (_, index) {
              final invitation = state.pendingInvitations[index];

              return PendingInvitationTile(
                invitation: invitation,
                isResending: state.resendingInvitationId == invitation.id,
              );
            },
          ),
      ],
    );
  }
}
