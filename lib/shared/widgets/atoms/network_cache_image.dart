import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width = double.infinity,
    this.borderRadius = 20,
    this.fit = BoxFit.cover,
    this.isHorizontal = false,
    this.other = false,
  });

  final String imageUrl;
  final double? height;
  final double width;
  final double borderRadius;
  final bool isHorizontal;
  final bool other;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: other
          ? BorderRadius.circular(borderRadius)
        : isHorizontal
          ? BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              bottomLeft: Radius.circular(borderRadius),
            )
          : BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,

        // 🔹 Loading state
        placeholder: (_, _) => SizedBox(
          height: height,
          width: width,
          child: const Center(child: CircularProgressIndicator()),
        ),

        // 🔹 Error state
        errorWidget: (_, _, _) => Container(
          height: height,
          width: width,
          color: cs.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}
