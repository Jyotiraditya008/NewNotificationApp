import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Assessments.dart';

class AssessmentDetailSrceen extends StatelessWidget {
  final AssessmentsPost resources;
  final List<Map<String, dynamic>> attachments;

  AssessmentDetailSrceen({
    required this.resources,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 16.0),
                // Use FlutterHtml to render HTML content
                Html(data: resources.content),
                SizedBox(height: 16.0),
                hasAttachments
                    ? ElevatedButton(
                        onPressed: () async {
                          // Your download logic here
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
