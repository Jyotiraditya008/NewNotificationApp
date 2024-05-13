import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:minervaschool/Resources/app_font.dart';
import 'package:minervaschool/Screens/DashBoardScreen/transport/transport_screen.dart';
import 'package:dio/dio.dart'; // Add this import
import 'package:minervaschool/Screens/ExtendedViewScreens/Assessments.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Attendance.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/LearningResources.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Results.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/TeacherNotes.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/homework.dart';
import 'package:minervaschool/Screens/drawerscreens/attendance_screen.dart';
import 'package:minervaschool/Screens/HomeScreen/pdf_viewer.dart';
import 'package:dotted_border/dotted_border.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
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

class _AcademicsScreenState extends State<AcademicsScreen> {
  final List<String> buttonLabels = [
    'Homework',
    'Teacher Notes',
    'Learning Resources',
    'Assesments',
    'Result',
  ];

  final List<Map<String, dynamic>> buttonData = [
    {
      'text': 'Homework',
      'imagePath': 'assets/finalImages/Homework.png',
    },
    {
      'text': 'Learning  Resources',
      'imagePath': 'assets/finalImages/LearningResources.png',
    },
    {
      'text': 'Teacher Notes',
      'imagePath': 'assets/finalImages/TeacherNotes.png',
    },
    {
      'text': 'Assesments',
      'imagePath': 'assets/finalImages/Assessments.png',
    },
    {
      'text': 'Results',
      'imagePath': 'assets/finalImages/Result.png',
    },

    // Add entries for other buttons with their respective text and image paths
  ];

  final List<Color> buttonColors = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255),
    Color.fromRGBO(253, 255, 255, 1),
    Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 255, 255, 255),
  ];

  final List<StaggeredTile> buttonSizes = [
    StaggeredTile.count(1, 1), // Size for the 'Home' button
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
  ];

  List<Post> apiData = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/newbackground/Homepagehomebg.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 40),
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Academics",
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight:
                            FontWeight.w700, // Adjust the weight as needed
                        fontSize: 35.0,
                        color: Color.fromARGB(255, 1, 35, 73),
                      ),
                    ),
                    Image.asset(
                      "assets/newIcons/Academics_bottom.png",
                      width: 70,
                      height: 70,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // Remove the decoration and ensure there is no extra padding or margin
                  child: ListView.separated(
                    itemCount: buttonLabels.length,
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeworkScreen(),
                                ),
                              );
                            } else if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherNotes(),
                                ),
                              );
                            } else if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Learningresources(),
                                ),
                              );
                            } else if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Assessments(),
                                ),
                              );
                            } else if (index == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Results(),
                                ),
                              );
                            }
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    buttonData[index]['imagePath'],
                                    width: 44,
                                    height: 44,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    buttonLabels[index],
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight
                                          .w500, // Adjust the weight as needed
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                    // child: Center(
                                    //   child: Text(
                                    //     [5, 1, 2, 12, 1][index].toString(),
                                    //     style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
