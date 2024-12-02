import 'dart:convert';

import 'package:avl_flutter/API/links.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpRequests {
  Future<String?> fetchData() async {
    final String apiUrl = GlobalAPIUri + "auth/test";

    try {
      final response = await http.get(Uri.parse(apiUrl)); // Make a GET request
      if (response.statusCode == 200) {
        // If the server returns a 200 (OK) response
        var data = jsonDecode(response.body);
        return response.body; // Return the response body (plain text)
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null; // Return null in case of an error
      }
    } catch (e) {
      print(
          'Error occurred: $e'); // Handle any exceptions (e.g., network issues)
      return null;
    }
  }

  Future<String?> createUser(String username, String password, String email,
      String firstname, String lastname) async {
    final String registeraapiUrl = GlobalAPIUri + "auth/register";
   // print(registeraapiUrl);
    try {
      // Create the user data in a Map
      final Map<String, dynamic> userData = {
        'username': username,
        'password': password,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(registeraapiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData), // Convert Map to JSON string
      );

      // Print response details for debugging
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        // Assuming 201 is the success status code for creation
        return response
            .body; // Return the response body (the created user info or a success message)
      } else {
        print('Failed to create user. Status code: ${response.statusCode}');
        return null; // Return null in case of an error
      }
    } catch (e) {
      print(
          'Error occurred: $e'); // Handle any exceptions (e.g., network issues)
      return null;
    }
  }
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final String apiUrl = GlobalAPIUri+ "auth/login"; // Replace with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Specify content type as JSON
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 (OK) response
        var data = jsonDecode(response.body) as Map<String, dynamic>;

        // Save token and username in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']); // Adjust according to your response structure
        await prefs.setString('username', username);

        return data; // Return the parsed JSON data
      } else {
        print('Failed to log in. Status code: ${response.statusCode}');
        return null; // Return null in case of an error
      }
    } catch (e) {
      print('Error occurred: $e'); // Handle any exceptions (e.g., network issues)
      return null;
    }
  }
}



//   Future<Map<String, dynamic>?> login(String username, String password) async {
//     final String apiUrl =
//         GlobalAPIUri + "auth/login"; // Replace with your actual API URL

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json', // Specify content type as JSON
//         },
//         body: jsonEncode({
//           'username': username,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // If the server returns a 200 (OK) response
//         var data = jsonDecode(response.body) as Map<String, dynamic>;
//         return data; // Return the parsed JSON data
//       } else {
//         print('Failed to log in. Status code: ${response.statusCode}');
//         return null; // Return null in case of an error
//       }
//     } catch (e) {
//       print(
//           'Error occurred: $e'); // Handle any exceptions (e.g., network issues)
//       return null;
//     }
//   }
// }
