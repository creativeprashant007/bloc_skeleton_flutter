import 'dart:async';

import 'package:stock_control_master/features/home/presentation/widgets/app_box_shadow.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class ShiftActionConfirmSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String primaryLabel;

  /// Sends user comment back to caller.
  final ValueChanged<String> onConfirm;

  const ShiftActionConfirmSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onConfirm,
  });

  @override
  State<ShiftActionConfirmSheet> createState() =>
      _ShiftActionConfirmSheetState();
}

class _ShiftActionConfirmSheetState extends State<ShiftActionConfirmSheet> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  Position? _position;
  String? _locationError;
  bool _isFetchingLocation = true;

  bool get _isDangerAction {
    final value = widget.primaryLabel.toLowerCase();

    return value.contains('end') ||
        value.contains('clock out') ||
        value.contains('delete') ||
        value.contains('cancel');
  }

  bool get _needsLocation {
    final value = widget.primaryLabel.toLowerCase();

    return value.contains('start') ||
        value.contains('end') ||
        value.contains('clock out') ||
        value.contains('break') ||
        value.contains('resume');
  }

  IconData get _actionIcon {
    final value = widget.primaryLabel.toLowerCase();

    if (value.contains('break')) return Icons.free_breakfast_rounded;
    if (value.contains('resume')) return Icons.work_rounded;
    if (value.contains('start')) return Icons.play_arrow_rounded;

    if (value.contains('end') || value.contains('clock out')) {
      return Icons.logout_rounded;
    }

    return Icons.check_rounded;
  }

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();

    if (_needsLocation) {
      _fetchCurrentLocation();
    } else {
      _isFetchingLocation = false;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _isFetchingLocation = false;
          _locationError = 'Location service is turned off.';
        });
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _isFetchingLocation = false;
          _locationError = 'Location permission is required.';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _isFetchingLocation = false;
          _locationError =
              'Location permission is permanently denied. Enable it from settings.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _position = position;
        _isFetchingLocation = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isFetchingLocation = false;
        _locationError = 'Unable to fetch current location.';
      });
    }
  }

  String _coordinateText(Position position) {
    return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
  }

  void _handleConfirm() {
    FocusScope.of(context).unfocus();
    widget.onConfirm(_commentController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    final actionColor = _isDangerAction
        ? appColors.error
        : theme.colorScheme.primary;

    final canConfirm =
        !_isFetchingLocation &&
        (!_needsLocation || (_position != null && _locationError == null));

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardBottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: appColors.cardBackground.withValues(
              alpha: isDark ? 0.98 : 1,
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isIOS ? 32.r : 28.r),
            ),
            boxShadow: AppShadows.soft(context),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 16.h),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(bottom: keyboardBottom > 0 ? 18.h : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: isIOS ? 42.w : 46.w,
                      height: isIOS ? 4.h : 5.h,
                      decoration: BoxDecoration(
                        color: appColors.divider.withValues(
                          alpha: isIOS ? 0.55 : 0.8,
                        ),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    Container(
                      width: isIOS ? 54.w : 56.w,
                      height: isIOS ? 54.w : 56.w,
                      decoration: BoxDecoration(
                        color: actionColor.withValues(
                          alpha: isIOS ? 0.10 : 0.12,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: actionColor.withValues(
                            alpha: isIOS ? 0.12 : 0,
                          ),
                        ),
                      ),
                      child: Icon(
                        _actionIcon,
                        color: actionColor,
                        size: isIOS ? 25.sp : 27.sp,
                      ),
                    ),

                    SizedBox(height: 14.h),

                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: isIOS ? 20.sp : 19.sp,
                        fontWeight: FontWeight.w800,
                        color: appColors.primaryText,
                        letterSpacing: isIOS ? -0.2 : 0,
                      ),
                    ),

                    SizedBox(height: 7.h),

                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        color: appColors.secondaryText,
                        fontWeight: FontWeight.w500,
                        height: 1.42,
                      ),
                    ),

                    if (_needsLocation) ...[
                      SizedBox(height: 16.h),
                      _LocationPreview(
                        position: _position,
                        isLoading: _isFetchingLocation,
                        errorMessage: _locationError,
                        actionColor: actionColor,
                        coordinateText: _position == null
                            ? null
                            : _coordinateText(_position!),
                        onRetry: _fetchCurrentLocation,
                        onMapCreated: (controller) {
                          if (!_mapController.isCompleted) {
                            _mapController.complete(controller);
                          }
                        },
                      ),
                    ],

                    SizedBox(height: 16.h),

                    _ActionCommentField(
                      controller: _commentController,
                      focusNode: _commentFocusNode,
                      actionColor: actionColor,
                    ),

                    SizedBox(height: 20.h),

                    _SheetActionButtonRow(
                      actionIcon: _actionIcon,
                      actionColor: actionColor,
                      primaryLabel: widget.primaryLabel,
                      isLoading: _isFetchingLocation,
                      canConfirm: canConfirm,
                      onConfirm: _handleConfirm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCommentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color actionColor;

  const _ActionCommentField({
    required this.controller,
    required this.focusNode,
    required this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = appColors.divider.withValues(alpha: isDark ? .48 : .72);

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
          maxLines: 4,
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
            hintText: 'Add a note for this action...',
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
              padding: EdgeInsets.only(left: 12.w, right: 8.w, bottom: 28.h),
              child: Icon(
                Icons.notes_rounded,
                size: 18.sp,
                color: actionColor.withValues(alpha: .82),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 42.w,
              minHeight: 44.h,
            ),
            contentPadding: EdgeInsets.fromLTRB(0, 13.h, 14.w, 13.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: borderColor, width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: actionColor.withValues(alpha: .72),
                width: 1.25.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SheetActionButtonRow extends StatelessWidget {
  final IconData actionIcon;
  final Color actionColor;
  final String primaryLabel;
  final bool isLoading;
  final bool canConfirm;
  final VoidCallback onConfirm;

  const _SheetActionButtonRow({
    required this.actionIcon,
    required this.actionColor,
    required this.primaryLabel,
    required this.isLoading,
    required this.canConfirm,
    required this.onConfirm,
  });

  static const double _buttonHeight = 44;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.r),
    );

    final textStyle = theme.textTheme.labelLarge?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      height: 1.0,
    );

    final fixedButtonSize = Size.fromHeight(_buttonHeight.h);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: _buttonHeight.h,
            child: OutlinedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                fixedSize: fixedButtonSize,
                minimumSize: fixedButtonSize,
                maximumSize: fixedButtonSize,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                shape: buttonShape,
                side: BorderSide(
                  color: appColors.divider.withValues(alpha: .85),
                  width: 1.15.w,
                ),
                foregroundColor: appColors.primaryText,
                textStyle: textStyle,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.standard,
              ),
              child: Text(
                'Cancel',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle?.copyWith(color: appColors.primaryText),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: SizedBox(
            height: _buttonHeight.h,
            child: ElevatedButton.icon(
              onPressed: canConfirm ? onConfirm : null,
              style: ElevatedButton.styleFrom(
                fixedSize: fixedButtonSize,
                minimumSize: fixedButtonSize,
                maximumSize: fixedButtonSize,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                shape: buttonShape,
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: appColors.divider.withValues(
                  alpha: .55,
                ),
                disabledForegroundColor: appColors.secondaryText.withValues(
                  alpha: .75,
                ),
                elevation: canConfirm ? 2.5 : 0,
                shadowColor: actionColor.withValues(alpha: .24),
                textStyle: textStyle,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.standard,
              ),
              icon: isLoading
                  ? SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: const CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(actionIcon, size: 18.sp),
              label: Text(
                isLoading ? 'Locating...' : primaryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle?.copyWith(
                  color: canConfirm
                      ? Colors.white
                      : appColors.secondaryText.withValues(alpha: .75),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationPreview extends StatelessWidget {
  final Position? position;
  final bool isLoading;
  final String? errorMessage;
  final String? coordinateText;
  final Color actionColor;
  final VoidCallback onRetry;
  final ValueChanged<GoogleMapController> onMapCreated;

  const _LocationPreview({
    required this.position,
    required this.isLoading,
    required this.errorMessage,
    required this.coordinateText,
    required this.actionColor,
    required this.onRetry,
    required this.onMapCreated,
  });

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isIOS = _isIOS(context);

    if (isLoading) {
      return _LocationContainer(
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Fetching your current location...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: appColors.secondaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null || position == null) {
      return _LocationContainer(
        child: Row(
          children: [
            Icon(
              Icons.location_off_rounded,
              color: appColors.error,
              size: 21.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                errorMessage ?? 'Location unavailable.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: appColors.primaryText,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }

    final target = LatLng(position!.latitude, position!.longitude);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isIOS ? 22.r : 18.r),
          child: SizedBox(
            height: isIOS ? 155.h : 150.h,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: target, zoom: 17),
              onMapCreated: onMapCreated,
              markers: {
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: target,
                  infoWindow: const InfoWindow(title: 'Current location'),
                ),
              },
              circles: {
                Circle(
                  circleId: const CircleId('accuracy'),
                  center: target,
                  radius: position!.accuracy,
                  fillColor: actionColor.withValues(alpha: 0.12),
                  strokeColor: actionColor.withValues(alpha: 0.45),
                  strokeWidth: 1,
                ),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
        ),

        SizedBox(height: 10.h),

        _LocationContainer(
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.11),
                  shape: isIOS ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isIOS ? null : BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.my_location_rounded,
                  color: actionColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Current location captured',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '±${position!.accuracy.toStringAsFixed(0)}m',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 12.sp,
                  color: actionColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocationContainer extends StatelessWidget {
  final Widget child;

  const _LocationContainer({required this.child});

  bool _isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = _isIOS(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isIOS ? 13.w : 12.w),
      decoration: BoxDecoration(
        color: appColors.primaryText.withValues(alpha: isDark ? 0.055 : 0.035),
        borderRadius: BorderRadius.circular(isIOS ? 20.r : 17.r),
        border: Border.all(
          color: appColors.divider.withValues(
            alpha: isIOS ? (isDark ? 0.34 : 0.45) : (isDark ? 0.45 : 0.60),
          ),
        ),
      ),
      child: child,
    );
  }
}
