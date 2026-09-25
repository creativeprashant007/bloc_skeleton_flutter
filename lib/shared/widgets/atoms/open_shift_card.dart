import 'dart:async';

import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OpenShiftCard extends StatefulWidget {
  final String badgeText;
  final String title;
  final String subtitle;
  final String buttonText;
  final bool isLoading;
  final VoidCallback onPressed;

  const OpenShiftCard({
    super.key,
    required this.badgeText,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<OpenShiftCard> createState() => _OpenShiftCardState();
}

class _OpenShiftCardState extends State<OpenShiftCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  String get _timeText => DateFormat('hh:mm a').format(_now);
  String get _dateText => DateFormat('EEE, d MMM').format(_now);

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    final accentColor = appColors.accent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: EdgeInsets.all(isIOS ? 20.w : 18.w),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? .96 : 1),
        borderRadius: BorderRadius.circular(isIOS ? 28.r : 22.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? .32 : .42),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .24 : .055),
            blurRadius: isIOS ? 28 : 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBadge(
                text: widget.badgeText,
                isIOS: isIOS,
                accentColor: accentColor,
              ),
              const Spacer(),
              _LiveTimePill(time: _timeText, isIOS: isIOS),
            ],
          ),
          SizedBox(height: isIOS ? 20.h : 18.h),
          Row(
            children: [
              _ShiftIcon(isIOS: isIOS, accentColor: accentColor),
              SizedBox(width: isIOS ? 14.w : 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'Inter',
                        fontSize: isIOS ? 20.sp : 19.sp,
                        color: appColors.primaryText,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        letterSpacing: -0.25,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Inter',
                        fontSize: isIOS ? 13.sp : 12.sp,
                        color: appColors.secondaryText,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isIOS ? 18.h : 16.h),
          _ShiftMetaRow(
            date: _dateText,
            isIOS: isIOS,
            accentColor: accentColor,
          ),
          SizedBox(height: isIOS ? 18.h : 16.h),
          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: widget.isLoading ? null : widget.onPressed,
              icon: widget.isLoading
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator.adaptive(
                        strokeWidth: 2.2,
                      ),
                    )
                  : Icon(
                      isIOS
                          ? Icons.arrow_upward_rounded
                          : Icons.play_arrow_rounded,
                      size: isIOS ? 20.sp : 22.sp,
                    ),
              label: Text(
                widget.isLoading ? 'Starting shift...' : widget.buttonText,
                style: TextStyle(letterSpacing: -0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final bool isIOS;
  final Color accentColor;

  const _StatusBadge({
    required this.text,
    required this.isIOS,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isIOS ? 12.w : 11.w,
        vertical: isIOS ? 7.h : 6.5.h,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? .14 : .08),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: accentColor.withValues(alpha: .16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isIOS ? Icons.auto_awesome_rounded : Icons.bolt_rounded,
            size: isIOS ? 14.sp : 15.sp,
            color: accentColor,
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              fontFamily: 'Inter',
              fontSize: isIOS ? 11.5.sp : 11.sp,
              color: accentColor,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveTimePill extends StatelessWidget {
  final String time;
  final bool isIOS;

  const _LiveTimePill({required this.time, required this.isIOS});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isIOS ? 11.w : 10.w,
        vertical: isIOS ? 7.h : 6.5.h,
      ),
      decoration: BoxDecoration(
        color: appColors.primaryText.withValues(alpha: isIOS ? .035 : .045),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isIOS ? .24 : .20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: isIOS ? 14.sp : 15.sp,
            color: appColors.secondaryText,
          ),
          SizedBox(width: 6.w),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              fontFamily: 'Inter',
              fontSize: isIOS ? 11.5.sp : 11.sp,
              color: appColors.primaryText,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftIcon extends StatelessWidget {
  final bool isIOS;
  final Color accentColor;

  const _ShiftIcon({required this.isIOS, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: isIOS ? 54.w : 50.w,
      height: isIOS ? 54.w : 50.w,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? .14 : .08),
        shape: isIOS ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isIOS ? null : BorderRadius.circular(17.r),
      ),
      child: Icon(
        isIOS ? Icons.calendar_month_rounded : Icons.schedule_rounded,
        color: accentColor,
        size: isIOS ? 25.sp : 24.sp,
      ),
    );
  }
}

class _ShiftMetaRow extends StatelessWidget {
  final String date;
  final bool isIOS;
  final Color accentColor;

  const _ShiftMetaRow({
    required this.date,
    required this.isIOS,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isIOS ? 14.w : 12.w,
        vertical: isIOS ? 12.h : 11.h,
      ),
      decoration: BoxDecoration(
        color: appColors.primaryText.withValues(alpha: isDark ? .045 : .03),
        borderRadius: BorderRadius.circular(isIOS ? 20.r : 16.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? .30 : .34),
        ),
      ),
      child: Row(
        children: [
          _MetaItem(
            icon: Icons.event_available_rounded,
            label: date,
            isIOS: isIOS,
            accentColor: accentColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              width: 1,
              height: 18.h,
              color: appColors.divider.withValues(alpha: .35),
            ),
          ),
          _MetaItem(
            icon: isIOS
                ? Icons.person_outline_rounded
                : Icons.work_outline_rounded,
            label: 'Available',
            isIOS: isIOS,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isIOS;
  final Color accentColor;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.isIOS,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);

    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: isIOS ? 15.sp : 16.sp, color: accentColor),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'Inter',
                fontSize: isIOS ? 12.sp : 11.8.sp,
                color: appColors.secondaryText,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
