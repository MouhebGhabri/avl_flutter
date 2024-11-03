import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Uploader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DocumentUploaderPage(), 
    );
  }
}

class DocumentUploaderPage extends StatefulWidget { 
  @override
  _DocumentUploaderPageState createState() => _DocumentUploaderPageState();
}

class _DocumentUploaderPageState extends State<DocumentUploaderPage> {
  String? _filePath;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePath = result.files.single.name; 
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected or invalid file type.')),
      );
    }
  }

  void _summarize() {
    if (_filePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Summarizing the file...')),
      );
    }
  }

  void _search() {
    if (_filePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Searching in the file...')),
      );
    }
  }

  void _recommend() {
    if (_filePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recommending based on the file...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step into our world of books!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _filePath != null ? 'File selected: $_filePath' : 'No file selected',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.upload_file),
              label: Text('Upload PDF/DOC'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _filePath != null ? _summarize : null, // Disable when no file is selected
                  icon: Icon(Icons.article),
                  label: Text('Summarize'),
                ),
                ElevatedButton.icon(
                  onPressed: _filePath != null ? _search : null, // Disable when no file is selected
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                ),
                ElevatedButton.icon(
                  onPressed: _filePath != null ? _recommend : null, // Disable when no file is selected
                  icon: Icon(Icons.recommend),
                  label: Text('Recommend'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
