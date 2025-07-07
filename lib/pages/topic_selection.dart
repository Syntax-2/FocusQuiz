import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopicSelectionScreen extends StatefulWidget {
  const TopicSelectionScreen({super.key});

  @override
  _TopicSelectionScreenState createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
  static const String _selectedTopicsKey = 'selected_topics';

  final List<String> _allTopics = [
    'World History',
    'General Science',
    'Mathematics',
    'Literature',
    'Technology',
    'Geography',
    'Art History',
    'Music Theory',
    'Computer Science',
    'Pop Culture',
  ];

  final Set<String> _selectedTopics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedTopics();
  }

  Future<void> _loadSelectedTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTopics = prefs.getStringList(_selectedTopicsKey);

    setState(() {
      if (savedTopics == null || savedTopics.isEmpty) {
        // First time launch, select some defaults
        _selectedTopics.addAll(['General Science', 'Technology']);
      } else {
        _selectedTopics.addAll(savedTopics);
      }
      _isLoading = false;
    });
  }

  void _onTopicSelected(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        if (_selectedTopics.length > 1) { // Prevent deselecting the last topic
          _selectedTopics.remove(topic);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You must have at least one topic selected!')),
          );
        }
      } else {
        _selectedTopics.add(topic);
      }
    });
  }

  Future<void> _saveSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedTopicsKey, _selectedTopics.toList());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Topics saved!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Topics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSelection,
            tooltip: 'Save Selection',
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemCount: _allTopics.length,
              itemBuilder: (context, index) {
                final topic = _allTopics[index];
                final isSelected = _selectedTopics.contains(topic);
                return GestureDetector(
                  onTap: () => _onTopicSelected(topic),
                  child: Card(
                    elevation: 2,
                    color: isSelected ? Colors.blue.shade100 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? Colors.blue.shade400 : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            topic,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.blue.shade900 : Colors.black,
                            ),
                          ),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Icon(Icons.check_circle,
                                  color: Colors.blue, size: 20),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
