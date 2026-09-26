import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/extension/platform_extension.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/profile_image.dart';

class Avatar extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const Avatar({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = context.isIOS;

    final avatarSize = isIOS ? 48.w : 47.w;

    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          padding: EdgeInsets.all(2.2.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColors.accent.withValues(alpha: .95),
                theme.colorScheme.primary.withValues(alpha: .62),
                appColors.accent.withValues(alpha: .34),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: appColors.accent.withValues(alpha: isDark ? .18 : .16),
                blurRadius: isIOS ? 14.r : 11.r,
                offset: Offset(0, isIOS ? 6.h : 4.h),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.pageBackground,
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox.expand(
              child: ProfileImage(imageUrl: imageUrl ?? '', name: name),
            ),
          ),
        ),
        Positioned(
          right: 1.w,
          bottom: 1.w,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: appColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: appColors.pageBackground, width: 2.2.w),
              boxShadow: [
                BoxShadow(
                  color: appColors.success.withValues(alpha: .30),
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
