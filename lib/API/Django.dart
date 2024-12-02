import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DjangoAPI {
  /// Upload a file to the Django backend
  static Future<String?> uploadFile(File file) async {
    try {
      final uri = Uri.parse("https://3786-196-235-94-84.ngrok-free.app/api/upload/");
      final request = http.MultipartRequest('POST', uri);

      // Add the file to the request
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
