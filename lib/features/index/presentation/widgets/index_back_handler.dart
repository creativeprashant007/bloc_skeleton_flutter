import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
