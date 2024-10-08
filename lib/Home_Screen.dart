import 'package:avl_flutter/httpRequests.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpRequests httpRequest = HttpRequests(); // Create an instance of HttpRequests
  String? apiData; // Variable to store the fetched API data
  String? errorMessage; // Variable to store any error message

  // @override
  // void initState() {
  //   super.initState();
  //   fetchApiData(); // Fetch the API data when the screen initializes
  // }

  // // Function to fetch API data
  // void fetchApiData() async {
  //   var data = await httpRequest.fetchData(); // Fetch raw string data
  //   if (data != null) {
  //     setState(() {
  //       apiData = data; // Store the plain text response and update the UI
  //     });
  //   } else {
  //     setState(() {
  //       errorMessage = 'Failed to fetch data';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      // body: apiData == null
      //     ? errorMessage != null
      //         ? Center(
      //             child: Text(
      //               'Error: $errorMessage',
      //               style: TextStyle(fontSize: 16, color: Colors.red),
      //             ),
      //           )
      //         : Center(child: CircularProgressIndicator()) // Show a loading spinner while fetching data
      //     : Center(
      //         child: Text(
      //           'API Response: $apiData', // Display the plain text response
      //           style: TextStyle(fontSize: 16),
      //         ),
      //       ),
    );
  }
}
