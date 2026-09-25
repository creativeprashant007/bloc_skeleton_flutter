import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/shared/widgets/atoms/audio_wave_animation.dart'
    show AudioWaveAnimation;

class SpeakerLine extends StatelessWidget {
  const SpeakerLine({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSpeaking,
    required this.textStyle,
  });

  final String text;
  final VoidCallback onTap;
  final bool isSpeaking;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999.r),
          child: SizedBox(
            width: 34.w,
            height: 26.h,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: isSpeaking
                    ? AudioWaveAnimation(
                        key: const ValueKey("wave"),
                        color: cs.primary,
                        barCount: 2,
                      )
                    : Icon(
                        key: const ValueKey("icon"),
                        Icons.volume_up_rounded,
                        size: 22.sp,
                        color: cs.primary,
                      ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(child: Text(text, style: textStyle)),
      ],
    );
  }
}
