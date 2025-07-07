import 'package:flutter/material.dart';

// TODO: Replace with a proper Question model and data source
class Question {
  final String questionText;
  final List<String> answers;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  // TODO: Fetch questions from selected topics
  final List<Question> _questions = [
    Question(
      questionText: 'What is the powerhouse of the cell?',
      answers: ['Mitochondria', 'Nucleus', 'Ribosome', 'Chloroplast'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'In what year did the first man walk on the moon?',
      answers: ['1965', '1969', '1972', '1980'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What does "CPU" stand for?',
      answers: [
        'Central Processing Unit',
        'Computer Personal Unit',
        'Central Power Unit',
        'Core Programming Unit'
      ],
      correctAnswerIndex: 0,
    ),
  ];

  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  late AnimationController _feedbackController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _feedbackController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleAnswer(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
    });

    final isCorrect =
        _selectedAnswerIndex == _questions[_currentQuestionIndex].correctAnswerIndex;

    if (!isCorrect) {
      _feedbackController.forward(from: 0);
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return; // Check if the widget is still mounted after delay

      if (isCorrect) {
        if (_currentQuestionIndex < _questions.length - 1) {
          _goToNextQuestion();
        } else {
          _showSuccessDialog();
        }
      }
    });
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _isAnswered = false;
      _selectedAnswerIndex = null;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Great Job!'),
          content: const Text("You've unlocked the app."),
          actions: <Widget>[
            TextButton(
              child: const Text('Proceed'),
              onPressed: () {
                // Pop the dialog first.
                Navigator.of(dialogContext).pop();
                // Then, *after* the async gap, check if the original widget is still mounted
                // before using its context.
                if (mounted) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Not Quite...'),
          content: const Text('You need to answer all questions correctly.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry Quiz'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (mounted) {
                  setState(() {
                    _currentQuestionIndex = 0;
                    _isAnswered = false;
                    _selectedAnswerIndex = null;
                  });
                }
              },
            ),
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (mounted) {
                  Navigator.of(context).pop(false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Color _getButtonColor(int index) {
    if (!_isAnswered) return Colors.grey.shade200;

    bool isCorrect =
        index == _questions[_currentQuestionIndex].correctAnswerIndex;
    bool isSelected = index == _selectedAnswerIndex;

    if (isSelected && isCorrect) return Colors.green.shade300;
    if (isSelected && !isCorrect) return Colors.red.shade300;
    if (isCorrect) return Colors.green.shade300;

    return Colors.grey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz (${_currentQuestionIndex + 1}/${_questions.length})'),
        automaticallyImplyLeading: false, // Prevents user from going back
      ),
      body: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value * 24 - 12, 0),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                currentQuestion.questionText,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ...List.generate(currentQuestion.answers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _handleAnswer(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(index),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: Text(currentQuestion.answers[index]),
                  ),
                );
              }),
              const Spacer(),
              if (_isAnswered && _selectedAnswerIndex != _questions[_currentQuestionIndex].correctAnswerIndex)
                ElevatedButton(
                  onPressed: _showFailureDialog,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text('Try Again or Dismiss'),
                )
            ],
          ),
        ),
      ),
    );
  }
}
