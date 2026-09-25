import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show Factory;
import 'package:flutter/gestures.dart'
    show EagerGestureRecognizer, OneSequenceGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:stock_control_master/shared/widgets/map_marker_icon_helper.dart'
    show MapMarkerIconHelper;

class TimesheetMapBottomSheet extends StatefulWidget {
  const TimesheetMapBottomSheet({
    super.key,
    required this.title,
    required this.statusText,
    required this.addressText,
    required this.workLocation,
    required this.clockInLocation,
    required this.clockOutLocation,
    required this.isDark,
    this.checkInDistanceMeters,
    this.checkOutDistanceMeters,
  });

  final String title;
  final String statusText;
  final String addressText;

  final LatLng workLocation;
  final LatLng clockInLocation;
  final LatLng clockOutLocation;

  final bool isDark;

  final int? checkInDistanceMeters;
  final int? checkOutDistanceMeters;

  @override
  State<TimesheetMapBottomSheet> createState() =>
      _TimesheetMapBottomSheetState();
}

class _TimesheetMapBottomSheetState extends State<TimesheetMapBottomSheet> {
  final Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? _mapController;

  BitmapDescriptor? _workMarkerIcon;
  BitmapDescriptor? _clockInMarkerIcon;
  BitmapDescriptor? _clockOutMarkerIcon;

  bool _isDisposed = false;

  static const Color _workColor = Color(0xFF3B82F6);
  static const Color _checkInColor = Color(0xFF22C55E);
  static const Color _checkOutColor = Color(0xFFEF4444);
  static const Color _warningColor = Color(0xFFF59E0B);

  static const double _samePointOffset = 0.000055;

  static const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#242f3e"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#cbd5e1"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#1e293b"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#334155"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#0f172a"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0f2744"}]}
]
''';

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  Future<void> _loadMarkerIcons() async {
    final work = await MapMarkerIconHelper.buildMarker(
      icon: Icons.storefront_rounded,
      backgroundColor: _workColor,
      iconSize: 15.sp,
    );

    final clockIn = await MapMarkerIconHelper.buildMarker(
      icon: Icons.login_rounded,
      backgroundColor: _checkInColor,
      iconSize: 15.sp,
    );

    final clockOut = await MapMarkerIconHelper.buildMarker(
      icon: Icons.logout_rounded,
      backgroundColor: _checkOutColor,
      iconSize: 15.sp,
    );

    if (!mounted || _isDisposed) return;

    setState(() {
      _workMarkerIcon = work;
      _clockInMarkerIcon = clockIn;
      _clockOutMarkerIcon = clockOut;
    });
  }

  bool _isValidLatLng(LatLng point) {
    final isZero = point.latitude == 0 && point.longitude == 0;

    return !isZero &&
        point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }

  bool _isSamePoint(LatLng a, LatLng b) {
    return (a.latitude - b.latitude).abs() < 0.00001 &&
        (a.longitude - b.longitude).abs() < 0.00001;
  }

  LatLng _displayPoint(LatLng point, int index) {
    if (!_isValidLatLng(point)) return point;

    final validPoints = [
      widget.workLocation,
      widget.clockInLocation,
      widget.clockOutLocation,
    ].where(_isValidLatLng).toList();

    final overlapCount = validPoints
        .where((e) => _isSamePoint(e, point))
        .length;

    if (overlapCount <= 1) return point;

    final angle = index * 2.1;

    return LatLng(
      point.latitude + math.sin(angle) * _samePointOffset,
      point.longitude + math.cos(angle) * _samePointOffset,
    );
  }

  List<_MapPoint> _buildPoints() {
    final result = <_MapPoint>[];

    if (_isValidLatLng(widget.workLocation)) {
      result.add(
        _MapPoint(
          id: 'work',
          label: 'Workplace',
          point: _displayPoint(widget.workLocation, 0),
          originalPoint: widget.workLocation,
          color: _workColor,
          icon: _workMarkerIcon,
          fallbackHue: BitmapDescriptor.hueAzure,
          markerTitle: 'Workplace',
          markerSnippet: widget.addressText,
        ),
      );
    }

    if (_isValidLatLng(widget.clockInLocation)) {
      result.add(
        _MapPoint(
          id: 'clock_in',
          label: 'Clock in',
          point: _displayPoint(widget.clockInLocation, 1),
          originalPoint: widget.clockInLocation,
          color: _checkInColor,
          icon: _clockInMarkerIcon,
          fallbackHue: BitmapDescriptor.hueGreen,
          markerTitle: 'Clock in',
          markerSnippet:
              '${_formatDistance(widget.checkInDistanceMeters)} from workplace',
        ),
      );
    }

    if (_isValidLatLng(widget.clockOutLocation)) {
      result.add(
        _MapPoint(
          id: 'clock_out',
          label: 'Clock out',
          point: _displayPoint(widget.clockOutLocation, 2),
          originalPoint: widget.clockOutLocation,
          color: _checkOutColor,
          icon: _clockOutMarkerIcon,
          fallbackHue: BitmapDescriptor.hueRed,
          markerTitle: 'Clock out',
          markerSnippet:
              '${_formatDistance(widget.checkOutDistanceMeters)} from workplace',
        ),
      );
    }

    return result;
  }

  _MapPoint? _firstPoint(List<_MapPoint> points, String id) {
    for (final point in points) {
      if (point.id == id) return point;
    }
    return null;
  }

  Set<Marker> _markers(List<_MapPoint> points) {
    return points.map((item) {
      return Marker(
        markerId: MarkerId(item.id),
        position: item.point,
        icon:
            item.icon ??
            BitmapDescriptor.defaultMarkerWithHue(item.fallbackHue),
        infoWindow: InfoWindow(
          title: item.markerTitle,
          snippet: item.markerSnippet,
        ),
        anchor: const Offset(0.5, 1),
      );
    }).toSet();
  }

  Set<Polyline> _polylines(List<_MapPoint> points) {
    final work = _firstPoint(points, 'work');
    final checkIn = _firstPoint(points, 'clock_in');
    final checkOut = _firstPoint(points, 'clock_out');

    return {
      if (work != null && checkIn != null)
        Polyline(
          polylineId: const PolylineId('work_to_clock_in'),
          points: [work.point, checkIn.point],
          width: 2,
          color: _checkInColor,
        ),
      if (work != null && checkOut != null)
        Polyline(
          polylineId: const PolylineId('work_to_clock_out'),
          points: [work.point, checkOut.point],
          width: 2,
          color: _checkOutColor,
        ),
    };
  }

  Set<Circle> _circles(List<_MapPoint> points) {
    final work = _firstPoint(points, 'work');
    final checkIn = _firstPoint(points, 'clock_in');
    final checkOut = _firstPoint(points, 'clock_out');

    return {
      if (work != null)
        Circle(
          circleId: const CircleId('work_focus'),
          center: work.originalPoint,
          radius: 40,
          fillColor: _workColor.withValues(alpha: 0.08),
          strokeColor: _workColor.withValues(alpha: 0.28),
          strokeWidth: 1,
        ),
      if (checkIn != null)
        Circle(
          circleId: const CircleId('clock_in_focus'),
          center: checkIn.originalPoint,
          radius: 18,
          fillColor: _checkInColor.withValues(alpha: 0.12),
          strokeColor: _checkInColor.withValues(alpha: 0.38),
          strokeWidth: 1,
        ),
      if (checkOut != null)
        Circle(
          circleId: const CircleId('clock_out_focus'),
          center: checkOut.originalPoint,
          radius: 18,
          fillColor: _checkOutColor.withValues(alpha: 0.12),
          strokeColor: _checkOutColor.withValues(alpha: 0.38),
          strokeWidth: 1,
        ),
    };
  }

  Future<void> _fitAllPoints(List<_MapPoint> mapPoints) async {
    if (_isDisposed || !mounted || !_controller.isCompleted) return;

    try {
      final controller = await _controller.future;

      if (_isDisposed || !mounted) return;

      final points = mapPoints.map((e) => e.point).toList();
      if (points.isEmpty) return;

      if (points.length == 1) {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: points.first, zoom: 17),
          ),
        );
        return;
      }

      final latitudes = points.map((e) => e.latitude).toList()..sort();
      final longitudes = points.map((e) => e.longitude).toList()..sort();

      final samePoint =
          (latitudes.first - latitudes.last).abs() < 0.00001 &&
          (longitudes.first - longitudes.last).abs() < 0.00001;

      if (samePoint) {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: points.first, zoom: 17),
          ),
        );
        return;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(latitudes.first, longitudes.first),
        northeast: LatLng(latitudes.last, longitudes.last),
      );

      if (_isDisposed || !mounted) return;

      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 72));
    } catch (_) {
      // GoogleMap may be disposed before camera animation completes.
    }
  }

  String _formatDistance(int? meters) {
    if (meters == null) return 'Unknown';
    if (meters < 1000) return '${meters}m';

    final km = meters / 1000;
    if (km < 10) return '${km.toStringAsFixed(1)}km';

    final miles = meters / 1609.344;
    return '${miles.toStringAsFixed(1)}mi';
  }

  bool _isFar(int? meters) {
    if (meters == null) return false;
    return meters > 100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sheetColor = widget.isDark
        ? const Color(0xFF17181D)
        : theme.colorScheme.surface;

    final titleColor = widget.isDark
        ? Colors.white
        : theme.colorScheme.onSurface;

    final mutedColor = titleColor.withValues(alpha: 0.62);
    final points = _buildPoints();
    final hasAnyLocation = points.isNotEmpty;

    final checkInFar = _isFar(widget.checkInDistanceMeters);
    final checkOutFar = _isFar(widget.checkOutDistanceMeters);

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
          child: Column(
            children: [
              Container(
                width: 52.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: titleColor.withValues(
                    alpha: widget.isDark ? 0.28 : 0.16,
                  ),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),

              SizedBox(height: 14.h),

              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: _workColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.location_searching_rounded,
                      color: _workColor,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: titleColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          hasAnyLocation
                              ? 'Workplace, Clock-in and check-out accuracy'
                              : 'No valid location data found',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: mutedColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: titleColor,
                      size: 26.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: _DistanceCard(
                      label: 'Clock in',
                      value: _formatDistance(widget.checkInDistanceMeters),
                      color: checkInFar ? _warningColor : _checkInColor,
                      icon: Icons.login_rounded,
                      isWarning: checkInFar,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _DistanceCard(
                      label: 'Clock out',
                      value: _formatDistance(widget.checkOutDistanceMeters),
                      color: checkOutFar ? _warningColor : _checkOutColor,
                      icon: Icons.logout_rounded,
                      isWarning: checkOutFar,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26.r),
                  child: hasAnyLocation
                      ? GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: points.first.point,
                            zoom: 16,
                          ),
                          markers: _markers(points),
                          circles: _circles(points),
                          polylines: _polylines(points),
                          zoomControlsEnabled: true,
                          compassEnabled: true,
                          mapToolbarEnabled: true,
                          zoomGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          myLocationButtonEnabled: false,
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                          onMapCreated: (controller) async {
                            if (_isDisposed || !mounted) return;

                            _mapController = controller;

                            if (!_controller.isCompleted) {
                              _controller.complete(controller);
                            }

                            if (widget.isDark) {
                              try {
                                await controller.setMapStyle(_darkMapStyle);
                              } catch (_) {}
                            }

                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );

                            if (_isDisposed || !mounted) return;

                            await _fitAllPoints(points);
                          },
                        )
                      : _NoLocationView(titleColor: titleColor),
                ),
              ),

              SizedBox(height: 12.h),

              _MapLegend(titleColor: titleColor),

              if (widget.addressText.trim().isNotEmpty) ...[
                SizedBox(height: 10.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 110.h),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: titleColor.withValues(
                          alpha: widget.isDark ? 0.06 : 0.04,
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: titleColor.withValues(
                            alpha: widget.isDark ? 0.10 : 0.08,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.addressText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: titleColor,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPoint {
  final String id;
  final String label;
  final LatLng point;
  final LatLng originalPoint;
  final Color color;
  final BitmapDescriptor? icon;
  final double fallbackHue;
  final String markerTitle;
  final String markerSnippet;

  const _MapPoint({
    required this.id,
    required this.label,
    required this.point,
    required this.originalPoint,
    required this.color,
    required this.icon,
    required this.fallbackHue,
    required this.markerTitle,
    required this.markerSnippet,
  });
}

class _DistanceCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isWarning;

  const _DistanceCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 18.sp),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  isWarning ? '$value away' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
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

class _MapLegend extends StatelessWidget {
  final Color titleColor;

  const _MapLegend({required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: [
        _LegendItem(
          color: _TimesheetMapBottomSheetState._workColor,
          text: 'Workplace',
          titleColor: titleColor,
        ),
        _LegendItem(
          color: _TimesheetMapBottomSheetState._checkInColor,
          text: 'Check in',
          titleColor: titleColor,
        ),
        _LegendItem(
          color: _TimesheetMapBottomSheetState._checkOutColor,
          text: 'Clock out',
          titleColor: titleColor,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final Color titleColor;

  const _LegendItem({
    required this.color,
    required this.text,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9.w,
          height: 9.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _NoLocationView extends StatelessWidget {
  final Color titleColor;

  const _NoLocationView({required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: titleColor.withValues(alpha: 0.04),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_off_rounded,
            color: titleColor.withValues(alpha: 0.45),
            size: 42.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            'Location unavailable',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'No valid latitude and longitude found.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: titleColor.withValues(alpha: 0.58),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
