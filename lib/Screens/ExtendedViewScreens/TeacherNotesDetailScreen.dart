import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:minervaschool/Screens/ExtendedViewScreens/TeacherNotes.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherNotesDetailSrceen extends StatelessWidget {
  final TeacherNotesPost resources;

  TeacherNotesDetailSrceen({required this.resources});

  Future<void> downloadAttachment(Attachment attachment) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();

      final filePath = '${appDocDir.path}/${attachment.displayName}';

      final dio = Dio();

      await dio.download(attachment.url, filePath);

      Fluttertoast.showToast(
        msg: 'Download successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(
          msg: 'Uh oh! Resource not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Uh oh! Download failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      print('DioError: $e');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Uh oh! Download failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Html(
                  data: parsedContent,
                ),
                SizedBox(height: 16.0),
                hasAttachments
                    ? ElevatedButton(
                        onPressed: () async {
                          if (resources.attachments.isNotEmpty) {
                            final Dio dio = Dio();

                            for (var attachment in resources.attachments) {
                              try {
                                final appDocDir =
                                    await getApplicationDocumentsDirectory();
                                final filePath =
                                    '${appDocDir.path}/${attachment.displayName}';
                                await dio.download(attachment.url, filePath);
                                Fluttertoast.showToast(
                                  msg: 'Download successful: $filePath',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: 'Uh oh! Download failed',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
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
