// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:smart_nation/models/DashBoardIcon.dart';
// import 'package:smart_nation/repo/api_repository.dart';
// import 'package:smart_nation/resources/app_color.dart';
// import 'package:smart_nation/resources/app_images.dart';
// import 'package:smart_nation/resources/app_strings.dart';
// import 'package:smart_nation/resources/global_variable.dart';
// import 'package:smart_nation/screens/Conference/conference_details.dart';
// import 'package:smart_nation/screens/Conference/conference_list.dart';
// import 'package:smart_nation/screens/Exhibitors/exhibitor_details.dart';
// import 'package:smart_nation/screens/Exhibitors/exhibitors_list.dart';
// import 'package:smart_nation/screens/Information/InformationScreen.dart';
// import 'package:smart_nation/screens/Products/product_details.dart';
// import 'package:smart_nation/screens/Products/product_list.dart';
// import 'package:smart_nation/screens/Registration/registration_web_view_screen.dart';
// import 'package:smart_nation/screens/Seminar/seminar_details.dart';
// import 'package:smart_nation/screens/Seminar/seminar_list.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);
//   static const List<DashBoardIcon> choices = [
//     DashBoardIcon(
//         title: AppStrings.exhibitors,
//         image: AppImages.exhibitors,
//         color: AppColor.blue800),
//     DashBoardIcon(
//         title: AppStrings.products,
//         image: AppImages.products,
//         color: Colors.yellow),
//     DashBoardIcon(
//         title: AppStrings.conferences,
//         image: AppImages.conference,
//         color: Colors.black),
//     DashBoardIcon(
//         title: AppStrings.seminars,
//         image: AppImages.seminar,
//         color: Colors.red),
//     DashBoardIcon(
//         title: AppStrings.register,
//         image: AppImages.register,
//         color: Colors.green),
//     DashBoardIcon(
//         title: AppStrings.info, image: AppImages.info, color: Colors.purple),
//   ];

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final ApiRepository _apiRepository = ApiRepository();
//   bool _isAsyncCall = true;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   late AndroidNotificationChannel channel;

//   @override
//   void initState() {
//     GlobalData.zoneData.clear();
//     GlobalData.categoryData.clear();
//     GlobalData.newCategoryData.clear();
//     initialize();
//     _apiRepository.getAllZones().then((value) {
//       GlobalData.zoneData = value.zoneData!;
//     });

//     _apiRepository.saveToken().then((value) {});

//     _apiRepository.getAllCategories().then((value) {
//       GlobalData.categoryData = value.zoneData!;
//     });

//     _apiRepository.getNewCategories().then((value) {
//       GlobalData.newCategoryData = value.zoneData!;
//       setState(() {
//         _isAsyncCall = false;
//       });
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ModalProgressHUD(
//         inAsyncCall: _isAsyncCall,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Center(
//                   child: Center(
//                 child: Image.asset(
//                   AppImages.logo,
//                   height: 90.h,
//                   width: 240.w,
//                 ),
//               )),
//               Center(
//                   child: Image.asset(
//                 AppImages.dashboard,
//                 height: 150.h,
//                 width: 300.w,
//               )),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
//                   child: GridView.count(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     childAspectRatio: (1 / .75),
//                     crossAxisCount: 2,
//                     children:
//                         List.generate(DashboardScreen.choices.length, (index) {
//                       return InkWell(
//                         onTap: () {
//                           switch (DashboardScreen.choices[index].title) {
//                             case AppStrings.exhibitors:
//                               Navigator.pushNamed(
//                                   context, ExhibitorsList.id.toString());
//                               break;
//                             case AppStrings.products:
//                               Navigator.pushNamed(context, ProductsList.id);
//                               break;
//                             case AppStrings.conferences:
//                               Navigator.pushNamed(
//                                   context, ConferenceListScreen.id);
//                               break;

//                             case AppStrings.seminars:
//                               Navigator.pushNamed(
//                                   context, SeminarListScreen.id);
//                               break;
//                             case AppStrings.register:
//                               Navigator.pushNamed(
//                                   context, RegistrationWebViewScreen.id);
//                               break;

//                             case AppStrings.info:
//                               Navigator.pushNamed(
//                                   context, InformationScreen.id);
//                               break;
//                           }
//                         },
//                         child: Card(
//                           elevation: 5,
//                           color: DashboardScreen.choices[index].color,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   DashboardScreen.choices[index].image,
//                                   width: 60,
//                                   height: 60,
//                                 ),
//                                 const SizedBox(
//                                   height: 8,
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     DashboardScreen.choices[index].title,
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//               Image.asset(
//                 AppImages.companyLogo,
//                 height: 50.h,
//                 width: 100.w,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> initialize() async {
//     /* await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();*/
//     flutterLocalNotificationsPlugin = await FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }

//   Future<void> onSelectNotification(String? payload) async {
//     // print("--------> onSelectNotification $payload");
//     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     //   content: Text("onSelectNotification-----------> $payload}"),
//     // ));
//     if (payload!.split("#")[0].toString() ==
//         AppStrings.exhibitor.toLowerCase()) {
//       print("--------> ${payload.split("#")[0]}");
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExhibitorDetails(
//               exhibitorId: payload.split("#")[1],
//             ),
//           ));
//     } else if (payload.split("#")[0].toString() ==
//         AppStrings.product.toLowerCase()) {
//       print("--------> ${payload.split("#")[1]}");
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetails(
//               productId: payload.split("#")[1],
//             ),
//           ));
//     } else if (payload.split("#")[0].toString().toLowerCase() ==
//         AppStrings.conference.toLowerCase()) {
//       print("--------> ${payload.split("#")[1]}");
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ConferenceDetails(
//               conferenceId: payload.split("#")[1],
//               title: AppStrings.confDetail,
//             ),
//           ));
//     } else if (payload.split("#")[0].toString().toLowerCase() ==
//         AppStrings.seminar.toLowerCase()) {
//       print("--------> ${payload.split("#")[1]}");
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SeminarDetailScreen(
//               conferenceId: payload.split("#")[1],
//               title: AppStrings.seminarDetail,
//             ),
//           ));
//     } else {
//       print("==========>in else ${payload}");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(payload),
//       ));
//     }
//   }

//   NotificationDetails settingsNotifications() {
//     var androidPlatformChannelSpecifics =
//         const AndroidNotificationDetails('fcm_default_channel', 'notification');
//     var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
//     return NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//   }
// }
