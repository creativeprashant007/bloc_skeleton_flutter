import 'package:flutter/material.dart';

abstract class DialogAndSheetService {
  Future<T?> showAppBottomSheet<T>(Widget child);
  Future<T?> showAppDialog<T>({required Widget child, bool? isDismissible});
}
