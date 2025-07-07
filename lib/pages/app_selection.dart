import 'package:flutter/material.dart';
// Only import device_apps on Android
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:shared_preferences/shared_preferences.dart';

// Define stubs for non-Android platforms
// ignore: uri_does_not_exist
import 'package:device_apps/device_apps.dart'
    if (dart.library.io) 'package:device_apps/device_apps.dart'
    if (dart.library.html) 'unsupported_device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  _AppSelectionScreenState createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  static const String _selectedAppsKey = 'selected_apps';

  bool _isLoading = true;
  List<dynamic> _apps = [];
  List<dynamic> _filteredApps = [];
  final Set<String> _selectedAppIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAppsAndPreferences();
    _searchController.addListener(_filterApps);
  }

  Future<void> _loadAppsAndPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAppIds = prefs.getStringList(_selectedAppsKey) ?? [];

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        // ignore: undefined_identifier
        final apps = await DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true,
          includeSystemApps: false,
          includeAppIcons: true,
        );
        setState(() {
          _selectedAppIds.addAll(savedAppIds);
          _apps = apps;
          _filteredApps = apps;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterApps() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredApps = _apps.where((app) {
        final appName = app.appName != null
            ? app.appName.toString().toLowerCase()
            : '';
        return appName.contains(query);
      }).toList();
    });
  }

  void _onAppSelected(dynamic app, bool isSelected) {
    setState(() {
      final packageName = app.packageName != null
          ? app.packageName as String
          : '';
      if (isSelected) {
        _selectedAppIds.add(packageName);
      } else {
        _selectedAppIds.remove(packageName);
      }
    });
  }

  Future<void> _saveSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedAppsKey, _selectedAppIds.toList());
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selection saved!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Distraction Apps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSelection,
            tooltip: 'Save Selection',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Apps',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : (defaultTargetPlatform != TargetPlatform.android)
                    ? const Center(child: Text('App selection is only supported on Android.'))
                    : ListView.builder(
                        itemCount: _filteredApps.length,
                        itemBuilder: (context, index) {
                          final app = _filteredApps[index];
                          final isSelected =
                              _selectedAppIds.contains(app.packageName ?? '');

                          if (app != null && app.icon != null) {
                            return CheckboxListTile(
                              secondary: app.icon is List<int>
                                  ? Image.memory(app.icon, width: 40)
                                  : null,
                              title: Text(app.appName ?? ''),
                              value: isSelected,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  _onAppSelected(app, value);
                                }
                              },
                            );
                          }
                          return CheckboxListTile(
                            title: Text(app.appName ?? ''),
                            value: isSelected,
                            onChanged: (bool? value) {
                              if (value != null) {
                                _onAppSelected(app, value);
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
