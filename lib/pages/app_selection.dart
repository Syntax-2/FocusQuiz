import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  _AppSelectionScreenState createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  static const String _selectedAppsKey = 'selected_apps';

  bool _isLoading = true;
  List<Application> _apps = [];
  List<Application> _filteredApps = [];
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
  }

  void _filterApps() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredApps = _apps.where((app) {
        return app.appName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onAppSelected(Application app, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedAppIds.add(app.packageName);
      } else {
        _selectedAppIds.remove(app.packageName);
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
                : ListView.builder(
                    itemCount: _filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = _filteredApps[index];
                      final isSelected =
                          _selectedAppIds.contains(app.packageName);

                      if (app is ApplicationWithIcon) {
                        return CheckboxListTile(
                          secondary: Image.memory(app.icon, width: 40),
                          title: Text(app.appName),
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value != null) {
                              _onAppSelected(app, value);
                            }
                          },
                        );
                      }
                      return CheckboxListTile(
                        title: Text(app.appName),
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
