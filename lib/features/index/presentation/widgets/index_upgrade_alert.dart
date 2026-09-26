import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

/// Wraps [child] with an [UpgradeAlert] once the underlying [Upgrader] has
/// finished initializing. Before that, [child] is shown as-is.
///
/// This isolates the upgrader's async init/lifecycle so parent widgets don't
/// need to be stateful just to host it.
class IndexUpgradeAlert extends StatefulWidget {
  const IndexUpgradeAlert({super.key, required this.child});

  final Widget child;

  @override
  State<IndexUpgradeAlert> createState() => _IndexUpgradeAlertState();
}

class _IndexUpgradeAlertState extends State<IndexUpgradeAlert> {
  late final Upgrader _upgrader;
  bool _ready = false;

  @override
  void initState() {
    super.initState();

    _upgrader = Upgrader(
      debugLogging: false,
      durationUntilAlertAgain: const Duration(minutes: 15),
      debugDisplayAlways: false,
    );

    _init();
  }

  Future<void> _init() async {
    await _upgrader.initialize();

    if (!mounted) return;
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return widget.child;

    return UpgradeAlert(
      upgrader: _upgrader,
      dialogStyle: UpgradeDialogStyle.cupertino,
      showIgnore: false,
      showLater: true,
      child: widget.child,
    );
  }
}
