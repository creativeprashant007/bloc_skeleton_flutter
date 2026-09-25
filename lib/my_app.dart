import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/app_provider.dart';
import 'package:stock_control_master/core/extension/build_extention.dart';

import 'package:stock_control_master/core/services/firebase/notification_service.dart'
    show NotificationService;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      FocusManager.instance.primaryFocus?.unfocus();

      await _notificationService.initialize(context);
      await _notificationService.getDeviceToken();

      _notificationService.onTokenRefresh.listen((token) {
        debugPrint('Refreshed FCM Token: $token');
      });
    });
  }

  Size _getDesignSize(BuildContext context) {
    final width = context.width;

    if (width >= 600) {
      return const Size(768, 1024);
    }

    return const Size(375, 812);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: _getDesignSize(context),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => const AppProviders(),
    );
  }
}
