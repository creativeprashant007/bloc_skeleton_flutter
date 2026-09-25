import 'dart:async';
import 'dart:math' as math;

import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/features/home/presentation/models/shift_ui_model.dart'
    show ShiftUiModel;

enum ShiftCardState { upcoming, active, onBreak }

class ShiftStatusCard extends StatefulWidget {
  final ShiftUiModel shift;
  final ShiftCardState state;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool isLoading;

  /// Example: 2026-04-24T14:48:28.000000Z
  final String? actualStartTime;

  const ShiftStatusCard({
    super.key,
    required this.shift,
    required this.state,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.isLoading = false,
    this.actualStartTime,
  });

  @override
  State<ShiftStatusCard> createState() => _ShiftStatusCardState();
}

class _ShiftStatusCardState extends State<ShiftStatusCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  DateTime get _startedAt {
    final raw = widget.actualStartTime?.trim();
    if (raw == null || raw.isEmpty) return widget.shift.start;
    return DateTime.tryParse(raw)?.toLocal() ?? widget.shift.start;
  }

  bool get _hasValidEndTime {
    return widget.shift.end.isAfter(widget.shift.start) &&
        widget.shift.end.difference(widget.shift.start).inMinutes > 0;
  }

  bool get _isRunning {
    return widget.state == ShiftCardState.active ||
        widget.state == ShiftCardState.onBreak;
  }

  bool get _isOpenShift => _isRunning && !_hasValidEndTime;

  bool get _isUpcomingButLate {
    return widget.state == ShiftCardState.upcoming &&
        _now.isAfter(widget.shift.start);
  }

  bool get _isLateStarted {
    return _isRunning &&
        _hasValidEndTime &&
        _startedAt.isAfter(widget.shift.start);
  }

  Duration get _assignedDuration {
    if (!_hasValidEndTime) return Duration.zero;

    final duration = widget.shift.end.difference(widget.shift.start);
    return duration.isNegative ? Duration.zero : duration;
  }

  DateTime get _expectedWorkEnd {
    if (!_isRunning) return widget.shift.end;

    if (_assignedDuration == Duration.zero) {
      return _startedAt.add(const Duration(hours: 8));
    }

    return _startedAt.add(_assignedDuration);
  }

  Duration get _runningDuration {
    final duration = _now.difference(_startedAt);
    return duration.isNegative ? Duration.zero : duration;
  }

  Duration get _lateBeforeStartDuration {
    final duration = _now.difference(widget.shift.start);
    return duration.isNegative ? Duration.zero : duration;
  }

  Duration get _lateStartedDuration {
    final duration = _startedAt.difference(widget.shift.start);
    return duration.isNegative ? Duration.zero : duration;
  }

  bool get _isOvertime {
    if (!_isRunning || !_hasValidEndTime) return false;

    return _now.isAfter(_expectedWorkEnd) &&
        _runningDuration > _assignedDuration;
  }

  bool get _showOnlyEndShiftButton {
    return widget.state == ShiftCardState.active &&
        _isOvertime &&
        widget.onSecondaryPressed != null;
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration, {bool showSeconds = false}) {
    final safe = duration.isNegative ? Duration.zero : duration;

    if (safe.inDays > 0) {
      return '${safe.inDays}d ${safe.inHours.remainder(24)}h';
    }

    if (safe.inHours > 0) {
      final value =
          '${safe.inHours}h ${safe.inMinutes.remainder(60).toString().padLeft(2, '0')}m';

      if (!showSeconds) return value;

      return '$value ${safe.inSeconds.remainder(60).toString().padLeft(2, '0')}s';
    }

    if (safe.inMinutes > 0) {
      final value = '${safe.inMinutes}m';

      if (!showSeconds) return value;

      return '$value ${safe.inSeconds.remainder(60).toString().padLeft(2, '0')}s';
    }

    return showSeconds ? '${safe.inSeconds}s' : '0m';
  }

  String _formatTime(BuildContext context, DateTime value) {
    return TimeOfDay.fromDateTime(value).format(context);
  }

  Duration _remainingDuration() {
    if (!_isRunning) return Duration.zero;

    final remaining = _expectedWorkEnd.difference(_now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Duration _overtimeDuration() {
    if (!_isOvertime) return Duration.zero;

    final overtime = _now.difference(_expectedWorkEnd);
    return overtime.isNegative ? Duration.zero : overtime;
  }

  String _statusLabel() {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        return _isUpcomingButLate ? 'Late' : 'Upcoming';

      case ShiftCardState.active:
        return _isOvertime ? 'Overtime' : 'On Shift';

      case ShiftCardState.onBreak:
        return _isOvertime ? 'Overtime' : 'On Break';
    }
  }

  IconData _statusIcon() {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        return _isUpcomingButLate
            ? Icons.warning_amber_rounded
            : Icons.event_available_rounded;

      case ShiftCardState.active:
        return _isOvertime
            ? Icons.priority_high_rounded
            : Icons.work_history_rounded;

      case ShiftCardState.onBreak:
        return _isOvertime
            ? Icons.priority_high_rounded
            : Icons.free_breakfast_rounded;
    }
  }

  String _headline() {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        if (_isUpcomingButLate) {
          return '${_formatDuration(_lateBeforeStartDuration, showSeconds: true)} late';
        }

        return 'Starts in ${_formatDuration(widget.shift.timeUntilStart, showSeconds: true)}';

      case ShiftCardState.active:
        if (_isOvertime) {
          return 'Overtime ${_formatDuration(_overtimeDuration(), showSeconds: true)}';
        }

        return 'Worked ${_formatDuration(_runningDuration, showSeconds: true)}';

      case ShiftCardState.onBreak:
        if (_isOvertime) {
          return 'Overtime ${_formatDuration(_overtimeDuration(), showSeconds: true)}';
        }

        return 'Break in progress';
    }
  }

  String _subHeadline(BuildContext context) {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        if (_isUpcomingButLate) {
          return 'Scheduled start was ${_formatTime(context, widget.shift.start)}';
        }

        if (!_hasValidEndTime) return 'Open shift';

        return '${_formatTime(context, widget.shift.start)} - ${_formatTime(context, widget.shift.end)}';

      case ShiftCardState.active:
      case ShiftCardState.onBreak:
        if (_isOpenShift) {
          return 'Started at ${_formatTime(context, _startedAt)}';
        }

        if (_isOvertime) {
          return 'Expected end was ${_formatTime(context, _expectedWorkEnd)}';
        }

        return 'Started ${_formatTime(context, _startedAt)} • Ends ${_formatTime(context, _expectedWorkEnd)}';
    }
  }

  String _primaryLabel() {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        return 'Start Shift';

      case ShiftCardState.active:
        return 'Take Break';

      case ShiftCardState.onBreak:
        return 'Resume Work';
    }
  }

  IconData _primaryIcon() {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        return Icons.login_rounded;

      case ShiftCardState.active:
        return Icons.free_breakfast_rounded;

      case ShiftCardState.onBreak:
        return Icons.play_arrow_rounded;
    }
  }

  String _secondaryLabel() {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        return 'Details';

      case ShiftCardState.active:
      case ShiftCardState.onBreak:
        return 'End Shift';
    }
  }

  IconData _secondaryIcon() {
    switch (widget.state) {
      case ShiftCardState.upcoming:
        return Icons.info_outline_rounded;

      case ShiftCardState.active:
      case ShiftCardState.onBreak:
        return Icons.logout_rounded;
    }
  }

  Color _stateColor(BuildContext context) {
    final appColors = context.appColors;

    if (_isOvertime || _isUpcomingButLate) return appColors.error;

    switch (widget.state) {
      case ShiftCardState.upcoming:
        return Theme.of(context).colorScheme.primary;

      case ShiftCardState.active:
        return appColors.success;

      case ShiftCardState.onBreak:
        return appColors.warning;
    }
  }

  Widget _buildProgress(BuildContext context) {
    return _ShiftTimelineBar(
      scheduledStart: widget.shift.start,
      scheduledEnd: _hasValidEndTime ? widget.shift.end : null,
      actualStart: _isRunning ? _startedAt : null,
      expectedWorkEnd: _isRunning && _hasValidEndTime ? _expectedWorkEnd : null,
      now: _now,
      isRunning: _isRunning,
      isOpenShift: _isOpenShift,
      isOnBreak: widget.state == ShiftCardState.onBreak,
      isLateBeforeStart: _isUpcomingButLate,
      visualOpenShiftDuration: const Duration(hours: 8),
    );
  }

  List<Widget> _summaryItems(BuildContext context) {
    final appColors = context.appColors;

    return [
      _SummaryPill(
        icon: Icons.schedule_rounded,
        label: _hasValidEndTime
            ? '${_formatTime(context, widget.shift.start)} - ${_formatTime(context, widget.shift.end)}'
            : 'Open shift',
      ),
      if (_isRunning)
        _SummaryPill(
          icon: Icons.login_rounded,
          label: 'Started ${_formatTime(context, _startedAt)}',
          color: appColors.success,
        ),
      if (_isRunning && !_isOpenShift)
        _SummaryPill(
          icon: Icons.flag_rounded,
          label: _isOvertime
              ? 'Expected ${_formatTime(context, _expectedWorkEnd)}'
              : 'Ends ${_formatTime(context, _expectedWorkEnd)}',
          color: _isOvertime ? appColors.error : appColors.accent,
        ),
      if (_isLateStarted)
        _SummaryPill(
          icon: Icons.warning_amber_rounded,
          label: '${_formatDuration(_lateStartedDuration)} late',
          color: appColors.error,
        ),
      if (widget.state == ShiftCardState.onBreak)
        _SummaryPill(
          icon: Icons.free_breakfast_rounded,
          label: widget.shift.breakMinutes > 0
              ? '${widget.shift.breakMinutes}m break'
              : 'On break',
          color: appColors.warning,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);
    final stateColor = _stateColor(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: EdgeInsets.all(isIOS ? 18.w : 16.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .97 : 1),
        borderRadius: BorderRadius.circular(isIOS ? 30.r : 24.r),
        border: Border.all(color: stateColor.withValues(alpha: .16)),
        boxShadow: AppShadows.soft(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopStatusRow(
            status: _statusLabel(),
            icon: _statusIcon(),
            color: stateColor,
            currentTime: _formatTime(context, _now),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TitleBlock(
                  title: widget.shift.title,
                  headline: _headline(),
                  subtitle: _subHeadline(context),
                  headlineColor: stateColor,
                ),
              ),
              SizedBox(width: 10.w),
              _CompactLocationChip(location: widget.shift.location),
            ],
          ),
          SizedBox(height: 16.h),
          _buildProgress(context),
          SizedBox(height: 16.h),
          Wrap(spacing: 8.w, runSpacing: 8.h, children: _summaryItems(context)),
          SizedBox(height: 20.h),
          _ActionButtons(
            isLoading: widget.isLoading,
            primaryLabel: _primaryLabel(),
            primaryIcon: _primaryIcon(),
            onPrimaryPressed: widget.onPrimaryPressed,
            secondaryLabel: _secondaryLabel(),
            secondaryIcon: _secondaryIcon(),
            onSecondaryPressed: widget.onSecondaryPressed,
            isDangerSecondary:
                widget.state == ShiftCardState.active ||
                widget.state == ShiftCardState.onBreak,
            showOnlySecondary: _showOnlyEndShiftButton,
          ),
        ],
      ),
    );
  }
}

class _ShiftTimelineBar extends StatelessWidget {
  final DateTime scheduledStart;
  final DateTime? scheduledEnd;
  final DateTime? actualStart;
  final DateTime? expectedWorkEnd;
  final DateTime now;
  final bool isRunning;
  final bool isOpenShift;
  final bool isOnBreak;
  final bool isLateBeforeStart;
  final Duration visualOpenShiftDuration;

  const _ShiftTimelineBar({
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.actualStart,
    required this.expectedWorkEnd,
    required this.now,
    required this.isRunning,
    required this.isOpenShift,
    required this.isOnBreak,
    required this.isLateBeforeStart,
    required this.visualOpenShiftDuration,
  });

  double _pos(DateTime value, DateTime start, DateTime end) {
    final total = end.difference(start).inSeconds;
    if (total <= 0) return 0;

    final current = value.difference(start).inSeconds;
    return (current / total).clamp(0.0, 1.0);
  }

  DateTime _minDate(List<DateTime> values) {
    return values.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  DateTime _maxDate(List<DateTime> values) {
    return values.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  DateTime _max(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final runningStart = actualStart;

    final assignedEnd =
        scheduledEnd ??
        (runningStart ?? scheduledStart).add(visualOpenShiftDuration);

    final workEnd = expectedWorkEnd ?? assignedEnd;

    final hasActualStart = isRunning && runningStart != null;
    final hasWorked = hasActualStart && now.isAfter(runningStart);
    final hasLateStart =
        hasActualStart && !isOpenShift && runningStart.isAfter(scheduledStart);
    final hasOvertime = hasActualStart && !isOpenShift && now.isAfter(workEnd);

    final timelineStart = isOpenShift
        ? (runningStart ?? scheduledStart)
        : _minDate([scheduledStart, ?runningStart]);

    final timelineEnd = isOpenShift
        ? _maxDate([
            timelineStart.add(visualOpenShiftDuration),
            if (isRunning) now,
          ])
        : _maxDate([
            assignedEnd,
            workEnd,
            if (isRunning || isLateBeforeStart) now,
            ?runningStart,
          ]);

    final scheduledStartPos = _pos(scheduledStart, timelineStart, timelineEnd);
    final scheduledEndPos = _pos(assignedEnd, timelineStart, timelineEnd);

    final normalStart = isOpenShift
        ? (runningStart ?? timelineStart)
        : (runningStart ?? scheduledStart);

    final normalEnd = hasOvertime ? workEnd : now;
    final shouldShowNormal = hasWorked && normalEnd.isAfter(normalStart);
    final shouldShowOvertime = hasOvertime && now.isAfter(workEnd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16.h,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              Widget segment({
                required DateTime from,
                required DateTime to,
                required Color color,
              }) {
                final fromPos = _pos(from, timelineStart, timelineEnd);
                final toPos = _pos(to, timelineStart, timelineEnd);

                final left = width * fromPos.clamp(0.0, 1.0);
                final right = width * toPos.clamp(0.0, 1.0);
                final segmentWidth = math.max(0.0, right - left);

                if (segmentWidth <= 0) return const SizedBox.shrink();

                return Positioned(
                  left: left,
                  width: segmentWidth,
                  top: 0,
                  bottom: 0,
                  child: DecoratedBox(decoration: BoxDecoration(color: color)),
                );
              }

              Widget marker({
                required DateTime at,
                required Color color,
                double markerWidth = 2.5,
              }) {
                final position = _pos(at, timelineStart, timelineEnd);

                return Positioned(
                  left: (width * position).clamp(0, width - markerWidth),
                  top: 0,
                  bottom: 0,
                  child: Container(width: markerWidth, color: color),
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: appColors.divider.withValues(alpha: .20),
                      ),
                    ),
                    if (!isOpenShift)
                      Positioned(
                        left: width * scheduledStartPos,
                        width: math.max(
                          0,
                          (width * scheduledEndPos) -
                              (width * scheduledStartPos),
                        ),
                        top: 0,
                        bottom: 0,
                        child: Container(
                          color: appColors.divider.withValues(alpha: .36),
                        ),
                      ),
                    if (isLateBeforeStart && !isRunning)
                      segment(
                        from: scheduledStart,
                        to: now,
                        color: appColors.error.withValues(alpha: .90),
                      ),
                    if (hasLateStart)
                      segment(
                        from: scheduledStart,
                        to: runningStart,
                        color: appColors.error.withValues(alpha: .90),
                      ),
                    if (shouldShowNormal)
                      segment(
                        from: normalStart,
                        to: _max(normalStart, normalEnd),
                        color: isOnBreak
                            ? appColors.warning.withValues(alpha: .92)
                            : appColors.success,
                      ),
                    if (shouldShowOvertime)
                      segment(from: workEnd, to: now, color: appColors.error),
                    if (!isOpenShift)
                      marker(
                        at: scheduledStart,
                        color: appColors.primaryText.withValues(alpha: .28),
                      ),
                    if (!isOpenShift)
                      marker(
                        at: assignedEnd,
                        color: appColors.primaryText.withValues(alpha: .28),
                      ),
                    if (isRunning || isLateBeforeStart)
                      marker(
                        at: now,
                        color: appColors.primaryText.withValues(alpha: .72),
                        markerWidth: 3.w,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 6.h,
          children: [
            if (!isOpenShift)
              _TimelineLegend(
                color: appColors.divider.withValues(alpha: .75),
                label: 'Scheduled',
              ),
            if ((isLateBeforeStart && !isRunning) || hasLateStart)
              _TimelineLegend(color: appColors.error, label: 'Late'),
            if (isRunning)
              _TimelineLegend(
                color: isOnBreak ? appColors.warning : appColors.success,
                label: isOnBreak ? 'Break' : 'Worked',
              ),
            if (hasOvertime)
              _TimelineLegend(color: appColors.error, label: 'Overtime'),
          ],
        ),
      ],
    );
  }
}

class _TopStatusRow extends StatelessWidget {
  final String status;
  final IconData icon;
  final Color color;
  final String currentTime;

  const _TopStatusRow({
    required this.status,
    required this.icon,
    required this.color,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .11),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: color.withValues(alpha: .18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15.sp, color: color),
              SizedBox(width: 6.w),
              Text(
                status,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 12.sp,
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          currentTime,
          style: theme.textTheme.labelLarge?.copyWith(
            color: appColors.primaryText,
            fontWeight: FontWeight.w900,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final String title;
  final String headline;
  final String subtitle;
  final Color headlineColor;

  const _TitleBlock({
    required this.title,
    required this.headline,
    required this.subtitle,
    required this.headlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: appColors.primaryText,
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
            height: 1.08,
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          headline,
          style: theme.textTheme.titleMedium?.copyWith(
            color: headlineColor,
            fontWeight: FontWeight.w900,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: appColors.secondaryText,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _CompactLocationChip extends StatelessWidget {
  final String location;

  const _CompactLocationChip({required this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    if (location.trim().isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: location,
      child: Container(
        constraints: BoxConstraints(maxWidth: 125.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: appColors.primaryText.withValues(alpha: isDark ? .052 : .038),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: appColors.divider.withValues(alpha: .32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 12.sp,
              color: appColors.accent,
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: appColors.secondaryText,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _TimelineLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7.w,
          height: 7.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 11.sp,
            color: appColors.secondaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SummaryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _SummaryPill({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = color ?? appColors.secondaryText;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: appColors.primaryText.withValues(alpha: isDark ? .052 : .04),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: appColors.divider.withValues(alpha: .30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: effectiveColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color ?? appColors.primaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isLoading;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimaryPressed;
  final String secondaryLabel;
  final IconData secondaryIcon;
  final VoidCallback? onSecondaryPressed;
  final bool isDangerSecondary;
  final bool showOnlySecondary;

  const _ActionButtons({
    required this.isLoading,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimaryPressed,
    required this.secondaryLabel,
    required this.secondaryIcon,
    required this.onSecondaryPressed,
    required this.isDangerSecondary,
    this.showOnlySecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final radius = 16.r;

    if (showOnlySecondary && onSecondaryPressed != null) {
      return SizedBox(
        width: double.infinity,

        child: OutlinedButton.icon(
          onPressed: isLoading ? null : onSecondaryPressed,
          icon: Icon(secondaryIcon, size: 17.sp),
          label: Text(secondaryLabel),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: appColors.error, width: 1.2),
            foregroundColor: appColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            textStyle: theme.textTheme.titleSmall?.copyWith(),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onPrimaryPressed,
              icon: isLoading
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(primaryIcon, size: 17.sp),
              label: Text(
                primaryLabel,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        if (onSecondaryPressed != null) ...[
          SizedBox(width: 10.w),
          Expanded(
            child: SizedBox(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : onSecondaryPressed,
                icon: Icon(
                  secondaryIcon,
                  size: 17.sp,
                  color: isDangerSecondary
                      ? appColors.error
                      : appColors.divider.withValues(alpha: .65),
                ),
                label: Text(secondaryLabel),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDangerSecondary
                        ? appColors.error
                        : appColors.divider.withValues(alpha: .65),
                    width: 1.1,
                  ),
                  foregroundColor: isDangerSecondary
                      ? appColors.error
                      : appColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
