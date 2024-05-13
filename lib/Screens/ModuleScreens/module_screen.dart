import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:minervaschool/Resources/global_variable.dart';

import '../../SharedPref/pref.dart';
import '../../SharedPref/pref_constants.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({Key? key}) : super(key: key);

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  // String url = "http://10.0.0.5/cle8/app_Assets/webviews/school.html";
  String url = "http://mycampus.cloud/app_Assets/webviews/school.html";
  int index = 0;

  loadURL() {
    print("-----> ${GlobalData.moduleIndex}");
    if (GlobalData.moduleIndex == 0) {
      // url = "http://10.0.0.5/cle8/app_Assets/webviews/school.html";

      url = "http://mycampus.cloud/app_Assets/webviews/school.html";
    }
    if (GlobalData.moduleIndex == 1) {
      // url = "http://10.0.0.5/cle8/app_Assets/webviews/class.html";

      url = "http://mycampus.cloud/app_Assets/webviews/class.html";
    }
    if (GlobalData.moduleIndex == 2) {
      // url = "http://10.0.0.5/cle8/app_Assets/webviews/routines.html";

      url = "http://mycampus.cloud/app_Assets/webviews/routines.html";
    }
    // if (GlobalData.moduleIndex == 3) {
    //   url = "https://mycampus.cloud/app_Assets/webviews/wellbeing.html";
    // }
  }

  @override
  Widget build(BuildContext context) {
    loadURL();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(bottom: 70),
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
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
    );
  }
}
