import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleActionTile extends StatelessWidget {
  const ScheduleActionTile({
    super.key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    required this.onTap,
    this.trailing,
  });

  final String title;
  final int count;
  final Color backgroundColor;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 58.h,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                shape: BoxShape.circle,
                boxShadow: AppShadows.soft(context),
              ),
              alignment: Alignment.center,
              child: Text(
                count.toString().padLeft(2, '0'),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.black,

                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
