import 'dart:io';
import 'package:avl_flutter/API/pdf_api.dart';
import 'package:avl_flutter/PdfViewPage.dart';
import 'package:avl_flutter/httpRequests.dart'; // Adjust the import based on your actual file structure
import 'package:avl_flutter/main.dart';
import 'package:avl_flutter/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:avl_flutter/LoginPage.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
        ),
        automaticallyImplyLeading: false, // Disable the back button
        backgroundColor: Colors.deepPurpleAccent,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 159, 83, 221),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Modify Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                sharedPref.clear();
                   Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: "Pick PDF",
                onClicked: () async {
                  final file = await PDFApi.pickFile();
                  if (file == null) return;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}
