import 'package:flutter/material.dart';
import 'package:avl_flutter/LoginPage.dart';
import 'package:avl_flutter/httpRequests.dart'; // Import the HttpRequests class

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final HttpRequests httpRequest = HttpRequests(); // Create an instance of HttpRequests
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController(); // Controller for First Name
  final TextEditingController lastnameController = TextEditingController(); // Controller for Last Name
  String? apiResponse; // To store the API response
  String? errorMessage; // To store any error message

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
                // _googleSignInButton(context),
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
                if (apiResponse != null) 
                  Text('Response: $apiResponse', style: TextStyle(color: Colors.green)),
                if (errorMessage != null) 
                  Text('Error: $errorMessage', style: TextStyle(color: Colors.red)),
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
          controller: firstnameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "First Name",
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
          controller: lastnameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Last Name",
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
          controller: usernameController,
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
          controller: emailController,
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
          controller: passwordController,
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
      onPressed: () {
        createUser(); // Call the createUser function on button press
      },
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

  void createUser() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String firstname = firstnameController.text; // Get first name from the controller
    String lastname = lastnameController.text; // Get last name from the controller

    var response = await httpRequest.createUser(username, password, email, firstname, lastname);
    if (response != null) {
      setState(() {
        apiResponse = response; // Store the API response and update the UI
        errorMessage = null; // Clear any previous error message
      });
    } else {
      setState(() {
        errorMessage = 'Failed to create user'; // Update error message if the request fails
        apiResponse = null; // Clear previous response
      });
    }
  }

  // Widget _googleSignInButton(BuildContext context) {
  //   return Container(
  //     child: TextButton(
  //       onPressed: () {},
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             height: 30.0,
  //             width: 30.0,
  //             decoration: const BoxDecoration(
  //               image: DecorationImage(
  //                 image: AssetImage('assets/images/google.png'),
  //                 fit: BoxFit.cover,
  //               ),
  //               shape: BoxShape.circle,
  //             ),
  //           ),
  //           const SizedBox(width: 18),
  //           const Text(
  //             "Sign In with Google",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
