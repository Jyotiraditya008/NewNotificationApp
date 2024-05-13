import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EventsDetails extends StatefulWidget {
  const EventsDetails({super.key});

  @override
  State<EventsDetails> createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF974889),
        title: const Text(
          'Events Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                child: Text(
                  'Events Incharge',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Image.network("https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
                        fit: BoxFit.fitHeight,
                        width: 75,height: 75),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Incharge : Shiham madhan',
                            style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 7,),
                          Text(
                            'Phone : 83247893274',
                            style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                child: Text(
                  'Terms and Conditions',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
              child: InAppWebView(
                onDownloadStartRequest: (controller, downloadStartRequest) async {
                  print("downloda request${downloadStartRequest.url.toString()}");
                  await downloadFile(downloadStartRequest.url.toString(),
                      downloadStartRequest.suggestedFilename);
                },
                key: webViewKey,
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        'https://www.google.com')),
                initialUserScripts: UnmodifiableListView<UserScript>([
                ]),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                  controller.addJavaScriptHandler(
                    handlerName: 'commsHandler',
                    callback: (List<dynamic> arguments) {
                      print("========= " + arguments.length.toString());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadFile(String url, [String? filename]) async {
    var hasStoragePermission = await Permission.storage.isGranted;
    if (!hasStoragePermission) {
      final status = await Permission.storage.request();
      hasStoragePermission = status.isGranted;
    }
    if (hasStoragePermission) {
      final taskId = await FlutterDownloader.enqueue(
          url: url,
          headers: {},
          // optional: header send with url (auth token etc)
          savedDir: (await getTemporaryDirectory()).path,
          saveInPublicStorage: true,
          fileName: filename);
    }
  }
}

