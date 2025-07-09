import 'package:flutter/material.dart';
import 'package:getsmarter/pages/first_page.dart';
import 'package:getsmarter/pages/personalization.dart';


void main() {
  runApp(const MyApp());
}
//test
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Playfair Display'),
      home: Firstpage()
    );
  }
}
