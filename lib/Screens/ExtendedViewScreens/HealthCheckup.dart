import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/HomeworkDetailScreen.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:dotted_border/dotted_border.dart';

class HealthCheckupScreen extends StatefulWidget {
  @override
  _HealthCheckupScreenState createState() => _HealthCheckupScreenState();
}

TextStyle montserratTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return TextStyle(
    fontFamily: 'Montserrat',
    fontSize: fontSize ?? 19.0,
    fontWeight: fontWeight ?? FontWeight.bold,
    color: color ?? Colors.black,
  );
}

class Homework {
  final String title;
  final String subtitle;
  final String content;
  final String st;
  final bool hasAttachments;

  Homework({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.st,
    required this.hasAttachments,
  });
}

class _HealthCheckupScreenState extends State<HealthCheckupScreen> {
  List<Homework> homeworkList = [];
  List<List<Map<String, dynamic>>> attachmentsList = [];
  late String savedToken;
  bool isLoading = false;

  Future<void> fetchHomeworkData() async {
    try {
      setState(() {
        isLoading = true;
      });

      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchTimelineData(savedToken,
          pageNumber: 1, pageSize: 20);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['Data'];

        final List<dynamic> homeworkData =
            data.where((item) => item['mod'] == 'Home-Work').toList();

        setState(() {
          homeworkList = homeworkData.map((item) {
            bool hasAttachments = (item['att'] ?? []).isNotEmpty;

            return Homework(
              title: item['mod'],
              subtitle: item['t'],
              content: item['cnt'],
              st: item['st'],
              hasAttachments: hasAttachments,
            );
          }).toList();

          attachmentsList = homeworkData
              .map((item) => List<Map<String, dynamic>>.from(item['att'] ?? [])
                      .map((attachment) {
                    return {
                      'id': attachment['id'],
                      'filename': attachment['dn'] ?? '',
                      'title': attachment['t'] ?? '',
                      'url': attachment['p'] ?? '',
                      'size': attachment['s'] ?? 0,
                    };
                  }).toList())
              .toList();

          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHomeworkData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              height: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/newbackground/homeworkBackground.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 4),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Health Check-up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 5),
                    // Adjust the size of the Incident icon
                    Image.asset(
                      'assets/newIcons/HealthCheckup.png',
                      width: 150, // Adjust the width as needed
                      height: 150, // Adjust the height as needed
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Set the height to cover the full screen

                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 2),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          'assets/finalImages/Height&Weight.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 255, 247, 221),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Height',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 253, 198, 0),
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '133 cm',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 253, 198, 0),
                                      fontSize: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFEDFAF3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Weight',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 1, 193, 11),
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '38 kg',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 1, 193, 11),
                                      fontSize: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromARGB(255, 225, 223, 255),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'BMI (body mass index)',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 50, 53, 141),
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '40.85',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 50, 53, 141),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      BMIIndicator(bmiValue: 20.85),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Healthy',
                          style: TextStyle(
                            color: Color.fromARGB(255, 104, 197, 67),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class BMIIndicator extends StatelessWidget {
  final double bmiValue;

  const BMIIndicator({Key? key, required this.bmiValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10,
      margin: EdgeInsets.all(20),
      child: CustomPaint(
        painter: _BMIIndicatorPainter(bmiValue),
      ),
    );
  }
}

class _BMIIndicatorPainter extends CustomPainter {
  final double bmiValue;

  _BMIIndicatorPainter(this.bmiValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[300] ??
          Colors.grey // Fallback to default grey if grey[300] is null
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);

    paint.color = _getBMIColor(bmiValue);

    double bmiPosition =
        (bmiValue - 10) / (40 - 10); // Assuming BMI scale from 10 to 40
    bmiPosition = (bmiPosition < 0)
        ? 0
        : (bmiPosition > 1)
            ? 1
            : bmiPosition;

    canvas.drawRect(
        Offset(bmiPosition * size.width - 5, 0) & Size(10, size.height), paint);
  }

  @override
  bool shouldRepaint(_BMIIndicatorPainter oldDelegate) => false;

  Color _getBMIColor(double bmi) {
    if (bmi >= 18.5 && bmi <= 25) {
      return Colors.green;
    } else if (bmi < 18.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
