import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minervaschool/Common/new_app_drawer.dart';
import 'package:minervaschool/Resources/app_images.dart';
import 'package:minervaschool/Resources/global_variable.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Essentials.dart';
import 'package:minervaschool/Screens/HomeScreen/home_screen.dart';
import 'package:minervaschool/Screens/Routines/Routines_screen.dart';
import 'package:minervaschool/Screens/ModuleScreens/module_screen.dart';
import 'package:minervaschool/Screens/drawerscreens/family_profile_screen.dart';
import '../../Resources/app_colors.dart';
import '../../Resources/constants.dart';
import 'academics/academics_screen.dart';
import 'fee/fee_screen.dart';

class DashboardScreen extends StatefulWidget {
  final dynamic data;
  final String userRole;

  // Declare userRole variable
  static const id = "DashBoardScreen";
  const DashboardScreen({
    Key? key,
    this.data,
    required this.userRole,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  String? userRole; // Declare a variable to store the received user role
  String token = '';
  bool isFlutterLocalNotificationsInitialized = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  late int _selectedIndex;

  bool isAsyncCall = false, isPurchased = true;
  GlobalKey bottomNavigationKey = GlobalKey();
  static late TabController _tabController;

  void _onItemTapped(int index) {
    if (kDebugMode) {
      print(_selectedIndex + index);
    }
    setState(() {
      _selectedIndex = index;

      _tabController.animateTo(_selectedIndex);
    });
  }

  List<Widget> pages = [];

  initialization() {
    _tabController = TabController(length: 7, vsync: this);
    pages.add(AcademicsScreen());

    pages.add(FeeScreen());
    pages.add(HomeScreen(
      role: '',
    ));
    pages.add(EssentialScreen());
    pages.add(RoutinesScreen());
    pages.add(ModuleScreen());
    pages.add(FamilyProfileScreen());

    ondata();
  }

  ondata() {
    if (widget.data != null) {
      setState(() {
        _selectedIndex = widget.data;
      });
    } else {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic('topic');
    userRole = widget.userRole;
    print('userRole in dashboard');
    print(userRole);
    getFCMToken();
    initialization();
    initializeNotification1();

    initialize();
    _tabController.animateTo(2);
    _tabController.addListener(() {
      if (_tabController.index > 5) {
        GlobalData.isShow = false;
        _getBgColor(_tabController.previousIndex);
        _getItemColor(_tabController.previousIndex);
        _getBorderColor(_tabController.previousIndex);
      } else {
        GlobalData.isShow = true;
      }

      print("${_tabController.index}===========tabcontroller index");
    });
    super.initState();
  }

  Future<void> initialize() async {
    flutterLocalNotificationsPlugin = await FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  initializeNotification1() async {
    flutterLocalNotificationsPlugin = await FlutterLocalNotificationsPlugin();
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data.isNotEmpty) {
          message.data.isNotEmpty
              ? onSelectNotification(notificationPayload(message))
              : null;
        }
      });

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          RemoteNotification? notification = message.notification;
          if (notification != null && !kIsWeb) {
            message.data.isNotEmpty
                ? onSelectNotification(notificationPayload(message))
                : null;
          }
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        if (notification != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            settingsNotifications(),
          );
        }
      });
    }
  }

  String notificationPayload(RemoteMessage? notification) {
    return "";
  }

  Future<void> onSelectNotification(String? payload) async {
    print("--------> onSelectNotification $payload");
  }

  NotificationDetails settingsNotifications() {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'high_importance_channel', 'notification',
        icon: '@mipmap/ic_launcher');
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    return NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
  }

  getFCMToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      if (value != null) {
        token = value;
      } else {
        token = "";
      }
      print("=============> FCM TOKEN: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_tabController.index == 5) {
          _onItemTapped(4);
        } else {
          if (_selectedIndex != 0) {
            _onItemTapped(0);
          } else {
            exit(0);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        drawer: DrawerFb1(
          _tabController,
        ),
        extendBody: true,
        // appBar: CommonAppBarWidget(context, true),
        // backgroundColor: AppColors.white,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
            splashColor: Colors.transparent,
            primaryColor: Colors.transparent,
            textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.transparent),
                ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 189, 190, 255),
                  Colors.white,
                ],
              ),
            ),
            child: BottomNavigationBar(
              key: bottomNavigationKey,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              elevation: 0.0, // Set elevation to 0.0 to remove grey area
              onTap: (value) {
                _onItemTapped(value);
              },
              selectedFontSize: 0,
              currentIndex: _selectedIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.Academics, "Academics", 0),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.fee, "Fee", 1),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.home, "Home", 2),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.transport, "Essentials", 3),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.routines, "Routines", 4),
                  label: "",
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: pages,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  Widget _buildIcon(String iconData, String text, int index) => Container(
        width: kBottomNavigationBarHeight * 1.2,
        height: kBottomNavigationBarHeight * 1.2,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Make it circular
          color: const Color.fromARGB(0, 0, 0, 0), // Set the background color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              iconData,
              height: 35,
              width: 35,
            ),
            Text(
              text,
              style: ts12Bold.copyWith(
                  color: _selectedIndex == index
                      ? AppColors.black // Change text color when selected
                      : _getItemColor(index),
                  fontSize: 11),
            ),
          ],
        ),
      );

  Color _getBgColor(int index) {
    if (kDebugMode) {
      print("GlobalData.isShow: ${GlobalData.isShow}");
      print("_selectedIndex: ${_selectedIndex}");
      print("index: ${index}");
    }
    return GlobalData.isShow
        ? _selectedIndex == index
            ? AppColors.white
            : AppColors.white
        : AppColors.white;
  }

  Color _getBorderColor(int index) => GlobalData.isShow
      ? _selectedIndex == index
          ? AppColors.white
          : AppColors.white
      : AppColors.white;

  Color _getItemColor(int index) => GlobalData.isShow
      ? _selectedIndex == index
          ? AppColors.white
          : Color.fromARGB(255, 118, 118, 118)
      : AppColors.white;
}
