import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isServiceActive = true;
  final service = FlutterBackgroundService();

  @override
  void initState() {
    super.initState();
    // Check the current status of the service to set the toggle correctly.
    service.isRunning().then((value) {
      if (mounted) {
        setState(() {
          _isServiceActive = value;
        });
      }
    });
  }

  void _toggleService(bool value) {
    setState(() {
      _isServiceActive = value;
    });
    if (value) {
      // The service is configured to auto-start, but we can ensure it's running.
      service.startService();
    } else {
      // We invoke the 'stop' custom event we defined in our service.
      service.invoke('stop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusQuiz Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to a settings page for sounds, haptics, etc.
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMasterToggle(),
            const SizedBox(height: 24),
            _buildDashboardCard(
              icon: Icons.block,
              title: 'Manage Blocked Apps',
              subtitle: 'Select which apps trigger a quiz',
              onTap: () => Navigator.pushNamed(context, '/app-selection'),
            ),
            const SizedBox(height: 16),
            _buildDashboardCard(
              icon: Icons.school,
              title: 'Choose Learning Topics',
              subtitle: 'Customize your quiz content',
              onTap: () => Navigator.pushNamed(context, '/topic-selection'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterToggle() {
    return Card(
      elevation: 2,
      child: SwitchListTile(
        title: const Text(
          'FocusQuiz is Active',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_isServiceActive
            ? 'Quizzes will appear for blocked apps.'
            : 'App blocking is currently paused.'),
        value: _isServiceActive,
        onChanged: _toggleService,
        secondary: Icon(
          _isServiceActive ? Icons.shield_sharp : Icons.shield_outlined,
          color: _isServiceActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
