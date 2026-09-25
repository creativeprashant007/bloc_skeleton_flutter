import 'package:flutter/material.dart';

extension PlatformX on BuildContext {
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
}