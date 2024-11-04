import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Documentviewer extends StatefulWidget {
  const Documentviewer({super.key});

  @override
  State<Documentviewer> createState() => _documentviewer();
}

class _documentviewer extends State<Documentviewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title:  const Text("Pdf"),
      ),
      body: SfPdfViewer.asset(""),
    );

  }
}
