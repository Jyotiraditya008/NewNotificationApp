import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:minervaschool/Screens/DashBoardScreen/transport/transport_screen.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Assessments.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Attendance.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/CircularDetailScreen.dart';
import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/HomeworkDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/DashBoardScreen/fee/fee_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/LearningResources.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/News.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/TeacherNotes.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/homework.dart';
import 'package:minervaschool/Screens/HomeScreen/notoficaton_screens.dart';
import 'package:minervaschool/widgets/AttendanceWidget.dart';
// import 'package:minervaschool/Screens/messenger.dart';
import 'package:minervaschool/widgets/DotIndicator.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Holidays.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Circulars.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
    color: color ?? Colors.white, // Provide a default value if not specified
  );
}

class Post {
  final String heading;
  final String date;
  final String duedate;
  final String content;
  final String st;
  final String studentImageUrl;
  final String type;
  final List<Map<String, dynamic>> attachments;
  List<String> students;

  Post({
    required this.heading,
    required this.date,
    required this.duedate,
    required this.content,
    required this.st,
    required this.studentImageUrl,
    required this.type,
    required this.attachments,
    required this.students,
    required tch,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentIndex = 0; // Initialize currentIndex to 0

  final List<String> buttonLabels = [
    'Holidays',
    'Fee',
    'Homework',
    'Circulars',
  ];

  final List<String> buttonLabels2 = [
    'L.Resources',
    'Attendance',
    'News',
    'Assessment',
  ];

  final List<Map<String, dynamic>> buttonData = [
    {
      'text': 'Holidays',
      'imagePath': 'assets/newIcons/Holidays.png',
    },
    {
      'text': 'Fee',
      'imagePath': 'assets/newIcons/Fees&Receipt.png',
    },
    {
      'text': 'Homework',
      'imagePath': 'assets/finalImages/Homework.png',
    },
    {
      'text': 'Circulars',
      'imagePath': 'assets/newIcons/circulars.png',
    },
  ];
  final List<Map<String, dynamic>> buttonData2 = [
    {
      'text': 'Teacher Notes',
      'imagePath': 'assets/newIcons/LearningResources.png',
    },
    {
      'text': 'Attendance',
      'imagePath': 'assets/newIcons/Attendance.png',
    },
    {
      'text': 'Circulars',
      'imagePath': 'assets/finalImages/News.png',
    },
    {
      'text': 'Teacher Notes',
      'imagePath': 'assets/finalImages/Assessments.png',
    },
  ];

  final List<Color> buttonColors = [
    // ATTENDANCE BACKGROUND
    Color.fromARGB(255, 255, 234, 230).withOpacity(1.0),

    // HOLIDAY BACKGROUND
    Color.fromARGB(255, 212, 240, 255).withOpacity(1.0),

    // FEE & RECEIPT BACKGROUND
    Color.fromARGB(255, 255, 246, 212).withOpacity(1.0),

    // CIRCULAR BACKGROUND
    Color.fromARGB(255, 227, 255, 240).withOpacity(1.0),
  ];

  final List<Color> buttonColorsBorder = [
    // ATTENDANCE BACKGROUND
    Color.fromARGB(255, 250, 78, 44).withOpacity(1.0),

    // HOLIDAY BACKGROUND
    Color.fromARGB(255, 15, 171, 255).withOpacity(1.0),

    // FEE & RECEIPT BACKGROUND
    Color.fromARGB(255, 255, 200, 1).withOpacity(1.0),

    // CIRCULAR BACKGROUND
    Color.fromARGB(255, 0, 255, 119).withOpacity(1.0),
  ];

  final List<Color> buttonColors2 = [
    // ATTENDANCE BACKGROUND
    Color.fromARGB(255, 240, 239, 254).withOpacity(1.0),

    // HOLIDAY BACKGROUND
    Color.fromARGB(255, 255, 230, 255).withOpacity(1.0),

    // FEE & RECEIPT BACKGROUND
    Color.fromARGB(255, 255, 230, 236).withOpacity(1.0),

    // CIRCULAR BACKGROUND
    Color.fromARGB(255, 255, 231, 220).withOpacity(1.0),
  ];
  final List<Color> buttonColorsBorder2 = [
    // ATTENDANCE BACKGROUND
    Color.fromARGB(255, 86, 74, 255).withOpacity(1.0),

    // HOLIDAY BACKGROUND
    Color.fromARGB(255, 255, 114, 255).withOpacity(1.0),

    // FEE & RECEIPT BACKGROUND
    Color.fromARGB(255, 255, 96, 133).withOpacity(1.0),

    // CIRCULAR BACKGROUND
    Color.fromARGB(255, 255, 140, 86).withOpacity(1.0),
  ];

  final List<StaggeredTile> buttonSizes = [
    StaggeredTile.count(2, 1), // Size for the 'Home' button
    StaggeredTile.count(2, 2), // Size for the 'Learning Resources' button
    StaggeredTile.count(1, 1), // Size for the 'Homework' button
    StaggeredTile.count(1, 1), // Size for the 'Results' button
    StaggeredTile.count(2, 1), // Size for the 'Pay fee' button
    StaggeredTile.count(2, 1), // Size for the 'Assignment' button
  ];

  List<Post> apiData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAPIData();
    _scrollController.addListener(() {
      // Calculate the index based on scroll position and item width
      int newIndex = (_scrollController.offset / 50).round();

      if (newIndex != currentIndex) {
        setState(() {
          currentIndex = newIndex;
        });
      }
    });
  }

  Future<void> fetchAPIData() async {
    try {
      final apiProvider = APIProvider();

      // Retrieve the saved token
      String? savedToken = await TokenManager().getStoredAuthToken();
      // String? StudentID = await TokenManager().getStoredStudentId();
      // print("STUDENTID $StudentID");

      if (savedToken != null) {
        final response = await apiProvider.fetchTimelineData(savedToken,
            pageNumber: 1, pageSize: 30);

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data']['Data'];
          print(response.toString());
          print("Login Response uphere");

          apiData = data.map((item) {
            List<Map<String, dynamic>> attachments = [];
            List<String> students = [];
            if (item['att'] != null) {
              attachments = List<Map<String, dynamic>>.from(item['att']);
            }

            return Post(
              type: item['mod'],
              heading: item['t'],
              date: item['dt'],
              duedate: item['dt'],
              content: item['cnt'],
              st: item['st'],
              tch: item['tch'],
              studentImageUrl: '',
              attachments: attachments,
              students: students,
            );
          }).toList();

          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToHolidaysScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HolidaysScreen(),
      ),
    );
  }

  Color getColorForType(String type) {
    switch (type) {
      case 'Assessments':
        return Color.fromARGB(255, 182, 229, 255); // Yellowish color
      case 'Home-Work':
        return Color.fromARGB(255, 242, 235, 255); // Yellowish color
      case 'Circulars':
        return Color.fromARGB(255, 255, 184, 167); // Yellowish color
      // Yellowish color
      default:
        return Colors.brown; // Default brown color
    }
  }

  Color getColorForType2(String type) {
    switch (type) {
      case 'Assessments':
        return Color.fromARGB(255, 182, 229, 255); // Yellowish color
      case 'Home-Work':
        return Color.fromARGB(255, 242, 235, 255); // Yellowish color
      case 'Circulars':
        return Color.fromARGB(255, 255, 184, 167); // Yellowish color
      default:
        return Colors.brown; // Default brown color
    }
  }

  AppBar buildCustomAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Disable the back button
      toolbarHeight: 90, // Set the height of the app bar
      backgroundColor:
          Colors.transparent, // Make the app bar background transparent
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/newIcons/drawer.png',
              width: 30,
              height: 30,
            ),
            onPressed: () {},
          ),
          Image.asset(
            // 'assets/images/minerva.png',
            'assets/images/minerva.png',
            // 'assets/images/aislogo.png',
            width: 90,
            height: 90,
          ),
          IconButton(
            icon: Image.asset(
              'assets/newIcons/Message.png',
              width: 30,
              height: 30,
            ),
            onPressed: () {
              // Handle message button press
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: buildCustomAppBar(context), // Add the custom app bar
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: EdgeInsets.fromLTRB(1, 0, 1, 65),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/newbackground/Homepagehomebg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Image.asset(
                      'assets/newIcons/drawer.png',
                      width: 75,
                      height: 75,
                    ),
                  ),
                  Image.asset(
                    'assets/images/minerva.png',
                    width: 40,
                    height: 40,
                    // Adjust width and height as needed
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()),
                        // MyWebView()),
                        // Replace MailScreen() with your actual screen
                      );
                    },
                    icon: Image.asset(
                      'assets/newIcons/Message.png',
                      width: 65,
                      height: 65,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(6, 0, 6, 2),
              height: 110.0,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: buttonLabels.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HolidaysScreen(),
                                ),
                              );
                            }
                            if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeeScreen(),
                                ),
                              );
                            }
                            if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeworkScreen(),
                                ),
                              );
                            }
                            if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CircularsScreen(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 90,
                            margin: EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(0, 0, 0, 0),
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 90, 90, 90)
                                            .withOpacity(
                                                0.2), // White shadow color
                                        spreadRadius: 6, // Spread radius
                                        blurRadius: 16, // Blur radius
                                        offset: Offset(0,
                                            3), // Offset in x and y directions
                                      ),
                                    ],
                                    shape: BoxShape
                                        .circle, // Shape of the container
                                  ),
                                  child: Image.asset(
                                    buttonData[index]['imagePath'],
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                Text(
                                  buttonLabels[index],
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontWeight: FontWeight
                                        .w800, // Adjust the weight as needed
                                    fontSize: 12.0,
                                    color: Color.fromARGB(255, 59, 59, 59),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(6, 0, 6, 2),
              height: 110.0,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: buttonLabels2.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Learningresources(),
                                ),
                              );
                            }
                            if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransportScreen(),
                                ),
                              );
                            }
                            if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsScreen(),
                                ),
                              );
                            }
                            if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Assessments(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 90,
                            margin: EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromARGB(0, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(0, 255, 255, 255),
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 90, 90, 90)
                                            .withOpacity(
                                                0.2), // White shadow color
                                        spreadRadius: 6, // Spread radius
                                        blurRadius: 16, // Blur radius
                                        offset: Offset(0,
                                            3), // Offset in x and y directions
                                      ),
                                    ],
                                    shape: BoxShape
                                        .circle, // Shape of the container
                                  ),
                                  child: Image.asset(
                                    buttonData2[index]['imagePath'],
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                Text(
                                  buttonLabels2[index],
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontWeight: FontWeight
                                        .w800, // Adjust the weight as needed
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 57, 56, 56),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/newIcons/Timeline.png',
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "Timeline",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 30, 55, 124),
                              ),
                            ),
                          )
                        : SizedBox
                            .shrink(), // Use SizedBox.shrink() to take up no space when not loading
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = apiData[index];
                        return GestureDetector(
                          onTap: () {
                            if (post.type == 'Home-Work') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeworkDetailsScreen(
                                    homework: Homework(
                                      title: post.type,
                                      subtitle: post.date,
                                      content: post.content,
                                      duedate: post.duedate,
                                      st: post.st,
                                      stId: '',
                                      // teacherName: post.,

                                      hasAttachments:
                                          post.attachments != null &&
                                              post.attachments!.isNotEmpty,
                                      teacherName: '',
                                    ),
                                    attachments: post.attachments ?? [],
                                  ),
                                ),
                              );
                            } else if (post.type == 'Circulars') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CircularDetailScreen(
                                    circulars: Circulars(
                                        title: post.type,
                                        subtitle: post.date,
                                        content: post.content,
                                        releaseDate: '',
                                        stu: []),
                                    attachments: post.attachments ?? [],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 35,
                                      padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
                                      child: Center(
                                        child: SizedBox(
                                          height: 25,
                                          child: CircleAvatar(
                                            backgroundColor: getColorForType(post
                                                .type), // Set color dynamically
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          //color: getColorForType2(post.type),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              // post.type,
                                              post.type,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                                  //color: Colors.white
                                                  ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Container(
                                              height: 27,
                                              child:
                                                  // Html(
                                                  //   data: post.heading,
                                                  // ),
                                                  Text(
                                                post.heading,
                                                style: TextStyle(
                                                  fontSize: 15.5,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  post.st,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${DateFormat('dd MMMM yyyy', 'en_US').format(DateTime.parse(post.date.split('T')[0]))}', // Display the date in "30 January 2024" format
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: apiData.length,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
