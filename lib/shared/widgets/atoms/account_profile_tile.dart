import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

import 'profile_image.dart' show ProfileImage;

class AccountProfileTile extends StatelessWidget {
  final String imageAsset;
  final String imageAssetUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AccountProfileTile({
    super.key,
    required this.imageAsset,
    required this.imageAssetUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  Widget _buildAvatar(BuildContext context) {
    final image = imageAssetUrl.trim().isNotEmpty
        ? imageAssetUrl.trim()
        : imageAsset.trim();

    return ProfileImage(imageUrl: image, name: title);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final topBg = isDark
        ? const Color(0xFF555858)
        : theme.colorScheme.primary.withValues(alpha: 0.18);

    final bottomBg = isDark
        ? const Color(0xFF02111C)
        : theme.scaffoldBackgroundColor;

    final nameColor = isDark ? Colors.white : theme.colorScheme.onSurface;

    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.92)
        : theme.colorScheme.onSurface.withValues(alpha: 0.72);

    return Column(
      children: [
        SizedBox(
          height: 238.h,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: topBg,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.elliptical(300, 70),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(width: double.infinity, color: bottomBg),
                  ),
                ],
              ),
              Positioned(
                bottom: 6.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 128.w,
                      width: 128.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? const Color(0xFFBDE4FF)
                            : theme.colorScheme.surface,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildAvatar(context),
                    ),
                    Positioned(
                      right: -4.w,
                      bottom: 6.h,
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          height: 46.w,
                          width: 46.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF2B2C31)
                                : theme.colorScheme.surface,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : theme.dividerColor.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.16),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            color: isDark
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: nameColor,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: subtitleColor,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
