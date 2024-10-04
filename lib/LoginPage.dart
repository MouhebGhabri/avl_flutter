import 'package:flutter/material.dart';
import 'package:avl_flutter/SignupPage.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black87, Colors.deepPurpleAccent],
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _aiHeader(context),
              const SizedBox(height: 50),
              _aiInputField(context),
              _forgotPassword(context),
              const SizedBox(height: 20),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aiHeader(BuildContext context) {
    return const Column(
      children: [

        Text(
          "AVL",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "Your AI-powered Summarization assistant",
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _aiInputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Username",
            filled: true,
            fillColor: Colors.deepPurple.withOpacity(0.1),
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.person, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Password",
            filled: true,
            fillColor: Colors.deepPurple.withOpacity(0.1),
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.password, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account?",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.deepPurpleAccent),
          ),
        ),
      ],
    );
  }
}
