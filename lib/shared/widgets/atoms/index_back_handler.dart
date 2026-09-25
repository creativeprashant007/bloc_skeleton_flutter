import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;

/// Prevents the default pop and instead exits the app via
/// [SystemNavigator.pop] when the system back gesture/button is triggered.
class IndexBackHandler extends StatelessWidget {
  const IndexBackHandler({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: child,
    );
  }
}
