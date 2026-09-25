// lib/core/initializers/firebase_initializer.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart' show DefaultFirebaseOptions;

class FirebaseInitializer {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Set up Crashlytics
      FlutterError.onError = (error) {
        crashlytics.recordFlutterError(error);
      };

      // Enable Crashlytics in production only
      await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

      // Record app start event
      await analytics.logAppOpen();
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
    }
  }

  static Future<void> recordError(dynamic error, StackTrace stack) async {
    if (!kDebugMode) {
      await crashlytics.recordError(error, stack);
    }
  }
}
