import 'package:flutter/material.dart';
import 'package:avl_flutter/LoginPage.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: const [
                    SizedBox(height: 60.0),
                    Icon(
                      Icons.security,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                  ],
                ),
                _inputFields(context),
                const SizedBox(height: 20),
                _signupButton(context),
                const Center(child: Text("Or", style: TextStyle(color: Colors.white))),
                _googleSignInButton(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?", style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputFields(BuildContext context) {
    return Column(
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
        const SizedBox(height: 20),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Email",
            filled: true,
            fillColor: Colors.deepPurple.withOpacity(0.1),
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.email, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Password",
            filled: true,
            fillColor: Colors.deepPurple.withOpacity(0.1),
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _signupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      child: const Text(
        "Sign up",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _googleSignInButton(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30.0,
              width: 30.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/google.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 18),
            const Text(
              "Sign In with Google",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
