import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PersoPage extends StatelessWidget {
  const PersoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          
          children: [
            
            Container(
              height: 400,
              color: Colors.green,
            ),

            Container(
              height: 400,
              color: Colors.green[400],
            ),

            Container(
              height: 400,
              color: Colors.green[200],
            )

          ],
        )
      ),
    );
  }
}