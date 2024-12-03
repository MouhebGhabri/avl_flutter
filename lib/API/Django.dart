import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

import 'links.dart';

class DjangoAPI {


  /// Upload a file to the Django backend
  static Future<String?> uploadFile(File file) async {
    try {
      final uri = Uri.parse(GlobalAPIUriDjango+"api/upload/");
      final request = http.MultipartRequest('POST', uri);

      // Add the file to the request
      request.fields['user_id'] = localStorage.getItem('sid')! ; // Replace 'your_user_id_here' with the actual user ID

      request.files.add(
        http.MultipartFile(
          'file',
          file.openRead(),
          await file.length(),
          filename: file.path.split('/').last,
        ),
      );
      print(request);
      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);

        return "Upload Successful: ${responseData['message']}";
      } else {
        final responseBody = await response.stream.bytesToString();
        print(responseBody);

        return "Failed: $responseBody";
      }
    } catch (e) {
      print(e);
      return "Error occurred: $e";
    }
  }
}
