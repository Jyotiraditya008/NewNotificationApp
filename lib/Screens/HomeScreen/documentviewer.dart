import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class DocumentViewer extends StatelessWidget {
  final String documentUrl;
  final String? fileType;

  DocumentViewer({required this.documentUrl, this.fileType});

  @override
  Widget build(BuildContext context) {
    // Ensure that the document URL starts with "https://mycampus.cloud"
    String formattedUrl = documentUrl.startsWith('https://mycampus.cloud')
        ? documentUrl // If already formatted correctly, use the same URL
        : 'https://mycampus.cloud$documentUrl'; // Append the base URL if not already present

    print('Formatted URL: $formattedUrl'); // Print formatted URL for debugging

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Attachment',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black), // Set back button color
      ),
      body: fileType == 'pdf'
          ? FutureBuilder<PDFDocument>(
              future: PDFDocument.fromURL(
                formattedUrl,
                headers: {}, // Add any headers if necessary
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return PDFViewer(document: snapshot.data!);
                  } else if (snapshot.hasError) {
                    print('PDF Loading Error: ${snapshot.error}');
                    return Center(
                      child: Text('Error loading PDF: ${snapshot.error}'),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse("$formattedUrl"), // Use about:blank initially
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                ),
              ),
              onLoadError: (controller, url, code, message) {
                print('Error loading document: $code, $message');
              },
              onWebViewCreated: (controller) async {
                await controller.loadUrl(
                  urlRequest: URLRequest(url: Uri.parse(formattedUrl)),
                );
              },
              onLoadStop: (controller, url) {
                print('Document loaded: $url');
              },
            ),
    );
  }
}
