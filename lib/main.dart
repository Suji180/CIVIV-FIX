import 'package:flutter/material.dart';
import 'intro_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'CIVIC FIX',
      home: IntroPage(),
    );
  }
}
