import 'dart:io';
import 'package:avl_flutter/API/pdf_api.dart';
import 'package:avl_flutter/PdfViewPage.dart';
import 'package:avl_flutter/httpRequests.dart'; // Adjust the import based on your actual file structure
import 'package:avl_flutter/widget/button_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:avl_flutter/API/Django.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // For downloading files
import 'package:path_provider/path_provider.dart'; // For storing downloaded files
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For viewing PDFs

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class BooksList extends StatefulWidget {
  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  List<dynamic> books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final userId = '112233--123366-123654-1336544';  // Replace with the appropriate user ID
    final url = 'https://3786-196-235-94-84.ngrok-free.app/api/books/?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          books = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  Future<void> downloadAndOpenPDF(BuildContext context, String url, String name) async {
    try {
      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Download the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$name.pdf';
      await Dio().download(url, filePath);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Open the PDF
      openPDF(context, File(filePath));
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open PDF: $e')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Gallery'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: books.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return InkWell(
              onTap: () => downloadAndOpenPDF(context, book['url']!, book['name']!),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    book['name'] ?? 'Unknown Book',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the popup dialog
          showDialog(
            context: context,
            builder: (context) => FileDialog(),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}


// Custom Popup Dialog Widget


class FileDialog extends StatefulWidget {
  @override
  _FileDialogState createState() => _FileDialogState();
}

class _FileDialogState extends State<FileDialog> {
  final TextEditingController _fileNameController = TextEditingController();
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import File'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              // Pick a file using FilePicker
              final file = await _pickFile();
              if (file != null) {
                setState(() {
                  _selectedFile = file;
                  _fileNameController.text = file.path.split('/').last;
                });
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Choose File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fileNameController,
            decoration: const InputDecoration(
              labelText: 'File Name',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_selectedFile != null && _fileNameController.text.isNotEmpty) {
              // Upload the file to the Django backend
              final responseMessage = await DjangoAPI.uploadFile(_selectedFile!);
              if (responseMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(responseMessage)),
                );
              }
              Navigator.pop(context); // Close the dialog
            } else {
              // Show an error if the file or file name is missing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a file and enter a file name')),
              );
            }
          },
          child: const Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  // File picker logic
  Future<File?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}
void openPDF(BuildContext context, File file) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );
}