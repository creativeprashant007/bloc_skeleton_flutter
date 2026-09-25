import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_messaging_background.dart'
    show firebaseMessagingBackgroundHandler;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationService()
    : _firebaseMessaging = FirebaseMessaging.instance,
      _localNotifications = FlutterLocalNotificationsPlugin();

  Future<String?> getDeviceToken() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Push notification permission denied');
        return null;
      }

      if (Platform.isIOS) {
        String? apnsToken;

        for (int i = 0; i < 10; i++) {
          apnsToken = await _firebaseMessaging.getAPNSToken();

          if (apnsToken != null) {
            debugPrint('APNs Token: $apnsToken');
            break;
          }

          await Future.delayed(const Duration(seconds: 1));
        }

        if (apnsToken == null) {
          debugPrint('APNs token is still null after retries.');
        }
      }

      String? fcmToken;

      for (int i = 0; i < 5; i++) {
        fcmToken = await _firebaseMessaging.getToken();

        if (fcmToken != null && fcmToken.isNotEmpty) {
          debugPrint('FCM Token: $fcmToken');
          return fcmToken;
        }

        await Future.delayed(const Duration(seconds: 1));
      }

      debugPrint('FCM token is null or empty after retries.');
      return null;
    } catch (e, st) {
      debugPrint('Error getting FCM token: $e\n$st');
      return null;
    }
  }

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  Future<void> initialize(BuildContext context) async {
    const androidSettings = AndroidInitializationSettings('notification_icon');

    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;

        if (payload != null && payload.isNotEmpty && context.mounted) {
          _navigateToMerchant(context, payload);
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showLocalNotification(message);
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null && context.mounted) {
      handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (context.mounted) {
        handleMessage(context, message);
      }
    });
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: 'notification_icon',
      largeIcon: DrawableResourceAndroidBitmap('launcher_icon'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? 'You have a new message',
      notificationDetails: notificationDetails,
      payload: message.data['merchantID']?.toString() ?? '',
    );
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    final merchantID = message.data['merchantID'];

    if (merchantID != null && context.mounted) {
      _navigateToMerchant(context, merchantID.toString());
    }
  }

  void _navigateToMerchant(BuildContext context, String merchantID) {
    debugPrint('Here is the Merchant $merchantID');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      // Add your navigation here.
    });
  }
}
