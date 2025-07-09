import 'package:flutter/material.dart';
import 'package:getsmarter/pages/second_page.dart';

class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  void loadNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecondPage(),
      ),
    );
    
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Get Smarter'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              loadNextPage(context);
              print("Container tapped!");
            },
            child: Container(
              height: 200,
              width: 200,
              color: Colors.lime,
              child: const Center(child: Text("Go to the next page!")),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Get Smarter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Personalization'),
                onTap: () {
                  Navigator.pushNamed(context, '/personalization');
                },
              ),
            ],
          ),
        ),
      
      ),
    );
  }
}