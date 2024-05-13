import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/HomeworkDetailScreen.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:dotted_border/dotted_border.dart';

class IncidentScreen extends StatefulWidget {
  @override
  _IncidentScreenState createState() => _IncidentScreenState();
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

class _IncidentScreenState extends State<IncidentScreen> {
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
        preferredSize: Size.fromHeight(70),
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
                    AssetImage('assets/newbackground/IncidentBackground.png'),
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
                    'Incident',
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
                    'assets/newIcons/Incident.png',
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
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  itemCount: 10,
                  // itemCount: homeworkList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 20.0), // Added space between items
                  itemBuilder: (BuildContext context, int index) {
                    // Homework homework = homeworkList[index];
                    String description =
                        'Being Careless about school work not showing responsibility, Misbehaving with teacher and using abusive language, Being Careless about school work not showing responsibility';
                    List<String> points = description.split(', ');

                    return GestureDetector(
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                            bottom: 5.0, // Added bottom margin
                          ),
                          child: DottedBorder(
                            color: Color.fromARGB(255, 255, 255, 255),
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(16),
                            padding: EdgeInsets.all(0), // Set padding to 0
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 45, // Fixed height for title
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      color: Color.fromARGB(255, 248, 231, 231),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'MATH',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(255, 249, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...points.map(
                                    (point) => ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 12,
                                      ),
                                      leading: Icon(
                                        Icons.star_border_rounded,
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                      title: Text(
                                        point,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 45, // Fixed height for date
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                      color: Color.fromARGB(255, 178, 225, 234),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '27 November 2023 Tuesday ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
