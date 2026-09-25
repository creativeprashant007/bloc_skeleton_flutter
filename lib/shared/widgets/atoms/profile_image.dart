import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final BoxFit fit;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.name,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final cleanImageUrl = imageUrl.trim();

    if (cleanImageUrl.isEmpty) {
      return _InitialAvatarText(initials: _getInitials(name));
    }

    if (_isBase64Image(cleanImageUrl)) {
      return _buildBase64Image(cleanImageUrl);
    }

    return CachedNetworkImage(
      imageUrl: cleanImageUrl,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 180),
      fadeOutDuration: const Duration(milliseconds: 120),
      placeholder: (_, _) => _LoadingAvatar(name: name),
      errorWidget: (_, _, _) {
        return _InitialAvatarText(initials: _getInitials(name));
      },
      imageBuilder: (_, imageProvider) {
        return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
                alignment: Alignment.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBase64Image(String value) {
    try {
      final base64String = value.contains(',') ? value.split(',').last : value;
      final imageBytes = base64Decode(base64String);

      return SizedBox.expand(
        child: Image.memory(
          imageBytes,
          fit: fit,
          alignment: Alignment.center,
          errorBuilder: (_, _, _) {
            return _InitialAvatarText(initials: _getInitials(name));
          },
        ),
      );
    } catch (_) {
      return _InitialAvatarText(initials: _getInitials(name));
    }
  }

  bool _isBase64Image(String value) {
    return value.startsWith('data:image') || !value.startsWith('http');
  }

  String _getInitials(String value) {
    final cleanName = value.trim();

    if (cleanName.isEmpty) return 'U';

    final parts = cleanName.split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }

    return cleanName.length >= 2
        ? cleanName.substring(0, 2).toUpperCase()
        : cleanName[0].toUpperCase();
  }
}

class _LoadingAvatar extends StatelessWidget {
  final String name;

  const _LoadingAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.primary.withValues(alpha: .06),
      alignment: Alignment.center,
      child: SizedBox(
        width: 16.w,
        height: 16.w,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _InitialAvatarText extends StatelessWidget {
  final String initials;

  const _InitialAvatarText({required this.initials});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.primary.withValues(alpha: .08),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w900,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
