import 'package:avl_flutter/Home_Screen.dart';
import 'package:avl_flutter/LoginPage.dart';
import 'package:avl_flutter/SignupPage.dart';
import 'package:avl_flutter/ProfilePage.dart';
import 'package:avl_flutter/books_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  await initLocalStorage();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/booksList', // Set the initial route
        routes: {
          '/': (context) => LoginPage(), // Change this to your initial screen
          '/profile': (context) => ProfilePage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/HomeScreen': (context) => HomeScreen(),
          '/booksList': (context) => BooksList(),
        });
  }
}
