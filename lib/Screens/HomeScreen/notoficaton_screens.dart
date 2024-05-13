import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../SharedPref/pref.dart';
import '../../SharedPref/pref_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    print(Prefs.getString(PreferenceConstants.authToken)!);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InAppWebView(
            key: webViewKey,
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(useOnDownloadStart: true),
            ),
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    'http://mycampus.cloud/app_Assets/webviews/notifications.html')),
            // url: Uri.parse(
            //     'http://10.0.0.5/cle8/app_Assets/webviews/notifications.html')),
            initialUserScripts: UnmodifiableListView<UserScript>([
              UserScript(
                  source:
                      "Comms.Broadcast({ key: \"token\",value: \"${Prefs.getString(PreferenceConstants.authToken)}\"});",
                  injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
            ]),
            onWebViewCreated: (controller) {
              webViewController = controller;
              controller.addJavaScriptHandler(
                handlerName: 'preview',
                callback: (List<dynamic> arguments) {
                  print("========= " + arguments.length.toString());
                },
              );
            },
            onDownloadStartRequest: (controller, url) async {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("download start requist passed")));
              print("onDownloadStartRequest $url");
            },
          ),
        ),
      ),
    );
  }
}
