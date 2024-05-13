import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../SharedPref/pref.dart';
import '../SharedPref/pref_constants.dart';

class NotificationScreen extends StatefulWidget {
  static const id = NotificationScreen;
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  bool isLoading = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(Prefs.getString(PreferenceConstants.authToken)!);
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(
              url: Uri.parse(
                  'http://mycampus.cloud/App_Assets/webviews/mailbox.html')),
          // 'http://10.0.0.5/cle8/app_Assets/webviews/mailbox.html')),
          // 'http://10.0.0.5/cle8/app_Assets/webviews/drawer.html?n=2')),
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

  Future<void> initialize() async {
    /* await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();*/
    flutterLocalNotificationsPlugin = await FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings();
  }
}
