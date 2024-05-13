import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Circulars.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Events.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/News.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Newsletter.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/TeacherNotes.dart';

class FrontOfficeWidget extends StatelessWidget {
  final List<Map<String, dynamic>> buttonData = [
    {
      'text': 'Circulars',
      'imagePath': 'assets/newIcons/circulars.png',
    },
    {
      'text': 'News',
      'imagePath': 'assets/finalImages/News.png',
    },
    {
      'text': 'Teacher Notes',
      'imagePath': 'assets/finalImages/TeacherNotes.png',
    },
    {
      'text': 'Events',
      'imagePath': 'assets/newIcons/Events.png',
    },
    {
      'text': 'Newsletter',
      'imagePath': 'assets/newIcons/NewsLetter.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return // Adjusted spacing
        Material(
      elevation: 49, // Adjust the elevation as needed
      borderRadius:
          BorderRadius.circular(44.0), // Apply border radius to Material widget
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(44.0),
        ),
        padding: EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: _calculateCrossAxisCount(context),
          mainAxisSpacing: _calculateMainAxisSpacing(context),
          crossAxisSpacing: _calculateCrossAxisSpacing(context),
          shrinkWrap: true,
          children: List.generate(buttonData.length, (index) {
            return DottedBorder(
              color: Color.fromARGB(255, 255, 255, 255),
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: Radius.circular(16),
              padding: EdgeInsets.all(4),
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                  print('Button $index pressed');

                  // Check the button text and redirect accordingly
                  if (buttonData[index]['text'] == 'Circulars') {
                    // Redirect to Circulars screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CircularsScreen(),
                      ),
                    );
                  } else if (buttonData[index]['text'] == 'News') {
                    // Redirect to News screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsScreen(),
                      ),
                    );
                  } else if (buttonData[index]['text'] == 'Teacher Notes') {
                    // Redirect to Teacher Notes screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherNotes(),
                      ),
                    );
                  } else if (buttonData[index]['text'] == 'Events') {
                    // Redirect to Events screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventsScreen(),
                      ),
                    );
                  } else if (buttonData[index]['text'] == 'Newsletter') {
                    // Redirect to Newsletter screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsletterScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  elevation: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3), // Shadow color
                            spreadRadius: 0.2, // Spread radius
                            blurRadius: 12, // Blur radius
                            offset:
                                Offset(0, 3), // Offset in x and y directions
                          ),
                        ],
                        shape: BoxShape.circle, // Shape of the container
                      ),
                      child: Image.asset(
                        buttonData[index]['imagePath'],
                        width: _calculateImageWidth(context),
                        height: _calculateImageHeight(context),
                      ),
                    ),
                    SizedBox(height: 15), // Adjusted spacing
                    Text(
                      buttonData[index]['text'],
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight:
                            FontWeight.w700, // Adjust the weight as needed
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 86, 86, 86),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 3 : 2;
  }

  double _calculateMainAxisSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 32.0 : 20.0;
  }

  double _calculateCrossAxisSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 40.0 : 40.0;
  }

  double _calculateImageWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 85.0 : 110.0;
  }

  double _calculateImageHeight(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 85.0 : 95.0;
  }

  double _calculateFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 18.0 : 16.0;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Custom Widget'),
      ),
      body: FrontOfficeWidget(),
    ),
  ));
}
