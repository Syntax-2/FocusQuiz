import 'package:flutter/material.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  _PersonalizationScreenState createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  final List<String> _goals = [
    'Be more productive',
    'Break the scrolling habit',
    'Learn something new every day',
    'Improve my focus',
  ];

  final List<String> _scrollingTimes = [
    '< 30 minutes',
    '1–2 hours',
    '2–4 hours',
    'More than 4 hours',
  ];

  final List<String> _topics = [
    'Science',
    'History',
    'Tech',
    'Vocabulary',
    'Math',
    'Geography',
  ];

  final Set<String> _selectedGoals = {};
  String? _selectedTime;
  final Set<String> _selectedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalize Your Experience'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Great, we’re all set! Let’s personalize your experience.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('What’s your main goal?'),
              _buildChoiceChips(_goals, _selectedGoals, (selected) {
                setState(() {
                  if (_selectedGoals.contains(selected)) {
                    _selectedGoals.remove(selected);
                  } else {
                    _selectedGoals.add(selected);
                  }
                });
              }),
              const SizedBox(height: 24),
              _buildSectionTitle(
                  'Roughly how much time do you lose to scrolling each day?'),
              _buildChoiceChips(_scrollingTimes, {_selectedTime ?? ''}, (selected) {
                setState(() {
                  _selectedTime = selected;
                });
              }, isSingleSelection: true),
              const SizedBox(height: 24),
              _buildSectionTitle('Pick a few learning topics you’re curious about.'),
              _buildChoiceChips(_topics, _selectedTopics, (selected) {
                setState(() {
                  if (_selectedTopics.contains(selected)) {
                    _selectedTopics.remove(selected);
                  } else {
                    _selectedTopics.add(selected);
                  }
                });
              }),
              const SizedBox(height: 48),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Save personalization settings
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Finish Setup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildChoiceChips(
    List<String> items,
    Set<String> selectedItems,
    Function(String) onSelected, {
    bool isSingleSelection = false,
  }) {
    return Wrap(
      spacing: 8.0,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            onSelected(item);
          },
          selectedColor: Colors.blue.shade100,
          labelStyle: TextStyle(
            color: isSelected ? Colors.blue.shade900 : Colors.black87,
          ),
        );
      }).toList(),
    );
  }
}
