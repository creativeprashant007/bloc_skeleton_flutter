import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBackButton extends StatelessWidget {
  final Color? color;
  final double? size;
  final VoidCallback? onTap;

  /// If true → will show even if no back stack
  final bool forceShow;

  const AppBackButton({
    super.key,
    this.color,
    this.size,
    this.onTap,
    this.forceShow = false,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    //  Hide if no previous route
    if (!canPop && !forceShow) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return IconButton(
      onPressed: onTap ?? () => Navigator.of(context).maybePop(),
      icon: Icon(
        isIOS ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_rounded,
        size: size ?? 22.sp,
        color: color ?? theme.colorScheme.primary,
      ),
    );
  }
}
