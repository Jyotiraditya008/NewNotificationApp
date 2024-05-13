import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../SharedPref/pref.dart';
import '../../../SharedPref/pref_constants.dart';

Widget viewMethod(String url, GlobalKey webViewKey,
    InAppWebViewController? webViewController, bool isLoading) {
  return ModalProgressHUD(
    inAsyncCall: isLoading,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
