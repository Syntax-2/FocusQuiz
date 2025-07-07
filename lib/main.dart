import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:focus_quiz/pages/dashboard.dart';
import 'package:focus_quiz/pages/app_selection.dart';
import 'package:focus_quiz/pages/topic_selection.dart';
import 'package:focus_quiz/pages/quiz.dart';
import 'package:focus_quiz/pages/onboarding.dart';
import 'package:focus_quiz/pages/personalization.dart';
import 'package:focus_quiz/background_service.dart';

// Global navigator key to allow navigation from outside the widget tree
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize and start the background service
  await initializeService();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen for events from the background service
    final service = FlutterBackgroundService();
    service.on('showQuiz').listen((event) {
      // When the service detects a blocked app, it sends a 'showQuiz' event.
      // We use the global navigator key to push the quiz screen.
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamed('/quiz');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Assign the global key
      title: 'FocusQuiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/personalization': (context) => const PersonalizationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/app-selection': (context) => const AppSelectionScreen(),
        '/topic-selection': (context) => const TopicSelectionScreen(),
        '/quiz': (context) => const QuizScreen(),
      },
    );
  }
}
