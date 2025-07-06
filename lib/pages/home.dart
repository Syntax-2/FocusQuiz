import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
      'Start Learning',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      ),
      centerTitle: true,
    ),
    );
  }
}