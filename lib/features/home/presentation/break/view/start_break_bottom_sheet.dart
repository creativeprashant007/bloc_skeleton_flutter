import 'package:stock_control_master/shared/widgets/atoms/app_box_shadow.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/features/home/presentation/break/bloc/start_break_bloc.dart';
import 'package:stock_control_master/features/home/presentation/break/bloc/start_break_event.dart';
import 'package:stock_control_master/features/home/presentation/break/bloc/start_break_state.dart';

class StartBreakBottomSheet extends StatefulWidget {
  const StartBreakBottomSheet({super.key, this.allocatedBreakMinutes});

  final int? allocatedBreakMinutes;

  @override
  State<StartBreakBottomSheet> createState() => _StartBreakBottomSheetState();
}

class _StartBreakBottomSheetState extends State<StartBreakBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  bool get _hasAllocatedBreak {
    return widget.allocatedBreakMinutes != null &&
        widget.allocatedBreakMinutes! > 0;
  }

  String get _allocatedText {
    if (!_hasAllocatedBreak) return 'Not defined';
    return '${widget.allocatedBreakMinutes} min';
  }

  String get _subtitleText {
    if (!_hasAllocatedBreak) {
      return 'No allocated break duration is defined for this shift.';
    }

    return 'You have $_allocatedText allocated break time for this shift.';
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _startBreak(BuildContext context, String breakId) {
    FocusScope.of(context).unfocus();

    context.read<StartBreakBloc>().add(
      BreakStartPressed(breakId, comment: _commentController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardBottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: BlocListener<StartBreakBloc, StartBreakState>(
          listenWhen: (previous, current) {
            return previous.shouldClose != current.shouldClose;
          },
          listener: (context, state) {
            if (state.shouldClose) {
              Navigator.of(context).pop(state.selection);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: appColors.cardBackground.withValues(
                alpha: isDark ? 0.98 : 1,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              boxShadow: AppShadows.soft(context),
            ),
            child: SafeArea(
              top: false,
              child: BlocBuilder<StartBreakBloc, StartBreakState>(
                builder: (context, state) {
                  final breakItem = state.breakOptions.isNotEmpty
                      ? state.breakOptions.first
                      : null;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      12.h,
                      20.w,
                      keyboardBottom > 0 ? 26.h : 22.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 46.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: appColors.divider.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        Row(
                          children: [
                            _CircleIconButton(
                              icon: Icons.close_rounded,
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                context.read<StartBreakBloc>().add(
                                  const StartBreakCancelPressed(),
                                );
                              },
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Start Break',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: appColors.primaryText,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    'Break details',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: appColors.secondaryText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 42.w),
                          ],
                        ),

                        SizedBox(height: 22.h),

                        _BreakInfoCard(
                          allocatedText: _allocatedText,
                          subtitleText: _subtitleText,
                        ),

                        SizedBox(height: 16.h),

                        _BreakCommentField(
                          controller: _commentController,
                          focusNode: _commentFocusNode,
                        ),

                        SizedBox(height: 16.h),

                        if (breakItem == null)
                          const _EmptyBreakCard()
                        else
                          _ProfessionalBreakTile(
                            title: breakItem.title,
                            subtitle: _hasAllocatedBreak
                                ? 'Start your allocated $_allocatedText break now'
                                : 'Start break without defined allocated minutes',
                            isPaid: breakItem.isPaid,
                            durationText: _allocatedText,
                            onTap: () => _startBreak(context, breakItem.id),
                          ),

                        SizedBox(height: 10.h),

                        Text(
                          'Only one break option is shown based on today’s shift allocation.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.secondaryText.withValues(
                              alpha: 0.8,
                            ),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BreakInfoCard extends StatelessWidget {
  final String allocatedText;
  final String subtitleText;

  const _BreakInfoCard({
    required this.allocatedText,
    required this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.accent.withValues(alpha: isDark ? 0.22 : 0.12),
            appColors.accent.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        border: Border.all(color: appColors.accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: appColors.accent.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.coffee_rounded,
              color: appColors.accent,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Allocated Break',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appColors.secondaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  allocatedText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  subtitleText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.secondaryText,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakCommentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _BreakCommentField({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comment',
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 12.5.sp,
            color: appColors.primaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          minLines: 2,
          maxLines: 3,
          scrollPadding: EdgeInsets.only(bottom: 220.h),
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: appColors.primaryText,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          decoration: InputDecoration(
            hintText: 'Add a break note...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: appColors.secondaryText.withValues(alpha: .72),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: appColors.primaryText.withValues(
              alpha: isDark ? .045 : .026,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w, bottom: 22.h),
              child: Icon(
                Icons.notes_rounded,
                size: 18.sp,
                color: appColors.accent.withValues(alpha: .82),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 42.w,
              minHeight: 44.h,
            ),
            contentPadding: EdgeInsets.fromLTRB(0, 13.h, 14.w, 13.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: appColors.divider.withValues(alpha: isDark ? .48 : .72),
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: appColors.accent.withValues(alpha: .72),
                width: 1.25.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfessionalBreakTile extends StatelessWidget {
  const _ProfessionalBreakTile({
    required this.title,
    required this.subtitle,
    required this.isPaid,
    required this.durationText,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isPaid;
  final String durationText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: appColors.divider.withValues(alpha: isDark ? 0.24 : 0.55),
        ),
        boxShadow: AppShadows.soft(context),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: appColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    color: appColors.accent,
                    size: 25.sp,
                  ),
                ),

                SizedBox(width: 13.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: appColors.primaryText,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? appColors.success.withValues(alpha: 0.12)
                                  : appColors.warning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              isPaid ? 'Paid' : 'Unpaid',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isPaid
                                    ? appColors.success
                                    : appColors.warning,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.secondaryText,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 9.h,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.accent,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: appColors.divider.withValues(alpha: 0.28),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: appColors.secondaryText, size: 21.sp),
      ),
    );
  }
}

class _EmptyBreakCard extends StatelessWidget {
  const _EmptyBreakCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: appColors.divider.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: appColors.divider.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: appColors.secondaryText,
            size: 26.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            'No break option available',
            style: theme.textTheme.titleSmall?.copyWith(
              color: appColors.primaryText,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Please refresh the shift or contact your manager.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors.secondaryText,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
