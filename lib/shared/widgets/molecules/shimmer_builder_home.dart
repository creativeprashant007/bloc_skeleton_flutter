import 'package:flutter/material.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class ShimmerBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    AnimationController controller,
    Color base,
    Color highlight,
  )
  builder;

  const ShimmerBuilder({super.key, required this.builder});

  @override
  State<ShimmerBuilder> createState() => ShimmerBuilderState();
}

class ShimmerBuilderState extends State<ShimmerBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _base(BuildContext context) {
    final appColors = context.appColors;
    final isDark = context.isDark;

    return appColors.primaryText.withValues(alpha: isDark ? .08 : .055);
  }

  Color _highlight(BuildContext context) {
    final appColors = context.appColors;
    final isDark = context.isDark;

    return appColors.primaryText.withValues(alpha: isDark ? .17 : .12);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _controller,
      _base(context),
      _highlight(context),
    );
  }
}
