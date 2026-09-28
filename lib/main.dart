import 'package:stock_control_master/core/services/session_manager.dart'
    show SessionManager;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/cupertino.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;
import 'package:stock_control_master/core/configs/service/storage_service.dart'
    show StorageService;

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/my_app.dart' show MyApp;
import 'package:flutter/material.dart' show runApp, Colors;

import 'package:stock_control_master/firebase_options.dart'
    show DefaultFirebaseOptions;

late StorageService storageService;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Initialize services here
  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  await Future.delayed(const Duration(milliseconds: 500));
  // Configure system UI
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  FlutterNativeSplash.remove();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Dependency Injection
  await setupLocator();

  // Local storage
  storageService = StorageService();
  await storageService.init();

  // Session Manager
  await SessionManager.instance.init();
}
