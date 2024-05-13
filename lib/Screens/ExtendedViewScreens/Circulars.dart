import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/CircularDetailScreen.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../Common/student_info_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class CircularsScreen extends StatefulWidget {
  @override
  _CircularsScreenState createState() => _CircularsScreenState();
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

class Circulars {
  final String title;
  final String subtitle;
  final String content;
  final String releaseDate;
  final List<String> stu;

  Circulars({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.releaseDate,
    required this.stu,
  });
}

class _CircularsScreenState extends State<CircularsScreen> {
  List<Circulars> circularList = [];
  String? currentStudentId;

  List<List<Map<String, dynamic>>> attachmentsList = [];

  late String savedToken;
  bool isLoading = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    fetchCircularData();
  }

  Future<void> fetchCircularData() async {
    try {
      setState(() {
        isLoading = true;
      });

      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchCirculars(
        savedToken,
        userId: '',
        pageNumber: 1,
        pageSize: 20,
      );

      print('API Response: $response');

      if (response.statusCode == 200) {
        final responseData = response.data;

        print('API Response Data: $responseData');

        final contentData = responseData['data']['Content'];

        if (contentData != null) {
          final List<dynamic> circularData = List.from(contentData);

          setState(() {
            circularList = circularData
                .map((item) => Circulars(
                      title: item['t'] ?? '',
                      subtitle: item['t'] ?? '',
                      content: item['c'] ?? '',
                      releaseDate: item['dt'] ?? '',
                      stu: List<String>.from(
                          item['stu']?.toString().split(',') ?? []),
                    ))
                .toList();

            attachmentsList = circularData.map((item) {
              return List<Map<String, dynamic>>.from(item['att'] ?? [])
                  .map((attachment) {
                return {
                  'id': attachment['id'] ?? '',
                  'filename': attachment['dn'] ?? '',
                  'title': attachment['t'] ??
                      '', // Use 't' instead of 'dn' for the title
                  'url': attachment['p'] ?? '',
                  'size': attachment['s'] ?? 0,
                };
              }).toList();
            }).toList();

            isLoading = false;
          });
        } else {
          print('Response data is null');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching circular data: $e");
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

  @override
  Widget build(BuildContext context) {
    List<Circulars> displayedCirculars = currentStudentId != null
        ? circularList.where((circular) {
            return circular.stu.contains(currentStudentId);
          }).toList()
        : circularList;

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
                    'Circulars',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/newIcons/circulars.png',
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
                : displayedCirculars.isEmpty
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
                        itemCount: displayedCirculars.length,
                        itemBuilder: (BuildContext context, int index) {
                          Circulars circulars = displayedCirculars[index];

                          // Extracting attachmentsList for the current circular
                          List<Map<String, dynamic>> attachments =
                              index < attachmentsList.length
                                  ? attachmentsList[index]
                                  : [];

                          // Truncate the title if it exceeds 30 characters
                          String truncatedTitle = circulars.title.length > 30
                              ? circulars.title.substring(0, 30) + '...'
                              : circulars.title;

                          return GestureDetector(
                            onTap: () {
                              print('Index: $index');
                              print('AttachmentsList: $attachments');

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CircularDetailScreen(
                                    circulars: circulars,
                                    attachments: attachments,
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
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: [
                                        ListTile(
                                          title: Row(
                                            children: [
                                              Text(
                                                truncatedTitle,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              if (attachments.isNotEmpty)
                                                SizedBox(width: 8),
                                              if (attachments.isNotEmpty)
                                                Icon(
                                                  Icons.attach_file,
                                                  color: Color.fromARGB(
                                                      255, 7, 11, 139),
                                                  size: 20,
                                                ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            circulars.subtitle,
                                            maxLines: 20,
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
