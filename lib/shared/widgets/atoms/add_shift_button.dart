import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'dotted_border_painter.dart' show DottedBorderPainter;

class AddShiftButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isPastDate;

  const AddShiftButton({
    super.key,
    required this.onTap,
    required this.isPastDate,
  });

  @override
  State<AddShiftButton> createState() => AddShiftButtonState();
}

class AddShiftButtonState extends State<AddShiftButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final isPast = widget.isPastDate;

    final Color mainColor = isPast ? appColors.warning : appColors.accent;

    final IconData icon = isPast ? Icons.add_box_rounded : Icons.add_rounded;

    final borderRadius = BorderRadius.circular(12.r);

    final borderColor = mainColor.withValues(alpha: isDark ? 0.66 : 0.50);

    final backgroundColor = mainColor.withValues(alpha: isDark ? 0.12 : 0.075);

    final textColor = mainColor.withValues(alpha: isDark ? 0.95 : 0.92);

    return Padding(
      padding: EdgeInsets.only(top: 4.h, right: 3.w),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: SizedBox(
          height: 42.h,
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: _setPressed,
              borderRadius: borderRadius,
              splashColor: mainColor.withValues(alpha: 0.08),
              highlightColor: mainColor.withValues(alpha: 0.05),
              child: CustomPaint(
                painter: DottedBorderPainter(
                  color: borderColor,
                  strokeWidth: 1.15.w,
                  radius: 12.r,
                  dashWidth: isPast ? 5.w : 4.w,
                  dashGap: isPast ? 3.5.w : 3.w,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: mainColor.withValues(alpha: 0.13),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: isPast ? 11.5.sp : 14.sp,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
