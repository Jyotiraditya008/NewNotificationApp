import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:minervaschool/Screens/ExtendedViewScreens/Results.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResultsDetailScreen extends StatelessWidget {
  final ResultsPost resources;

  ResultsDetailScreen({required this.resources});

  // ... (existing code)

  // Function to handle attachment download
  Future<void> downloadAttachment(Attachment attachment) async {
    try {
      // Get the application directory for storing the downloaded file
      final appDocDir = await getApplicationDocumentsDirectory();

      // Construct the file path using the display name of the attachment
      final filePath = '${appDocDir.path}/${attachment.displayName}';

      // Create a Dio instance
      final dio = Dio();

      // Download the attachment
      await dio.download(attachment.url, filePath);

      // Show a toast message for successful download
      Fluttertoast.showToast(
        msg: 'Download successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        // Show a toast message for resource not found
        Fluttertoast.showToast(
          msg: 'Uh oh! Resource not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        // Show a toast message for generic download failure
        Fluttertoast.showToast(
          msg: 'Uh oh! Download failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      // Handle other Dio errors
      print('DioError: $e');
    } catch (e) {
      // Show a toast message for generic download failure
      Fluttertoast.showToast(
        msg: 'Uh oh! Download failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      // Handle other exceptions
      print('Error: $e');
    }
  }

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
