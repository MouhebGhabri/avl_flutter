import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'API/links.dart';
import 'main.dart';
class PDFViewerPage extends StatefulWidget {
  final File file;
  final String bookName;

  const PDFViewerPage({
    Key? key,
    required this.file,
    required this.bookName
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  final sharedPref =  SharedPreferences.getInstance();


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
    bool isLoading = false;
    String? responseMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _sendSummarizeRequest({String? chapter}) async {
              setState(() => isLoading = true);

              final url =Uri.parse(GlobalAPIUriDjango+"/api/upload/");

              final queryParameters = {
                "user_id": localStorage.getItem('sid')      , // Replace with actual user_id
                "book_name": widget.bookName, // Dynamically use the bookName from the widget
                "action_type": "resume",
              };
              if (chapter != null) {
                queryParameters["chapter"] = chapter;
              }

              final response = await http.get(url.replace(queryParameters: queryParameters));

              setState(() {
                isLoading = false;
                if (response.statusCode == 200) {
                  responseMessage = json.decode(response.body)['summary'] ??
                      "No response message provided.";
                } else {
                  responseMessage = "Error: ${response.reasonPhrase}";
                }
              });
            }

            return AlertDialog(
              title: Text("Summarize"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (responseMessage == null)
                    TextField(
                      controller: chapterController,
                      decoration: InputDecoration(
                        labelText: "Chapter (Optional)",
                        hintText: "Enter chapter number",
                      ),
                      keyboardType: TextInputType.number,
                    )
                  else
                    Text(
                      responseMessage!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              actions: [
                if (responseMessage == null) ...[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _sendSummarizeRequest(); // Summarize entire book
                    },
                    child: Text("Summarize Book"),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (chapterController.text.isNotEmpty) {
                        await _sendSummarizeRequest(
                            chapter: chapterController.text);
                      } else {
                        setState(() {
                          responseMessage = "Please enter a valid chapter number.";
                        });
                      }
                    },
                    child: Text("Summarize Chapter"),
                  ),
                ] else
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
              Uri.parse(GlobalAPIUriDjango+"/api/upload/");
              final response = await http.get(url.replace(queryParameters: {
                "user_id": localStorage.getItem('sid')      , // Replace with actual user_id
                "book_name": widget.bookName, // Dynamically use the bookName from the widget
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
    bool isLoading = false;
    String? recommendationMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _fetchRecommendations() async {
              setState(() => isLoading = true);

              try {
                String bookNameWithoutExtension = widget.bookName.split('.').first;

                String formattedBookName = bookNameWithoutExtension.replaceAll('-', ' ');
                final url = Uri.parse("${GlobalAPIUriFlask}/recommend/${formattedBookName}");
                final response = await http.get(url);
                setState(() {
                  isLoading = false;
                  if (response.statusCode == 200) {
                    recommendationMessage = response.body; // Assume plain text response
                  } else {
                    recommendationMessage =
                    "Error: ${response.reasonPhrase ?? 'Unable to fetch recommendations.'}";
                  }
                });
              } catch (e) {
                setState(() {
                  isLoading = false;
                  recommendationMessage = "An error occurred: $e";
                });
              }
            }

            return AlertDialog(
              title: Text("Recommend"),
              content: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : recommendationMessage == null
                  ? Text(
                "Click the button below to get personalized recommendations for this book.",
              )
                  : Text(
                recommendationMessage!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                if (recommendationMessage == null)
                  TextButton(
                    onPressed: _fetchRecommendations,
                    child: Text("Get Recommendations"),
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

}
