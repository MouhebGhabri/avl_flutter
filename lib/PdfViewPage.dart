import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: pages >= 2
            ? [
          Center(child: Text(text)),
          IconButton(
            icon: Icon(Icons.chevron_left, size: 32),
            onPressed: () {
              final page = indexPage == 0 ? pages - 1 : indexPage - 1;
              controller.setPage(page);
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 32),
            onPressed: () {
              final page = indexPage == pages - 1 ? 0 : indexPage + 1;
              controller.setPage(page);
            },
          ),
        ]
            : null,
      ),
      body: PDFView(
        filePath: widget.file.path,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) => setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) => setState(() => this.indexPage = indexPage!),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                onPressed: () => _showSummarizeDialog(context),
                icon: Icon(Icons.summarize),
                label: Text("Summarize"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                onPressed: () => _showAskDialog(context),
                icon: Icon(Icons.question_answer),
                label: Text("Ask"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                onPressed: () => _showRecommendDialog(context),
                icon: Icon(Icons.recommend),
                label: Text("Recommend"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSummarizeDialog(BuildContext context) {
    final TextEditingController chapterController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Summarize"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: chapterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Chapter Number",
                  hintText: "Enter chapter number to summarize",
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Add logic to summarize the whole book
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Summarizing the whole book...")),
                      );
                    },
                    child: Text("Whole Book"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Add logic to summarize the selected chapter
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Summarizing Chapter ${chapterController.text}..."),
                        ),
                      );
                    },
                    child: Text("Selected Chapter"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }



  void _showAskDialog(BuildContext context) {
    final TextEditingController questionController = TextEditingController();
    bool isLoading = false;
    String? responseMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _sendAskRequest() async {
              setState(() => isLoading = true);
              final url =
              Uri.parse("https://3786-196-235-94-84.ngrok-free.app/api/upload/");
              final response = await http.get(url.replace(queryParameters: {
                "user_id": "123",
                "book_name": "richdadpoordad",
                "action_type": "question",
                "query": questionController.text,
              }));

              setState(() {
                isLoading = false;
                if (response.statusCode == 200) {
                  responseMessage = json.decode(response.body)['answer'] ??
                      "No response message provided.";
                } else {
                  responseMessage = "Error: ${response.reasonPhrase}";
                }
              });
            }

            return AlertDialog(
              title: Text("Ask a Question"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else ...[
                    if (responseMessage == null)
                      TextField(
                        controller: questionController,
                        decoration: InputDecoration(
                          labelText: "Your Question",
                          hintText: "Type your question here",
                        ),
                      )
                    else
                      Text(
                        responseMessage!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ],
              ),
              actions: [
                if (responseMessage == null)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel"),
                  ),
                if (responseMessage == null)
                  TextButton(
                    onPressed: () async {
                      if (questionController.text.isNotEmpty) {
                        await _sendAskRequest();
                      } else {
                        setState(() {
                          responseMessage = "Please enter a valid question.";
                        });
                      }
                    },
                    child: Text("Ask"),
                  )
                else
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Close"),
                  ),
              ],
            );
          },
        );
      },
    );
  }


  void _showRecommendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Recommend"),
          content: Text(
              "Get personalized recommendations based on the document's content."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
