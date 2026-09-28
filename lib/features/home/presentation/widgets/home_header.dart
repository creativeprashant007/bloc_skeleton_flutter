import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/extension/platform_extension.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_state.dart';
import 'package:stock_control_master/features/home/presentation/widgets/branch_chip.dart';
import 'package:stock_control_master/features/home/presentation/widgets/home_avatar.dart';

class HomeTopAppBar extends StatelessWidget {
  final String branchName;
  final VoidCallback onProfileTap;
  final VoidCallback? onBranchTap;

  const HomeTopAppBar({
    super.key,
    required this.branchName,
    required this.onProfileTap,
    this.onBranchTap,
  });

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';

    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isIOS = context.isIOS;
    final isDark = context.isDark;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final name = state.name.trim().isEmpty ? 'User' : state.name.trim();
        final avatarUrl = state.avatarUrl;

        return Material(
          color: appColors.pageBackground.withValues(alpha: isDark ? .98 : 1),
          surfaceTintColor: Colors.transparent,
          elevation: isIOS ? 0 : .5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: appColors.divider.withValues(alpha: isIOS ? .18 : .28),
                  width: .7.w,
                ),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onProfileTap,
                  behavior: HitTestBehavior.opaque,
                  child: Avatar(name: name, imageUrl: avatarUrl),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.secondaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: appColors.primaryText,
                          fontWeight: isIOS ? FontWeight.w800 : FontWeight.w900,
                          fontSize: 14.sp,
                          letterSpacing: isIOS ? -0.15 : 0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                BranchChip(branchName: branchName, onTap: onBranchTap),
              ],
            ),
          ),
        );
      },
    );
  }
}
