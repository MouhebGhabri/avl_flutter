  // import 'package:avl_flutter/LoginPage.dart';
  // import 'package:flutter/material.dart';
  //
  // void main() {
  //   runApp(const MyApp());
  // }
  //
  // class MyApp extends StatelessWidget {
  //   const MyApp({super.key});
  //
  //   // This widget is the root of your application.
  //   @override
  //   Widget build(BuildContext context) {
  //     return MaterialApp(
  //       home: LoginPage(),
  //     );
  //   }
  // }
  import 'package:flutter/material.dart';
  import 'SplashScreen.dart'; // Import the splash screen

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // Set SplashScreen as home
      );
    }
  }
