import 'package:flutter/material.dart';



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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Import File'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Implement file import logic here
              print("Import file button clicked");
            },
            icon: Icon(Icons.upload_file),
            label: Text('Choose File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _fileNameController,
            decoration: InputDecoration(
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
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle file name submission logic
            String fileName = _fileNameController.text;
            if (fileName.isNotEmpty) {
              print("File Name: $fileName");
              Navigator.pop(context);
            } else {
              // Show a simple error if the file name is empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a file name')),
              );
            }
          },
          child: Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
