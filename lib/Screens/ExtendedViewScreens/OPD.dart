import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/HomeworkDetailScreen.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:dotted_border/dotted_border.dart';

class OPDScreen extends StatefulWidget {
  @override
  _opdscreenState createState() => _opdscreenState();
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

class HealthIssue {
  String problem;
  String date;
  String admissionCondition;
  String treatment;
  HealthIssue(
      {required this.problem,
      required this.date,
      required this.admissionCondition,
      required this.treatment});
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

class _opdscreenState extends State<OPDScreen> {
  List<Homework> homeworkList = [];
  List<List<Map<String, dynamic>>> attachmentsList = [];
  late String savedToken;
  bool isLoading = false;

  final List<HealthIssue> issues = [
    HealthIssue(
      problem: 'Chest pain',
      date: '5th February, 2024',
      admissionCondition:
          'He was playing volleyball, and his right hand got swollen.',
      treatment: 'Tiger balm was applied',
    ),
    HealthIssue(
      problem: 'Headache',
      date: '5th February, 2024',
      admissionCondition:
          'He was playing volleyball, and his right hand got swollen.',
      treatment: 'Tiger balm was applied',
    ),
    HealthIssue(
      problem: 'Stomach pain',
      date: '5th February, 2024',
      admissionCondition:
          'He was playing volleyball, and his right hand got swollen.',
      treatment: 'Tiger balm was applied',
    ),
    HealthIssue(
      problem: 'Breathing issue',
      date: '5th February, 2024',
      admissionCondition:
          'He was playing volleyball, and his right hand got swollen.',
      treatment: 'Tiger balm was applied',
    ),
    HealthIssue(
      problem: 'Tonsils',
      date: '5th February, 2024',
      admissionCondition:
          'He was playing volleyball, and his right hand got swollen.',
      treatment: 'Tiger balm was applied',
    ),
  ];

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
                  image: AssetImage('assets/newbackground/OPDvisit.png'),
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
                      'OPD visits',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 16),
                    // Adjust the size of the Incident icon
                    Image.asset(
                      'assets/newIcons/Health.png',
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
            ? Center(
                child: CircularProgressIndicator(),
              )
            : homeworkList.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: montserratTextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    itemCount: issues.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 18.0), // Added space between items
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _showDetailsDialog(context, issues[index]);
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            height: 65,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(206, 255, 222, 101),
                                  Color(
                                      0xFFFFC806), // You can adjust this color according to your preference
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' ${issues[index].problem}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 22,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${issues[index].date}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ));
  }

  void _showDetailsDialog(BuildContext context, HealthIssue issue) {
    showDialog(
      context: context,
      barrierColor:
          Colors.transparent, // Set the background color to transparent
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 240,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 0, 0, 0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Color.fromARGB(255, 248, 231, 231),
                  ),
                  child: Text(
                    'Complaint: ${issue.problem}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 249, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Condition at Admission: ${issue.admissionCondition ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(16),
                    color: Color.fromARGB(255, 219, 255, 162),
                  ),
                  child: Text(
                    'Treatment: ${issue.treatment ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: Color.fromARGB(255, 178, 225, 234),
                  ),
                  child: Text(
                    issue.date,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
