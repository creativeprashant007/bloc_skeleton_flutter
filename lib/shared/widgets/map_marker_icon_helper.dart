import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerIconHelper {
  MapMarkerIconHelper._();

  static Future<BitmapDescriptor> buildMarker({
    required IconData icon,
    required Color backgroundColor,
    Color iconColor = Colors.white,
    double size = 30,
    double iconSize = 8,
    Color borderColor = Colors.white,
    double borderWidth = 1,
    bool withShadow = true,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = backgroundColor;

    final center = Offset(size / 2, size / 2);
    final radius = size / 2.8;

    if (withShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 10);

      canvas.drawCircle(Offset(center.dx, center.dy + 6), radius, shadowPaint);
    }

    final borderPaint = Paint()..color = borderColor;
    canvas.drawCircle(center, radius + borderWidth, borderPaint);

    canvas.drawCircle(center, radius, paint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: iconColor,
      ),
    );
    textPainter.layout();

    final iconOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, iconOffset);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to generate marker icon');
    }

    final bytes = byteData.buffer.asUint8List();
    return BitmapDescriptor.bytes(bytes);
  }
}
