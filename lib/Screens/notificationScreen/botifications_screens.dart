import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Common/common_app_bar_widget.dart';
import '../../Common/custom_app_drawer.dart';
import '../../SharedPref/pref.dart';
import '../../SharedPref/pref_constants.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isLoading = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(Prefs.getString(PreferenceConstants.authToken)!);
    }
    return Scaffold(
      appBar: CommonAppBarWidget(context, true),
      drawer: appDrawer(context),
      extendBody: true,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(
              url: Uri.parse(
                  'http://10.0.0.5/cle8/app_Assets/webviews/notifications.html')),
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
