import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/shared/widgets/atoms/quick_day_button.dart';

class QuickDaySwitch extends StatelessWidget {
  final bool isOvernight;
  final VoidCallback onSameDay;
  final VoidCallback onNextDay;

  const QuickDaySwitch({
    super.key,
    required this.isOvernight,
    required this.onSameDay,
    required this.onNextDay,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: QuickDayButton(
            text: 'Same day',
            icon: Icons.wb_sunny_rounded,
            selected: !isOvernight,
            onTap: onSameDay,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: QuickDayButton(
            text: 'Next day',
            icon: Icons.nights_stay_rounded,
            selected: isOvernight,
            onTap: onNextDay,
          ),
        ),
      ],
    );
  }
}
