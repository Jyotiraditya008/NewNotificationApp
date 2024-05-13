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

class FamilyProfileScreen extends StatefulWidget {
  const FamilyProfileScreen({super.key});

  @override
  State<FamilyProfileScreen> createState() => _FamilyProfileScreenState();
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

class _FamilyProfileScreenState extends State<FamilyProfileScreen> {
  bool isLoading = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(Prefs.getString(PreferenceConstants.authToken)!);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "",
          style: montserratTextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        // Add a back button to the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: InAppWebView(
            onDownloadStartRequest: (controller, downloadStartRequest) async {
              print("downloda request${downloadStartRequest.url.toString()}");
              await downloadFile(downloadStartRequest.url.toString(),
                  downloadStartRequest.suggestedFilename);
            },
            key: webViewKey,
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    'http://mycampus.cloud/app_Assets/webviews/profile.html?n=1')),
            //'http://10.0.0.5/cle8/app_Assets/webviews/fee.html?n=2')),
            initialUserScripts: UnmodifiableListView<UserScript>([
              UserScript(
                  source:
                      "Comms.Broadcast({ key: \"token\",value: \"${Prefs.getString(PreferenceConstants.authToken)}\"});",
                  injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
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


//'http://mycampus.cloud/app_Assets/webviews/profile.html?n=1