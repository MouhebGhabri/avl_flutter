import 'package:avl_flutter/Home_Screen.dart';
import 'package:avl_flutter/LoginPage.dart';
import 'package:avl_flutter/SignupPage.dart';
import 'package:flutter/material.dart';

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignupPage(), // Set SplashScreen as home
      );
    }
  }
