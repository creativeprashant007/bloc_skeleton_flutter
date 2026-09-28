// lib/firebase_messaging_background.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:stock_control_master/core/services/firebase/notification_service.dart'
    show NotificationService;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Create a new instance since DI isn't available in background
  final notificationService = NotificationService();

  // Only handle merchant notifications
  final merchantID = message.data['merchantID'];
  if (merchantID != null && merchantID.isNotEmpty) {
    // Show the local notification (no BuildContext needed here)
    await notificationService.showLocalNotification(message);
  } else {
    print('Background message ignored: No merchantID found.');
  }
}
