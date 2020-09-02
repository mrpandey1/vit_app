import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFViewer extends StatelessWidget {
  final PDFDocument document;

  const PDFViewer({@required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFViewer(document: document),
    );
  }
}
