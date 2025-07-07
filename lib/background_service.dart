import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Key for storing the list of blocked apps in SharedPreferences
const String blockedAppsKey = 'selected_apps';

// The name of the MethodChannel must match the one used in the native code.
const MethodChannel _platform = MethodChannel('com.focus_quiz/foreground_app');

// This is the entry point for the background service
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) => service.setAsForegroundService());
    service.on('setAsBackground').listen((event) => service.setAsBackgroundService());
  }

  service.on('stop').listen((event) => service.stopSelf());

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final blockedApps = prefs.getStringList(blockedAppsKey) ?? [];
    if (blockedApps.isEmpty) return;

    try {
      // Invoke the native method to get the foreground app package name
      final String? currentApp = await _platform.invokeMethod('getForegroundApp');

      if (currentApp != null && blockedApps.contains(currentApp)) {
        print('ALERT! Blocked app detected: $currentApp');
        // Bring the app to the foreground and show the quiz.
        service.invoke('showQuiz', {'appPackage': currentApp});
      }
    } on PlatformException catch (e) {
      print("Failed to get foreground app: '${e.message}'.");
    }
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );
  service.startService();
}
