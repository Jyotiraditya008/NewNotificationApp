import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/HealthCheckup.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/OPD.dart';

class health extends StatelessWidget {
  final List<Map<String, dynamic>> buttonData = [
    {
      'text': 'OPD',
      'imagePath': 'assets/newIcons/OPD.png',
    },
    {
      'text': 'Vaccine',
      'imagePath': 'assets/newIcons/Vaccine.png',
    },
    {
      'text': 'Health issues',
      'imagePath': 'assets/newIcons/HealthIssues.png',
    },
    {
      'text': 'Health checkup',
      'imagePath': 'assets/newIcons/HealthCheckup.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: _calculateBorderRadius(context),
          ),
          padding: EdgeInsets.all(_calculatePadding(context)),
          child: GridView.count(
            crossAxisCount: _calculateCrossAxisCount(context),
            mainAxisSpacing: _calculateMainAxisSpacing(context),
            crossAxisSpacing: _calculateCrossAxisSpacing(context),
            shrinkWrap: true,
            children: List.generate(buttonData.length, (index) {
              return DottedBorder(
                color: Color.fromARGB(255, 133, 126, 255),
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: Radius.circular(_calculateRadius(context)),
                padding: EdgeInsets.all(_calculatePadding(context)),
                child: ElevatedButton(
                  onPressed: () {
                    if (buttonData[index]['text'] == 'Health checkup') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthCheckupScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OPDScreen(),
                        ),
                      );
                      print('Button $index pressed');
                    }
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
                        width: _calculateImageWidth(context),
                        height: _calculateImageHeight(context),
                      ),
                      SizedBox(height: _calculateSpacing(context)),
                      Text(
                        buttonData[index]['text'],
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: _calculateFontSize(context),
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
                borderRadius: _calculateBorderRadius(context),
              ),
              child: Center(
                child: Text(
                  'No data...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _calculateFontSize(context),
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

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 3 : 2;
  }

  double _calculateMainAxisSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 32.0 : 30.0;
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

  double _calculateSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 15 : 8;
  }

  double _calculateRadius(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 16 : 8;
  }

  double _calculatePadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 600) ? 20.0 : 10.0;
  }

  BorderRadius _calculateBorderRadius(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double radiusValue = (screenWidth > 600) ? 44.0 : 40.0;

    return BorderRadius.only(
      topLeft: Radius.circular(radiusValue),
      topRight: Radius.circular(radiusValue),
      bottomLeft: Radius.circular(radiusValue),
      bottomRight: Radius.circular(radiusValue),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Custom Widget'),
      ),
      body: health(),
    ),
  ));
}
