import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver {
  static const _platform = MethodChannel('com.focus_quiz/foreground_app');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissionAndNavigate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAndNavigate();
    }
  }

  Future<void> _checkPermissionAndNavigate() async {
    try {
      final bool hasPermission = await _platform.invokeMethod('hasUsageStatsPermission');
      if (hasPermission && mounted) {
        Navigator.pushReplacementNamed(context, '/personalization');
      }
    } on PlatformException catch (e) {
      print("Failed to check permission: '${e.message}'.");
      // Handle error appropriately
    }
  }

  Future<void> _requestPermission() async {
    try {
      await _platform.invokeMethod('openUsageAccessSettings');
    } on PlatformException catch (e) {
      print("Failed to open settings: '${e.message}'.");
      // Handle error appropriately, e.g., show a dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.track_changes, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Turn Distraction into Learning',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'FocusQuiz interrupts distracting apps with a quick quiz to help you reclaim your focus.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 48),
              const Text(
                'To detect when a blocked app is opened, FocusQuiz needs "Usage Access" permission.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'We respect your privacy. This is only used to identify the app in the foreground.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _requestPermission,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
