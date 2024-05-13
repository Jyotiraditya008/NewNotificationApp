import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:minervaschool/Screens/ExtendedViewScreens/Newsletter.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewsletterDetailScreen extends StatelessWidget {
  final NewsletterPost resources;

  NewsletterDetailScreen({required this.resources});

  @override
  Widget build(BuildContext context) {
    // Parse the HTML content and extract text
    String parsedContent = htmlParser.parse(resources.content).body!.text;

    bool hasAttachments = resources.attachments.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 30,
        flexibleSpace: Center(
          child: Image.asset(
            'assets/images/minerva.png',
            height: 55,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  resources.title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  resources.subject,
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  resources.content,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                // Use Html to render the HTML content
                Html(
                  data: parsedContent,
                ),
                SizedBox(height: 16.0),
                // Check if there are attachments, and show the download button if true
                hasAttachments
                    ? ElevatedButton(
                        onPressed: () async {
                          // Check if there are attachments
                          if (resources.attachments.isNotEmpty) {
                            // Create a Dio instance
                            final Dio dio = Dio();

                            for (var attachment in resources.attachments) {
                              try {
                                // Get the document directory
                                final appDocDir =
                                    await getApplicationDocumentsDirectory();

                                // Define the file path where the attachment will be saved
                                final filePath =
                                    '${appDocDir.path}/${attachment.displayName}';

                                // Download the file
                                await dio.download(attachment.url, filePath);

                                // Show a toast message for successful download
                                Fluttertoast.showToast(
                                  msg: 'Download successful: $filePath',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } catch (e) {
                                // Show a toast message for download failure
                                Fluttertoast.showToast(
                                  msg: 'Uh oh! Download failed',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );

                                // Handle download errors
                                print('Error downloading file: $e');
                              }
                            }
                          }
                        },
                        child: Text('Download Attachments'),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
