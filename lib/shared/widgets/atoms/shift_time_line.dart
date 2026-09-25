import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class ShiftTimelineProgressBar extends StatelessWidget {
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final DateTime? actualStart;
  final DateTime now;
  final bool isOnBreak;
  final bool isStarted;

  const ShiftTimelineProgressBar({
    super.key,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.now,
    this.actualStart,
    this.isOnBreak = false,
    this.isStarted = false,
  });

  double _minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inSeconds / 60;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final hasActualStart = actualStart != null;
    final startTime = actualStart ?? scheduledStart;

    final timelineStart = [
      scheduledStart,
      if (hasActualStart) startTime,
    ].reduce((a, b) => a.isBefore(b) ? a : b);

    final timelineEnd = [
      scheduledEnd,
      now,
      if (hasActualStart) startTime,
    ].reduce((a, b) => a.isAfter(b) ? a : b);

    final totalMinutes = _minutesBetween(timelineStart, timelineEnd);

    if (totalMinutes <= 0) {
      return _emptyBar(context);
    }

    double fraction(DateTime from, DateTime to) {
      final safeFrom = from.isBefore(timelineStart) ? timelineStart : from;
      final safeTo = to.isAfter(timelineEnd) ? timelineEnd : to;

      if (!safeTo.isAfter(safeFrom)) return 0;

      return (_minutesBetween(safeFrom, safeTo) / totalMinutes).clamp(0.0, 1.0);
    }

    final segments = <_ProgressSegment>[];

    /// Early start: actual start before scheduled start
    if (hasActualStart && startTime.isBefore(scheduledStart)) {
      segments.add(
        _ProgressSegment(
          value: fraction(startTime, scheduledStart),
          color: theme.colorScheme.primary,
        ),
      );
    }

    /// Late but not started yet:
    /// scheduled start -> now
    if (!isStarted && now.isAfter(scheduledStart)) {
      segments.add(
        _ProgressSegment(
          value: fraction(scheduledStart, now),
          color: appColors.warning,
        ),
      );
    }

    /// Late after started:
    /// scheduled start -> actual start
    if (isStarted && hasActualStart && startTime.isAfter(scheduledStart)) {
      segments.add(
        _ProgressSegment(
          value: fraction(scheduledStart, startTime),
          color: appColors.warning,
        ),
      );
    }

    /// Regular worked time:
    /// max(actual start, scheduled start) -> min(now, scheduled end)
    if (isStarted) {
      final regularStart = startTime.isAfter(scheduledStart)
          ? startTime
          : scheduledStart;

      final regularEnd = now.isBefore(scheduledEnd) ? now : scheduledEnd;

      segments.add(
        _ProgressSegment(
          value: fraction(regularStart, regularEnd),
          color: isOnBreak ? appColors.warning : appColors.success,
        ),
      );
    }

    /// Overtime:
    /// scheduled end -> now
    if (isStarted && now.isAfter(scheduledEnd)) {
      segments.add(
        _ProgressSegment(
          value: fraction(scheduledEnd, now),
          color: appColors.error,
        ),
      );
    }

    /// Remaining scheduled time:
    /// now -> scheduled end
    if (now.isBefore(scheduledEnd)) {
      final remainingStart = now.isAfter(scheduledStart) ? now : scheduledStart;

      segments.add(
        _ProgressSegment(
          value: fraction(remainingStart, scheduledEnd),
          color: theme.colorScheme.outline.withValues(alpha: .10),
        ),
      );
    }

    final visibleSegments = segments.where((e) => e.value > 0).toList();

    if (visibleSegments.isEmpty) {
      return _emptyBar(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: SizedBox(
        height: 8.h,
        width: double.infinity,
        child: Row(
          children: visibleSegments.map((segment) {
            return Expanded(
              flex: (segment.value * 10000).round().clamp(1, 10000),
              child: Container(color: segment.color),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _emptyBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 8.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(100.r),
      ),
    );
  }
}

class _ProgressSegment {
  final double value;
  final Color color;

  const _ProgressSegment({required this.value, required this.color});
}
