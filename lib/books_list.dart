import 'dart:io';
import 'package:avl_flutter/API/pdf_api.dart';
import 'package:avl_flutter/PdfViewPage.dart';
import 'package:avl_flutter/httpRequests.dart'; // Adjust the import based on your actual file structure
import 'package:avl_flutter/widget/button_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:avl_flutter/API/Django.dart';


class BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Gallery'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 4, // Total number of books
          itemBuilder: (context, index) {
            return Container(
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
                  'Book ${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
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
