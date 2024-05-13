// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// import '../Resources/app_images.dart';
// import '../Resources/app_strings.dart';
// import '../Resources/global_variable.dart';
// import '../SharedPref/pref.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   late AndroidNotificationChannel channel;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   String token = '';

//   bool _isAsyncCall = true;

//   @override
//   void initState() {
//     getFCMToken();
//     initializeNotification1();

//     initialize();

//     super.initState();
//   }

//   Future<void> initialize() async {
//     /* await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();*/
//     flutterLocalNotificationsPlugin = await FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }

//   initializeNotification1() async {
//     // await Firebase.initializeApp();
//     flutterLocalNotificationsPlugin = await FlutterLocalNotificationsPlugin();
//     if (!kIsWeb) {
//       channel = const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
        
//       );

//       // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//       /// Create an Android Notification Channel.
//       ///
//       /// We use this channel in the `AndroidManifest.xml` file to override the
//       /// default FCM channel to enable heads up notifications.
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       /// Update the iOS foreground notification presentation options to allow
//       /// heads up notifications.
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         if (message.data.isNotEmpty) {
//           message.data.isNotEmpty
//               ? onSelectNotification(notificationPayload(message))
//               : null;
//           // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           //   content: Text("onMessageOpenedApp-----------> " +
//           //       message.data['category'] +
//           //       "#" +
//           //       message.data['id']),
//           // ));
//         }
//       });

//       FirebaseMessaging.instance.getInitialMessage().then((message) {
//         if (message != null) {
//           RemoteNotification? notification = message.notification;
//           if (notification != null && !kIsWeb) {
//             message.data.isNotEmpty
//                 ? onSelectNotification(notificationPayload(message))
//                 : null;
//             // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             //   content: Text("getInitialMessage-----------> " +
//             //       message.data['category'] +
//             //       "#" +
//             //       message.data['id']),
//             // ));
//           }
//         }
//       });

//       if (Platform.isAndroid) {
//         FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//           RemoteNotification? notification = message.notification;
//           // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           //   content: Text("onMessage-----------> " +
//           //       message.data['category'] +
//           //       "#" +
//           //       message.data['id']),
//           // ));
//           if (notification != null && !kIsWeb) {
//             flutterLocalNotificationsPlugin.show(0, notification.title,
//                 notification.body, settingsNotifications(),
//                 payload: message.data.isNotEmpty
//                     ? notificationPayload(message)
//                     : null);
//           }
//         });
//       }
//     }
//   }

//   String notificationPayload(RemoteMessage? notification) {
//     print("Notification: notificationPayload");
//     var payload = "";
//     var notificationData = notification?.data;
//     payload = notificationData!['category'] + "#" + notificationData['id'];
//     return payload;
//   }

//   Future<void> onSelectNotification(String? payload) async {
//     print("--------> onSelectNotification $payload");
//     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     //   content: Text("onSelectNotification-----------> $payload}"),
//     // ));
//   }

//   NotificationDetails settingsNotifications() {
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//         'fcm_default_channel', 'notification' );
//     var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
//     return NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//   }

//   getFCMToken() async {
//     await FirebaseMessaging.instance.getToken().then((value) {
//       if (value != null) {
//         token = value;
//       } else {
//         token = "";
//       }
//       print("=============> FCM TOKEN: $token");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           backgroundColor: Colors.white,
//           body: const Center(
//             child: Text("center"),
//           )),
//     );
//   }
// }
