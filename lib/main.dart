import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minervaschool/routes.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'Cubits/RegisterCubit/register_cubit.dart';
import 'Repo/api_repositories.dart';
import 'Resources/app_strings.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          importance: Importance.max, priority: Priority.high, showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
      message.notification!.body, platformChannelSpecifics,
      payload: message.data['data']);

  print('Handling a background message ${message.data}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  });

  // Initialize FlutterDownloader
  await FlutterDownloader.initialize(
    debug: true, // Set to false in release builds
  );

  await TokenManager().getStoredAuthToken().then((authToken) {
    print('Retrieved Auth Token during initialization 1: $authToken');
  });

  // Add logging statements to debug the issue
  print('Initializing FlutterLocalNotificationsPlugin...');

  // Initialize the FlutterLocalNotificationsPlugin instance
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: null);
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  print('InitializationSettings: $initializationSettings');
  print('FlutterLocalNotificationsPlugin: $flutterLocalNotificationsPlugin');

  runApp(const MyApp());
}

// firebaseinit() async {

// }
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  // //  FirebaseMessaging.instance.subscribeToTopic('topic');
  //   super.initState();
  // }
  final ApiRepository repository = ApiRepository();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterCubit(repository)),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
