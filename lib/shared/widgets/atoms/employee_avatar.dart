import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:stock_control_master/shared/widgets/atoms/initials_avatar.dart';

class EmployeeAvatar extends StatelessWidget {
  final String name;
  final String image;
  final double size;

  const EmployeeAvatar({
    super.key,
    required this.name,
    required this.image,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final imageBytes = _decodeBase64Image(image);
    final imageUrl = image.trim();

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.accent.withValues(alpha: 0.12),
        border: Border.all(
          color: appColors.accent.withValues(alpha: 0.22),
          width: 1.2.w,
        ),
      ),
      child: ClipOval(
        child: imageBytes != null
            ? Image.memory(
                imageBytes,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return InitialsAvatar(name: name);
                },
              )
            : _isNetworkImage(imageUrl)
            ? Image.network(
                imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return InitialsAvatar(name: name);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    color: appColors.accent.withValues(alpha: 0.08),
                    child: Center(
                      child: SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                },
              )
            : InitialsAvatar(name: name),
      ),
    );
  }

  bool _isNetworkImage(String value) {
    final text = value.trim().toLowerCase();

    return text.startsWith('http://') || text.startsWith('https://');
  }

  Uint8List? _decodeBase64Image(String value) {
    final raw = value.trim();

    if (raw.isEmpty || raw.toLowerCase() == 'null') return null;

    if (_isNetworkImage(raw)) return null;

    try {
      final normalized = raw.contains(',') ? raw.split(',').last : raw;

      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }
}
