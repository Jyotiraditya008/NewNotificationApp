import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class Attendance extends StatelessWidget {
  final List<Map<String, dynamic>> buttonData = [
    {
      'text': 'December',
      'imagePath': 'assets/newIcons/Attendance_Month.png',
    },
    {
      'text': 'November',
      'imagePath': 'assets/newIcons/Attendance_Month.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth > 600 ? 44.0 : 40.0),
              topRight: Radius.circular(screenWidth > 600 ? 44.0 : 40.0),
            ),
          ),
          padding: EdgeInsets.all(screenWidth > 600 ? 20.0 : 10.0),
          child: GridView.count(
            crossAxisCount: _calculateCrossAxisCount(screenWidth),
            mainAxisSpacing: _calculateMainAxisSpacing(screenWidth),
            crossAxisSpacing: _calculateCrossAxisSpacing(screenWidth),
            shrinkWrap: true,
            children: List.generate(buttonData.length, (index) {
              return DottedBorder(
                color: Color.fromARGB(255, 133, 126, 255),
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: Radius.circular(screenWidth > 600 ? 16 : 8),
                padding: EdgeInsets.all(screenWidth > 600 ? 4 : 2),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    print('Button $index pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        buttonData[index]['imagePath'],
                        width: _calculateImageWidth(screenWidth),
                        height: _calculateImageHeight(screenWidth),
                      ),
                      SizedBox(height: screenWidth > 600 ? 15 : 8),
                      Text(
                        buttonData[index]['text'],
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: _calculateFontSize(screenWidth),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      screenWidth > 600 ? screenHeight / 16 : screenWidth / 10),
                  topRight: Radius.circular(
                      screenWidth > 600 ? screenHeight / 16 : screenWidth / 10),
                  bottomLeft: Radius.circular(
                      screenWidth > 600 ? screenHeight / 16 : screenWidth / 10),
                  bottomRight: Radius.circular(
                      screenWidth > 600 ? screenHeight / 16 : screenWidth / 10),
                ),
              ),
              child: Center(
                child: Text(
                  'No data...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _calculateFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    return (screenWidth > 600) ? 3 : 2;
  }

  double _calculateMainAxisSpacing(double screenWidth) {
    return (screenWidth > 600) ? 32.0 : 30.0;
  }

  double _calculateCrossAxisSpacing(double screenWidth) {
    return (screenWidth > 600) ? 40.0 : 40.0;
  }

  double _calculateImageWidth(double screenWidth) {
    return (screenWidth > 600) ? 85.0 : 110.0;
  }

  double _calculateImageHeight(double screenWidth) {
    return (screenWidth > 600) ? 85.0 : 85.0;
  }

  double _calculateFontSize(double screenWidth) {
    return (screenWidth > 600) ? 18.0 : 16.0;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Custom Widget'),
      ),
      body: Attendance(),
    ),
  ));
}
