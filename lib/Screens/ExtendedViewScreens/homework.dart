import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:minervaschool/Common/student_info_list.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/HomeworkDetailScreen.dart';

class HomeworkScreen extends StatefulWidget {
  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
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

class Homework {
  final String title;
  final String teacherName;
  final String subtitle;
  final String duedate;
  final String content;
  final String st;
  final String stId;
  final bool hasAttachments; // Added property

  Homework({
    required this.title,
    required this.teacherName,
    required this.subtitle,
    required this.duedate,
    required this.content,
    required this.st,
    required this.stId,
    required this.hasAttachments,
  });
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  List<Homework> homeworkList = [];
  List<List<Map<String, dynamic>>> attachmentsList = [];
  late String savedToken;
  String? currentStudentId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchHomeworkData();
  }

  Future<void> getUserData() async {
    String studentID = await TokenManager().getStoredStudentId() ?? '';
    setState(() {
      currentStudentId = studentID;
    });
  }

  Future<void> fetchHomeworkData() async {
    try {
      setState(() {
        isLoading = true;
      });

      String studentID = (await TokenManager().getStoredStudentId()) ?? '';
      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchhomework(
        token: savedToken,
        studentId: studentID,
        data: {
          "StudentId": 0,
        },
        pageNumber: 1,
        pageSize: 80,
      );

      print('API Response: $response');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> data = responseData['data'] ?? {};

        final List<dynamic> content = data['data'] ?? [];

        print('Content: $content');

        setState(() {
          homeworkList = content.map((item) {
            bool hasAttachments = (item['att'] ?? []).isNotEmpty;
            String formattedDueDate = item['dd'] != null
                ? DateFormat('yyyy-MM-dd').format(
                    DateTime.parse(item['dd'].toString() ?? ''),
                  )
                : '';

            return Homework(
              title: item['sub'].toString() ?? '',
              teacherName: item['tch'].toString() ?? '',
              subtitle: item['dt'].toString() ?? '',
              content: item['des'].toString() ?? '',
              duedate: formattedDueDate,
              stId: item['stId'].toString() ?? '',
              st: item['dd'].toString() ?? '',
              hasAttachments: hasAttachments,
            );
          }).toList();

          attachmentsList = content
              .map((item) => List<Map<String, dynamic>>.from(item['att'] ?? [])
                      .map((attachment) {
                    return {
                      'id': attachment['id'].toString() ?? '',
                      'filename': attachment['dn'].toString() ?? '',
                      'title': attachment['ft'].toString() ?? '',
                      'url': attachment['p'].toString() ?? '',
                      'size': attachment['fs'] ?? 0,
                    };
                  }).toList())
              .toList();

          isLoading = false;
        });

        // Print the final API result
        print('Homework List: $homeworkList');
        print('Attachments List: $attachmentsList');
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateSelectedStudentId(String? studentId) {
    setState(() {
      if (studentId != null) {
        // Decode base64 encoded string
        List<int> bytes = base64.decode(studentId);
        String decodedStudentId = utf8.decode(bytes);

        currentStudentId = decodedStudentId;
      }
      print('Selected Student ID: $currentStudentId');
    });
  }

  Widget build(BuildContext context) {
    List<Homework> filteredHomework = homeworkList.where((homework) {
      return currentStudentId != null &&
          homework.stId.contains(currentStudentId!);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            height: 100,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Homework',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/finalImages/Homework.png',
                    width: 65,
                    height: 65,
                  ),
                  SizedBox(width: 22),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          StudentInfoList(
            onStudentChanged: updateSelectedStudentId,
          ),
          Text(
            '<< Please select the students to view the data >>',
            style: montserratTextStyle(
              color: Color.fromARGB(255, 74, 74, 74),
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : filteredHomework.isEmpty
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
                    : ListView.builder(
                        itemCount: filteredHomework.length,
                        itemBuilder: (BuildContext context, int index) {
                          Homework homework = filteredHomework[
                              index]; // Use filteredHomework instead of homeworkList
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeworkDetailsScreen(
                                      homework: homework,
                                      attachments: attachmentsList[index],
                                    ),
                                  ),
                                );
                              },
                              child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    height: 80,
                                    margin: EdgeInsets.all(5.0),
                                    child: DottedBorder(
                                      color: Color.fromARGB(255, 133, 126, 255),
                                      strokeWidth: 1,
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(16),
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: Colors.white,
                                        ),
                                        child: Stack(
                                          children: [
                                            ListTile(
                                              title: Row(
                                                children: [
                                                  Text(
                                                    homework.title ?? '',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 71, 71, 71),
                                                    ),
                                                  ),
                                                  if (homework.hasAttachments)
                                                    Icon(
                                                      Icons.attach_file,
                                                      size: 20,
                                                      color: Color.fromARGB(
                                                          255, 7, 11, 139),
                                                    ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                'Due date: ${formatDueDate(homework.st)}' ??
                                                    '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Color.fromARGB(
                                                      255, 172, 172, 172),
                                                ),
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    homework.teacherName ?? '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 172, 172, 172),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    ' ${formatDueDate(homework.subtitle)}' ??
                                                        '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 172, 172, 172),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )));
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String formatDueDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    try {
      DateTime dateTime = parseDate(date);
      String formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  DateTime parseDate(String dateString) {
    try {
      final RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}');
      if (dateRegExp.hasMatch(dateString)) {
        return DateFormat('yyyy-MM-dd').parse(dateString);
      }

      final RegExp dateRegExp2 = RegExp(r'^\d{1,2}/\d{1,2}/\d{2}$');
      if (dateRegExp2.hasMatch(dateString)) {
        return DateFormat('dd/MM/yy').parse(dateString);
      }
      throw FormatException('Invalid date format: $dateString');
    } catch (e) {
      throw FormatException('Error parsing date: $e');
    }
  }
}
