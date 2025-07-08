import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home:Scaffold(
          backgroundColor: const Color.fromARGB(255, 200, 255, 255),
          appBar: AppBar(
            title: Text(
            'Start Learning',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Playfair Display',
            ),
            
          ),
          centerTitle: true,
          leading: Icon(Icons.menu),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout)),
          ],
          backgroundColor: const Color.fromARGB(255, 151, 255, 255),
        ),
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            padding: const EdgeInsets.only(top:100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Text("Begin",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Playfair Display'
              ),
              
            ),
            
          )
          
        ),
        
      )
      
    );
    
  }
}