import 'package:avl_flutter/Home_Screen.dart';
import 'package:avl_flutter/LoginPage.dart';
import 'package:avl_flutter/SignupPage.dart';
import 'package:avl_flutter/ProfilePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/HomeScreen', // Set the initial route
        routes: {
          '/': (context) => LoginPage(), // Change this to your initial screen
          '/profile': (context) => ProfilePage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/HomeScreen': (context) => HomeScreen(),
        });
  }
}
