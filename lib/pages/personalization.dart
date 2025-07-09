import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PersoPage extends StatelessWidget {
  PersoPage({super.key});

  List names = ["ligita", "Neda", "vijune", "Diana", "Asta", "Rasa", "Egle", "Giedre"];
  int tapCount = 0;

  void pressedtheButton() {
    tapCount++;
    print("Container tapped $tapCount times");
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              pressedtheButton();
              // You can add more functionality here, like navigating to another page or showing a dialog.
            },
            child: Container(
              height: 200, 
              width: 200,
              color: Colors.lime,
              child: Center(child: Text("TAP MEE!!")),  
            ),
          ),
          
          )
        
        
      ),
    );
  }
}