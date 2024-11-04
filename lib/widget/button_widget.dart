import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    Key? key, // Added key parameter for better widget tree management
  }) : super(key: key); // Call to the super constructor

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: onClicked,
    );
  }
}
