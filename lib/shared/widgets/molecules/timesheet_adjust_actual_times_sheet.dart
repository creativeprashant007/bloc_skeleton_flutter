// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// import 'package:stock_control_master/core/helper/date_picker/app_date_time_picker.dart';
// import 'package:stock_control_master/core/theme/theme_extension.dart';
// import 'package:stock_control_master/features/timesheet_details/presentation/bloc/timesheet_detail_state.dart';

// class AdjustActualTimesheetResult {
//   final String startTime;
//   final String endTime;
//   final String breakMinutes;
//   final String comment;

//   const AdjustActualTimesheetResult({
//     required this.startTime,
//     required this.endTime,
//     required this.breakMinutes,
//     required this.comment,
//   });
// }

// class TimesheetAdjustActualTimesSheet extends StatefulWidget {
//   final TimesheetDetailState state;

//   const TimesheetAdjustActualTimesSheet({super.key, required this.state});

//   @override
//   State<TimesheetAdjustActualTimesSheet> createState() =>
//       _TimesheetAdjustActualTimesSheetState();
// }

// class _TimesheetAdjustActualTimesSheetState
//     extends State<TimesheetAdjustActualTimesSheet> {
//   late final TextEditingController _breakController;
//   late final TextEditingController _commentController;

//   late final ScrollController _scrollController;
//   late final FocusNode _breakFocusNode;
//   late final FocusNode _commentFocusNode;

//   final GlobalKey _breakFieldKey = GlobalKey();
//   final GlobalKey _commentFieldKey = GlobalKey();
//   final GlobalKey _actionsKey = GlobalKey();

//   DateTime? _startDateTime;
//   DateTime? _endDateTime;

//   int? _recommendedBreakMinutes;
//   String? _timeError;
//   String? _breakError;

//   @override
//   void initState() {
//     super.initState();

//     final baseDate = _baseDate();

//     _startDateTime = _parseEditableTime(
//       widget.state.editableStartTime,
//       fallbackDate: baseDate,
//       rawApiDateTime: widget.state.actualCheckInTime,
//     );

//     _endDateTime = _parseEditableTime(
//       widget.state.editableEndTime,
//       fallbackDate: baseDate,
//       rawApiDateTime: widget.state.actualCheckOutTime,
//     );

//     _breakController = TextEditingController(
//       text: widget.state.editableBreakMinutes,
//     );

//     _commentController = TextEditingController(
//       text: widget.state.editableComment,
//     );

//     _scrollController = ScrollController();
//     _breakFocusNode = FocusNode();
//     _commentFocusNode = FocusNode();

//     _breakFocusNode.addListener(() {
//       if (_breakFocusNode.hasFocus) _ensureVisible(_breakFieldKey);
//     });

//     _commentFocusNode.addListener(() {
//       if (_commentFocusNode.hasFocus) _ensureVisible(_commentFieldKey);
//     });

//     _syncRecommendedBreak();
//   }

//   @override
//   void dispose() {
//     _breakController.dispose();
//     _commentController.dispose();
//     _scrollController.dispose();
//     _breakFocusNode.dispose();
//     _commentFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> _ensureVisible(GlobalKey key) async {
//     await Future<void>.delayed(const Duration(milliseconds: 260));

//     if (!mounted) return;

//     final targetContext = key.currentContext;
//     if (targetContext == null) return;

//     await Scrollable.ensureVisible(
//       targetContext,
//       duration: const Duration(milliseconds: 230),
//       curve: Curves.easeOutCubic,
//       alignment: 0.18,
//       alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
//     );
//   }

//   Future<void> _ensureActionsVisible() async {
//     await Future<void>.delayed(const Duration(milliseconds: 80));

//     if (!mounted) return;

//     final targetContext = _actionsKey.currentContext;
//     if (targetContext == null) return;

//     await Scrollable.ensureVisible(
//       targetContext,
//       duration: const Duration(milliseconds: 220),
//       curve: Curves.easeOutCubic,
//       alignment: 0.92,
//       alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
//     );
//   }

//   DateTime _baseDate() {
//     final checkInRaw = widget.state.actualCheckInTime.trim();
//     final fromCheckIn = DateTime.tryParse(checkInRaw);

//     if (fromCheckIn != null) {
//       final local = fromCheckIn.isUtc || _hasTimezoneOffset(checkInRaw)
//           ? fromCheckIn.toLocal()
//           : fromCheckIn;

//       return DateTime(local.year, local.month, local.day);
//     }

//     final checkOutRaw = widget.state.actualCheckOutTime.trim();
//     final fromCheckOut = DateTime.tryParse(checkOutRaw);

//     if (fromCheckOut != null) {
//       final local = fromCheckOut.isUtc || _hasTimezoneOffset(checkOutRaw)
//           ? fromCheckOut.toLocal()
//           : fromCheckOut;

//       return DateTime(local.year, local.month, local.day);
//     }

//     final formats = [
//       DateFormat('EEEE d MMMM yyyy'),
//       DateFormat('EEE d MMM yyyy'),
//       DateFormat('dd/MM/yyyy'),
//       DateFormat('yyyy-MM-dd'),
//     ];

//     for (final format in formats) {
//       try {
//         final parsed = format.parseStrict(widget.state.dateText.trim());
//         return DateTime(parsed.year, parsed.month, parsed.day);
//       } catch (_) {}
//     }

//     final now = DateTime.now();
//     return DateTime(now.year, now.month, now.day);
//   }

//   DateTime? _parseEditableTime(
//     String value, {
//     required DateTime fallbackDate,
//     required String rawApiDateTime,
//   }) {
//     final raw = rawApiDateTime.trim();

//     final rawParsed = DateTime.tryParse(raw);
//     if (rawParsed != null) {
//       if (rawParsed.isUtc || _hasTimezoneOffset(raw)) {
//         return rawParsed.toLocal();
//       }

//       return rawParsed;
//     }

//     final clean = value.trim();
//     if (clean.isEmpty || clean.toLowerCase() == 'open') return null;

//     final timeMatch = RegExp(
//       r'^(\d{1,2}):(\d{2})(?::\d{2})?$',
//     ).firstMatch(clean);

//     if (timeMatch != null) {
//       final hour = int.tryParse(timeMatch.group(1) ?? '');
//       final minute = int.tryParse(timeMatch.group(2) ?? '');

//       if (hour != null &&
//           minute != null &&
//           hour >= 0 &&
//           hour <= 23 &&
//           minute >= 0 &&
//           minute <= 59) {
//         return DateTime(
//           fallbackDate.year,
//           fallbackDate.month,
//           fallbackDate.day,
//           hour,
//           minute,
//         );
//       }
//     }

//     final formats = [
//       DateFormat('hh:mm a'),
//       DateFormat('h:mm a'),
//       DateFormat('HH:mm'),
//       DateFormat('H:mm'),
//     ];

//     for (final format in formats) {
//       try {
//         final parsed = format.parseStrict(clean.toUpperCase());
//         return DateTime(
//           fallbackDate.year,
//           fallbackDate.month,
//           fallbackDate.day,
//           parsed.hour,
//           parsed.minute,
//         );
//       } catch (_) {}
//     }

//     return null;
//   }

//   bool _hasTimezoneOffset(String value) {
//     final trimmed = value.trim();

//     if (trimmed.endsWith('Z')) return true;

//     return RegExp(r'([+-]\d{2}:?\d{2})$').hasMatch(trimmed);
//   }

//   String _formatFullDate(DateTime? value) {
//     if (value == null) return 'Select date';
//     return DateFormat('EEE, dd MMM').format(value);
//   }

//   String _formatTimeOnly(DateTime? value) {
//     if (value == null) return 'Select time';
//     return DateFormat('hh:mm a').format(value);
//   }

//   String _formatDateTimeForBloc(DateTime? value) {
//     if (value == null) return '';
//     return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(value);
//   }

//   int _totalMinutes() {
//     final start = _startDateTime;
//     final end = _endDateTime;

//     if (start == null || end == null) return 0;

//     final minutes = end.difference(start).inMinutes;
//     return minutes > 0 ? minutes : 0;
//   }

//   String _formatMinutes(int minutes) {
//     if (minutes <= 0) return '0m';

//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;

//     if (hours > 0 && mins > 0) return '${hours}h ${mins}m';
//     if (hours > 0) return '${hours}h';
//     return '${mins}m';
//   }

//   String _durationLabel() {
//     final minutes = _totalMinutes();

//     if (_startDateTime == null || _endDateTime == null) return 'Select both';
//     if (minutes <= 0) return 'Invalid';

//     return _formatMinutes(minutes);
//   }

//   int _breakMinutes() {
//     return int.tryParse(_breakController.text.trim()) ?? 0;
//   }

//   int _paidMinutes() {
//     final paid = _totalMinutes() - _breakMinutes();
//     return paid > 0 ? paid : 0;
//   }

//   String _paidDurationLabel() {
//     if (_totalMinutes() <= 0) return '0m';
//     return _formatMinutes(_paidMinutes());
//   }

//   void _syncRecommendedBreak() {
//     final total = _totalMinutes();

//     if (total <= 0) {
//       _recommendedBreakMinutes = null;
//       return;
//     }

//     if (total >= 360) {
//       _recommendedBreakMinutes = 30;
//     } else if (total >= 240) {
//       _recommendedBreakMinutes = 15;
//     } else {
//       _recommendedBreakMinutes = 0;
//     }
//   }

//   bool _validate() {
//     final start = _startDateTime;
//     final end = _endDateTime;
//     final breakMinutes = _breakMinutes();

//     if (start == null) {
//       setState(() => _timeError = 'Please select clock-in date and time.');
//       _ensureActionsVisible();
//       return false;
//     }

//     if (end == null) {
//       setState(() => _timeError = 'Please select clock-out date and time.');
//       _ensureActionsVisible();
//       return false;
//     }

//     if (!end.isAfter(start)) {
//       setState(() => _timeError = 'Clock-out must be after clock-in.');
//       _ensureActionsVisible();
//       return false;
//     }

//     if (breakMinutes < 0) {
//       setState(() => _breakError = 'Break cannot be negative.');
//       _ensureVisible(_breakFieldKey);
//       return false;
//     }

//     if (breakMinutes >= _totalMinutes()) {
//       setState(() => _breakError = 'Break must be less than worked time.');
//       _ensureVisible(_breakFieldKey);
//       return false;
//     }

//     setState(() {
//       _timeError = null;
//       _breakError = null;
//     });

//     return true;
//   }

//   DateTime _ensureDate(DateTime? value) {
//     final base = value ?? _baseDate();
//     return DateTime(base.year, base.month, base.day);
//   }

//   Future<void> _pickStartTime() async {
//     FocusScope.of(context).unfocus();

//     final current = _startDateTime ?? _baseDate();

//     final pickedTime = await AppDateTimePicker.pickTime(
//       context: context,
//       date: _ensureDate(current),
//       initialTime: current,
//       title: 'Select clock-in time',
//       minutesInterval: 5,
//     );

//     if (pickedTime == null || !mounted) return;

//     setState(() {
//       _startDateTime = pickedTime;
//       _timeError = null;
//       _syncRecommendedBreak();
//     });
//   }

//   Future<void> _pickEndDate() async {
//     FocusScope.of(context).unfocus();

//     final current = _endDateTime ?? _startDateTime ?? _baseDate();

//     final pickedDate = await AppDateTimePicker.pickDate(
//       context: context,
//       initialDate: current,
//       title: 'Select clock-out date',
//       disablePastDates: false,
//     );

//     if (pickedDate == null || !mounted) return;

//     setState(() {
//       final old = _endDateTime ?? current;
//       _endDateTime = DateTime(
//         pickedDate.year,
//         pickedDate.month,
//         pickedDate.day,
//         old.hour,
//         old.minute,
//       );
//       _timeError = null;
//       _syncRecommendedBreak();
//     });
//   }

//   Future<void> _pickEndTime() async {
//     FocusScope.of(context).unfocus();

//     final current = _endDateTime ?? _startDateTime ?? _baseDate();

//     final pickedTime = await AppDateTimePicker.pickTime(
//       context: context,
//       date: _ensureDate(current),
//       initialTime: current,
//       title: 'Select clock-out time',
//       minutesInterval: 5,
//     );

//     if (pickedTime == null || !mounted) return;

//     setState(() {
//       _endDateTime = pickedTime;
//       _timeError = null;
//       _syncRecommendedBreak();
//     });
//   }

//   void _applyBreakMinutes(int value) {
//     setState(() {
//       _breakController.text = value.toString();
//       _breakController.selection = TextSelection.collapsed(
//         offset: _breakController.text.length,
//       );
//       _breakError = null;
//     });

//     _ensureVisible(_breakFieldKey);
//   }

//   void _applyRecommendedBreak() {
//     final value = _recommendedBreakMinutes;
//     if (value == null) return;

//     _applyBreakMinutes(value);
//   }

//   void _save() {
//     FocusScope.of(context).unfocus();

//     if (!_validate()) return;

//     Navigator.of(context).pop(
//       AdjustActualTimesheetResult(
//         startTime: _formatDateTimeForBloc(_startDateTime),
//         endTime: _formatDateTimeForBloc(_endDateTime),
//         breakMinutes: _breakController.text.trim().isEmpty
//             ? '0'
//             : _breakController.text.trim(),
//         comment: _commentController.text.trim(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = context.appColors;
//     final isDark = theme.brightness == Brightness.dark;
//     final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

//     final recommendedBreak = _recommendedBreakMinutes;
//     final hasInvalidTime = _timeError != null;
//     final hasBreakError = _breakError != null;

//     return AnimatedPadding(
//       duration: const Duration(milliseconds: 220),
//       curve: Curves.easeOutCubic,
//       padding: EdgeInsets.only(bottom: keyboardInset),
//       child: Container(
//         margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, keyboardInset > 0 ? 4.h : 8.h),
//         constraints: BoxConstraints(
//           maxHeight: keyboardInset > 0 ? 0.84.sh : 0.95.sh,
//         ),
//         decoration: BoxDecoration(
//           color: appColors.cardBackground,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
//           border: Border.all(
//             color: appColors.divider.withValues(alpha: isDark ? .42 : .58),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: isDark ? .24 : .10),
//               blurRadius: 24.r,
//               offset: const Offset(0, -6),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           top: false,
//           child: SingleChildScrollView(
//             controller: _scrollController,
//             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             padding: EdgeInsets.fromLTRB(
//               12.w,
//               8.h,
//               12.w,
//               keyboardInset > 0 ? 18.h : 10.h,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 42.w,
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                     color: appColors.divider.withValues(alpha: .80),
//                     borderRadius: BorderRadius.circular(999.r),
//                   ),
//                 ),
//                 SizedBox(height: 9.h),
//                 _SheetHeader(onClose: () => Navigator.pop(context)),
//                 SizedBox(height: 10.h),
//                 _CompactSummaryCard(
//                   totalDuration: _durationLabel(),
//                   paidDuration: _paidDurationLabel(),
//                   breakMinutes: _breakMinutes(),
//                   hasError: hasInvalidTime,
//                 ),
//                 SizedBox(height: 10.h),
//                 _EditableHintBanner(),
//                 SizedBox(height: 10.h),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _EditableTimeCard(
//                         label: 'Clock-in',
//                         subtitle: 'Date fixed • time editable',
//                         dateValue: _formatFullDate(_startDateTime),
//                         timeValue: _formatTimeOnly(_startDateTime),
//                         icon: Icons.login_rounded,
//                         color: appColors.success,
//                         isError: hasInvalidTime,
//                         onDateTap: null,
//                         onTimeTap: _pickStartTime,
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: _EditableTimeCard(
//                         label: 'Clock-out',
//                         subtitle: 'End date & time editable',
//                         dateValue: _formatFullDate(_endDateTime),
//                         timeValue: _formatTimeOnly(_endDateTime),
//                         icon: Icons.logout_rounded,
//                         color: appColors.accent,
//                         isError: hasInvalidTime,
//                         onDateTap: _pickEndDate,
//                         onTimeTap: _pickEndTime,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (_timeError != null) ...[
//                   SizedBox(height: 7.h),
//                   _SheetErrorText(text: _timeError!),
//                 ],
//                 SizedBox(height: 10.h),
//                 _BreakCompactSection(
//                   key: _breakFieldKey,
//                   controller: _breakController,
//                   focusNode: _breakFocusNode,
//                   errorText: _breakError,
//                   hasError: hasBreakError,
//                   recommendedBreak: recommendedBreak,
//                   onTap: () => _ensureVisible(_breakFieldKey),
//                   onChanged: (_) {
//                     setState(() => _breakError = null);
//                     _ensureVisible(_breakFieldKey);
//                   },
//                   onSubmitted: (_) => _ensureActionsVisible(),
//                   onBreakSelected: _applyBreakMinutes,
//                   onRecommendedTap: _applyRecommendedBreak,
//                 ),
//                 SizedBox(height: 10.h),
//                 Container(
//                   key: _commentFieldKey,
//                   child: TextField(
//                     controller: _commentController,
//                     focusNode: _commentFocusNode,
//                     maxLines: 2,
//                     minLines: 2,
//                     textInputAction: TextInputAction.newline,
//                     keyboardType: TextInputType.multiline,
//                     onTap: () => _ensureVisible(_commentFieldKey),
//                     onChanged: (_) => _ensureVisible(_commentFieldKey),
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: appColors.primaryText,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 13.sp,
//                       height: 1.25,
//                     ),
//                     decoration: InputDecoration(
//                       labelText: 'Comment / notes',
//                       hintText: 'Add manager note',
//                       prefixIcon: Icon(
//                         Icons.edit_note_rounded,
//                         color: appColors.accent,
//                         size: 20.sp,
//                       ),
//                       alignLabelWithHint: true,
//                       filled: true,
//                       fillColor: appColors.pageBackground.withValues(
//                         alpha: isDark ? .42 : .75,
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 10.h,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.r),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.r),
//                         borderSide: BorderSide(
//                           color: appColors.divider.withValues(alpha: .42),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.r),
//                         borderSide: BorderSide(color: appColors.accent),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 Row(
//                   key: _actionsKey,
//                   children: [
//                     Expanded(
//                       child: SizedBox(
//                         height: 43.h,
//                         child: OutlinedButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 9.w),
//                     Expanded(
//                       child: SizedBox(
//                         height: 43.h,
//                         child: ElevatedButton.icon(
//                           onPressed: _save,
//                           icon: Icon(Icons.check_rounded, size: 17.sp),
//                           label: Text(
//                             'Save changes',
//                             style: TextStyle(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: keyboardInset > 0 ? 10.h : 0),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SheetHeader extends StatelessWidget {
//   final VoidCallback onClose;

//   const _SheetHeader({required this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = context.appColors;
//     final isDark = theme.brightness == Brightness.dark;

//     return Row(
//       children: [
//         Container(
//           width: 38.w,
//           height: 38.w,
//           decoration: BoxDecoration(
//             color: appColors.accent.withValues(alpha: .12),
//             borderRadius: BorderRadius.circular(14.r),
//           ),
//           child: Icon(
//             Icons.edit_calendar_rounded,
//             color: appColors.accent,
//             size: 21.sp,
//           ),
//         ),
//         SizedBox(width: 10.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Adjust actual times',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   color: appColors.primaryText,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16.sp,
//                 ),
//               ),
//               SizedBox(height: 1.h),
//               Text(
//                 'Clock-in date is fixed. Other fields can be edited.',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.bodySmall?.copyWith(
//                   color: appColors.secondaryText,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 11.sp,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         InkWell(
//           borderRadius: BorderRadius.circular(13.r),
//           onTap: onClose,
//           child: Container(
//             width: 34.w,
//             height: 34.w,
//             decoration: BoxDecoration(
//               color: appColors.pageBackground.withValues(
//                 alpha: isDark ? .45 : .80,
//               ),
//               borderRadius: BorderRadius.circular(13.r),
//               border: Border.all(
//                 color: appColors.divider.withValues(alpha: .35),
//               ),
//             ),
//             child: Icon(
//               Icons.close_rounded,
//               color: appColors.secondaryText,
//               size: 20.sp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _EditableHintBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = context.appColors;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: appColors.accent.withValues(alpha: .08),
//         borderRadius: BorderRadius.circular(15.r),
//         border: Border.all(color: appColors.accent.withValues(alpha: .18)),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.info_outline_rounded,
//             color: appColors.accent,
//             size: 17.sp,
//           ),
//           SizedBox(width: 7.w),
//           Expanded(
//             child: Text(
//               'Clock-in date is fixed. You can edit clock-in time and clock-out date/time.',
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: appColors.secondaryText,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 8.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CompactSummaryCard extends StatelessWidget {
//   final String totalDuration;
//   final String paidDuration;
//   final int breakMinutes;
//   final bool hasError;

//   const _CompactSummaryCard({
//     required this.totalDuration,
//     required this.paidDuration,
//     required this.breakMinutes,
//     required this.hasError,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final theme = Theme.of(context);

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color: hasError
//             ? appColors.error.withValues(alpha: .08)
//             : appColors.accent.withValues(alpha: .075),
//         borderRadius: BorderRadius.circular(17.r),
//         border: Border.all(
//           color: hasError
//               ? appColors.error.withValues(alpha: .20)
//               : appColors.accent.withValues(alpha: .16),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             hasError ? Icons.error_outline_rounded : Icons.timelapse_rounded,
//             color: hasError ? appColors.error : appColors.accent,
//             size: 18.sp,
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Text(
//               'Worked $totalDuration',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: hasError ? appColors.error : appColors.primaryText,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 12.sp,
//               ),
//             ),
//           ),
//           Text(
//             'Paid $paidDuration',
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: hasError ? appColors.error : appColors.primaryText,
//               fontWeight: FontWeight.w700,
//               fontSize: 12.sp,
//             ),
//           ),
//           SizedBox(width: 8.w),
//           Text(
//             'B ${breakMinutes}m',
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: appColors.secondaryText,
//               fontWeight: FontWeight.w600,
//               fontSize: 11.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EditableTimeCard extends StatelessWidget {
//   final String label;
//   final String subtitle;
//   final String dateValue;
//   final String timeValue;
//   final IconData icon;
//   final Color color;
//   final bool isError;
//   final VoidCallback? onDateTap;
//   final VoidCallback onTimeTap;

//   const _EditableTimeCard({
//     required this.label,
//     required this.subtitle,
//     required this.dateValue,
//     required this.timeValue,
//     required this.icon,
//     required this.color,
//     required this.isError,
//     required this.onDateTap,
//     required this.onTimeTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final theme = Theme.of(context);
//     final borderColor = isError ? appColors.error : color;

//     return Container(
//       padding: EdgeInsets.all(10.w),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: .08),
//         borderRadius: BorderRadius.circular(18.r),
//         border: Border.all(color: borderColor.withValues(alpha: .35)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 28.w,
//                 height: 28.w,
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: .13),
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: isError ? appColors.error : color,
//                   size: 15.sp,
//                 ),
//               ),
//               SizedBox(width: 6.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.labelMedium?.copyWith(
//                         color: isError
//                             ? appColors.error
//                             : appColors.primaryText,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                     SizedBox(height: 1.h),
//                     Text(
//                       subtitle,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.labelSmall?.copyWith(
//                         color: appColors.secondaryText,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 8.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 9.h),
//           _EditableValueButton(
//             label: 'Date',
//             value: dateValue,
//             icon: Icons.calendar_month_rounded,
//             color: color,
//             onTap: onDateTap,
//           ),
//           SizedBox(height: 7.h),
//           _EditableValueButton(
//             label: 'Time',
//             value: timeValue,
//             icon: Icons.access_time_rounded,
//             color: color,
//             onTap: onTimeTap,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EditableValueButton extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;
//   final VoidCallback? onTap;

//   const _EditableValueButton({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   bool get _isEditable => onTap != null;

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final theme = Theme.of(context);

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(13.r),
//         onTap: onTap,
//         child: Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//           decoration: BoxDecoration(
//             color: _isEditable
//                 ? appColors.cardBackground.withValues(alpha: .88)
//                 : appColors.pageBackground.withValues(alpha: .55),
//             borderRadius: BorderRadius.circular(13.r),
//             border: Border.all(
//               color: _isEditable
//                   ? color.withValues(alpha: .22)
//                   : appColors.divider.withValues(alpha: .38),
//             ),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 _isEditable ? icon : Icons.lock_outline_rounded,
//                 color: _isEditable ? color : appColors.secondaryText,
//                 size: 14.sp,
//               ),
//               SizedBox(width: 5.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _isEditable ? label : '$label fixed',
//                       style: theme.textTheme.labelSmall?.copyWith(
//                         color: appColors.secondaryText,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 9.sp,
//                       ),
//                     ),
//                     SizedBox(height: 1.h),
//                     Text(
//                       value,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.labelMedium?.copyWith(
//                         color: appColors.primaryText,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 10.5.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_isEditable)
//                 Container(
//                   width: 22.w,
//                   height: 22.w,
//                   decoration: BoxDecoration(
//                     color: color.withValues(alpha: .10),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Icon(Icons.edit_rounded, color: color, size: 12.sp),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _BreakCompactSection extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String? errorText;
//   final bool hasError;
//   final int? recommendedBreak;
//   final VoidCallback onTap;
//   final ValueChanged<String> onChanged;
//   final ValueChanged<String> onSubmitted;
//   final ValueChanged<int> onBreakSelected;
//   final VoidCallback onRecommendedTap;

//   const _BreakCompactSection({
//     super.key,
//     required this.controller,
//     required this.focusNode,
//     required this.errorText,
//     required this.hasError,
//     required this.recommendedBreak,
//     required this.onTap,
//     required this.onChanged,
//     required this.onSubmitted,
//     required this.onBreakSelected,
//     required this.onRecommendedTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(10.w),
//       decoration: BoxDecoration(
//         color: appColors.pageBackground.withValues(alpha: isDark ? .40 : .75),
//         borderRadius: BorderRadius.circular(18.r),
//         border: Border.all(color: appColors.divider.withValues(alpha: .38)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Break taken',
//             style: theme.textTheme.titleSmall?.copyWith(
//               color: appColors.primaryText,
//               fontWeight: FontWeight.w700,
//               fontSize: 13.sp,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           TextField(
//             controller: controller,
//             focusNode: focusNode,
//             keyboardType: TextInputType.number,
//             textInputAction: TextInputAction.done,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             onTap: onTap,
//             onChanged: onChanged,
//             onSubmitted: onSubmitted,
//             style: theme.textTheme.titleMedium?.copyWith(
//               color: appColors.primaryText,
//               fontWeight: FontWeight.w600,
//               fontSize: 14.sp,
//             ),
//             decoration: InputDecoration(
//               labelText: 'Break minutes',
//               hintText: '30',
//               errorText: errorText,
//               prefixIcon: Icon(
//                 Icons.free_breakfast_rounded,
//                 color: hasError ? appColors.error : appColors.accent,
//                 size: 18.sp,
//               ),
//               suffixText: 'min',
//               filled: true,
//               fillColor: appColors.cardBackground,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 12.w,
//                 vertical: 10.h,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15.r),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15.r),
//                 borderSide: BorderSide(
//                   color: appColors.divider.withValues(alpha: .42),
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15.r),
//                 borderSide: BorderSide(color: appColors.accent),
//               ),
//             ),
//           ),
//           if (recommendedBreak != null) ...[
//             SizedBox(height: 8.h),
//             Wrap(
//               spacing: 6.w,
//               runSpacing: 6.h,
//               children: [
//                 _BreakSuggestionChip(
//                   text: '0m',
//                   selected: controller.text.trim() == '0',
//                   onTap: () => onBreakSelected(0),
//                 ),
//                 _BreakSuggestionChip(
//                   text: '${recommendedBreak}m rec',
//                   selected:
//                       controller.text.trim() == recommendedBreak.toString(),
//                   onTap: onRecommendedTap,
//                 ),
//                 _BreakSuggestionChip(
//                   text: '30m',
//                   selected: controller.text.trim() == '30',
//                   onTap: () => onBreakSelected(30),
//                 ),
//                 _BreakSuggestionChip(
//                   text: '60m',
//                   selected: controller.text.trim() == '60',
//                   onTap: () => onBreakSelected(60),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _BreakSuggestionChip extends StatelessWidget {
//   final String text;
//   final bool selected;
//   final VoidCallback onTap;

//   const _BreakSuggestionChip({
//     required this.text,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final theme = Theme.of(context);

//     return InkWell(
//       borderRadius: BorderRadius.circular(999.r),
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//         decoration: BoxDecoration(
//           color: selected
//               ? appColors.accent
//               : appColors.accent.withValues(alpha: .09),
//           borderRadius: BorderRadius.circular(999.r),
//           border: Border.all(
//             color: appColors.accent.withValues(alpha: selected ? 1 : .22),
//           ),
//         ),
//         child: Text(
//           text,
//           style: theme.textTheme.labelMedium?.copyWith(
//             color: selected ? theme.colorScheme.onPrimary : appColors.accent,
//             fontWeight: FontWeight.w700,
//             fontSize: 11.sp,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SheetErrorText extends StatelessWidget {
//   final String text;

//   const _SheetErrorText({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final theme = Theme.of(context);

//     return Row(
//       children: [
//         Icon(Icons.error_outline_rounded, color: appColors.error, size: 14.sp),
//         SizedBox(width: 6.w),
//         Expanded(
//           child: Text(
//             text,
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: appColors.error,
//               fontWeight: FontWeight.w500,
//               fontSize: 10.5.sp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
