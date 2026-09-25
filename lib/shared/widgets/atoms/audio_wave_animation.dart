import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioWaveAnimation extends StatefulWidget {
  const AudioWaveAnimation({
    super.key,
    required this.color,
    this.barCount = 3,
  });

  final Color color;
  final int barCount;

  @override
  State<AudioWaveAnimation> createState() => _AudioWaveAnimationState();
}

class _AudioWaveAnimationState extends State<AudioWaveAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.h,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.barCount, (i) {
              final base = 6.h;
              final peak = (i % 2 == 0 ? 18.h : 14.h);
              final t = 0.35 + (_c.value * 0.65);
              final h = base + (peak * t);

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: 3.w,
                height: h,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
