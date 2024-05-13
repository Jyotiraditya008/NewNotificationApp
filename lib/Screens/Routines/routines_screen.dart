import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:minervaschool/Common/common_notifications.dart';
import 'package:minervaschool/Resources/app_font.dart';
import 'package:minervaschool/Screens/DashBoardScreen/transport/transport_screen.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Events.dart';

import 'package:minervaschool/Screens/ExtendedViewScreens/News.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/TeacherNotes.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Newsletter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:minervaschool/widgets/AttendanceWidget.dart';
import 'package:minervaschool/widgets/ConductandbehaviourWidget.dart';
import 'package:minervaschool/widgets/FrontOfficeWidget.dart';
import 'package:minervaschool/widgets/HealthWidget.dart';
import 'package:minervaschool/widgets/transportScreen.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class Post {
  final String heading;
  final String date;
  final String content;
  final String studentImageUrl;
  final String type;

  Post({
    required this.heading,
    required this.date,
    required this.content,
    required this.studentImageUrl,
    required this.type,
  });
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

class _RoutinesScreenState extends State<RoutinesScreen> {
  final List<String> buttonLabels = [
    'News',
    'Events',
    'Teacher Notes',
    'Mails',
    'Newsletter',
  ];

  Widget _currentWidget = FrontOfficeWidget(); // Default widget

  final List<Map<String, dynamic>> buttonData = [
    {
      'text': 'News',
      'imagePath': 'assets/finalImages/News.png',
    },
    {
      'text': 'Events',
      'imagePath': 'assets/finalImages/Events.png',
    },
    {
      'text': 'Teacher Notes',
      'imagePath': 'assets/finalImages/TeacherNotes.png',
    },
    {
      'text': 'Mails',
      'imagePath': 'assets/finalImages/Mail.png',
    },
    {
      'text': 'Newsletter',
      'imagePath': 'assets/finalImages/NewsLetter.png',
    },
  ];

  final List<Color> buttonColors = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 254, 254),
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255),
  ];

  final List<StaggeredTile> buttonSizes = [
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1), // Size for the 'Home' button
    StaggeredTile.count(1, 1), // Size for the 'Home' button
    StaggeredTile.count(1, 1), // Size for the 'Home' button
    StaggeredTile.count(1, 1), // Size for the 'Home' button
    StaggeredTile.count(1, 1), // Size for the 'Home' button
    // Size for the 'Home' button
  ];

  List<Post> apiData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.fromLTRB(1, 0, 1, 65),
        constraints: BoxConstraints.expand(
          height: 900,
          width: double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/newbackground/Homepagehomebg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 75,
              padding: EdgeInsets.fromLTRB(9, 12, 9, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(200, 248, 248, 248),
                    ),
                    padding: EdgeInsets.all(1.0),
                    child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Image.asset(
                        'assets/newIcons/drawer.png',
                        width: 75,
                        height: 75,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(202, 255, 255, 255),
                    ),
                    padding: EdgeInsets.all(1.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NotificationScreen()), // Replace MailScreen() with your actual screen
                        );
                      },
                      icon: Image.asset(
                        'assets/newIcons/Message.png',
                        width: 65,
                        height: 65,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 1.0, top: 0, left: 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Color.fromARGB(255, 1, 35, 73),
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          "Routines",
                          style: TextStyle(
                            color: Color.fromARGB(255, 1, 35, 73),
                            fontFamily: 'Metropolis',
                            fontWeight:
                                FontWeight.w700, // Adjust the weight as needed
                            fontSize: 28.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 370,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(194, 255, 255, 255),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentWidget = FrontOfficeWidget();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(0, 255, 255, 255),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    26.0), // Set the desired corner radius
                              ),
                            ),
                            child: Image.asset(
                              'assets/newIcons/FrontOffice.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentWidget = Attendance();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    26.0), // Set the desired corner radius
                              ),
                            ),
                            child: Image.asset(
                              'assets/newIcons/Attendance.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentWidget = health();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    26.0), // Set the desired corner radius
                              ),
                            ),
                            child: Image.asset(
                              'assets/newIcons/Health.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentWidget = Conductandbehaviour();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    26.0), // Set the desired corner radius
                              ),
                            ),
                            child: Image.asset(
                              'assets/newIcons/Conductandbehaviour.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentWidget = TransportScreenWidget();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    26.0), // Set the desired corner radius
                              ),
                            ),
                            child: Image.asset(
                              'assets/newIcons/TransPort_bottom.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.64,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        ),
                      ),
                      child: _currentWidget,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
