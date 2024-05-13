import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:minervaschool/Common/common_notifications.dart';
import 'package:minervaschool/widgets/FrontOfficeWidget.dart';

class EssentialScreen extends StatefulWidget {
  const EssentialScreen({super.key});

  @override
  State<EssentialScreen> createState() => _EssentialScreenState();
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

class _EssentialScreenState extends State<EssentialScreen> {
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
    // {
    //   'text': 'Mails',
    //   'imagePath': 'assets/finalImages/Mail.png',
    // },
    // {
    //   'text': 'Newsletter',
    //   'imagePath': 'assets/finalImages/NewsLetter.png',
    // },
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(1, 0, 1, 65),
            constraints: BoxConstraints.expand(
              height: 900,
              width: double.infinity,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/newbackground/Homepagehomebg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 75,
                padding: EdgeInsets.fromLTRB(9, 12, 9, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(198, 255, 255, 255),
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
                            icon: Icon(Icons.arrow_back_ios_new_outlined,
                                color: Color.fromARGB(255, 1, 35, 73)),
                            onPressed: () {},
                          ),
                          Text(
                            "Essentials",
                            style: TextStyle(
                              color: Color.fromARGB(255, 1, 35, 73),
                              fontSize: 27.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.78,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(67, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                        ),
                        child: _currentWidget,
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
