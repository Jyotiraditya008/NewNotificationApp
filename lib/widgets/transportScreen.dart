import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../SharedPref/pref.dart';
import '../../../SharedPref/pref_constants.dart';

class TransportScreenWidget extends StatefulWidget {
  const TransportScreenWidget({super.key});

  @override
  State<TransportScreenWidget> createState() => _TransportScreenWidgetState();
}

TextStyle montserratTextStyle({
  double? fontSize, // Add '?' to make it nullable
  FontWeight? fontWeight, // Add '?' to make it nullable
  Color? color, // Add '?' to make it nullable
}) {
  return TextStyle(
    fontFamily: 'Montserrat',
    fontSize: fontSize ?? 19.0, // Provide a default value if not specified
    fontWeight: fontWeight ??
        FontWeight.bold, // Provide a default value if not specified
    color: color ?? Colors.black, // Provide a default value if not specified
  );
}

class _TransportScreenWidgetState extends State<TransportScreenWidget> {
  bool isLoading = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(Prefs.getString(PreferenceConstants.authToken)!);
    }
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 254, 254), // Set the background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(44.0),
          topRight: Radius.circular(44.0),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: InAppWebView(
              onDownloadStartRequest: (controller, downloadStartRequest) async {
                print("downloda request${downloadStartRequest.url.toString()}");
                await downloadFile(downloadStartRequest.url.toString(),
                    downloadStartRequest.suggestedFilename);
              },
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                  'http://mycampus.cloud/App_Assets/webviews/routines.html',
                ),
              ),
              initialUserScripts: UnmodifiableListView<UserScript>([
                UserScript(
                  source:
                      "Comms.Broadcast({ key: \"token\",value: \"${Prefs.getString(PreferenceConstants.authToken)}\"});",
                  injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
                ),
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
