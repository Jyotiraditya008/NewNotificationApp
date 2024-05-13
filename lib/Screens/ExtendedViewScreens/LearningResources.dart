import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:minervaschool/Common/student_info_list.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/LearningResourcesDetailScreen.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';

class Learningresources extends StatefulWidget {
  @override
  _LearningresourcesState createState() => _LearningresourcesState();
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

class LearningResourcesPost {
  final String title;
  final String subject;
  final String content;
  final List<Attachment> attachments;
  final List<String> stu;

  LearningResourcesPost({
    required this.title,
    required this.subject,
    required this.content,
    required this.attachments,
    required this.stu,
  });
}

class Attachment {
  final String displayName;
  final String url;

  Attachment({
    required this.displayName,
    required this.url,
  });
}

class _LearningresourcesState extends State<Learningresources> {
  List<LearningResourcesPost> learningResourcesList = [];
  List<List<Map<String, dynamic>>> attachmentsList = [];
  String? currentStudentId;

  late String savedToken;
  String userID = "";
  String studentID = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchLearningResourcesData();
  }

  Future<void> getUserData() async {
    userID = await TokenManager().getStoredUserId() ?? "";
    studentID = await TokenManager().getStoredStudentId() ?? "";
    print("Value of userID $userID");
    print("Value of studentID $studentID");
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchLearningResourcesData() async {
    try {
      setState(() {
        isLoading = true;
      });

      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';
      userID = (await TokenManager().getStoredUserId()) ?? '';
      studentID = (await TokenManager().getStoredStudentId()) ?? '';

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchLearningResources(
        savedToken,
        userId: userID,
        studentId: "0", // Hardcoded to "0", update as needed
        pageNumber: 1,
        pageSize: 20,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['Content'];

        setState(() {
          learningResourcesList = data
              .map((item) => LearningResourcesPost(
                    title: item['t'],
                    subject: item['st'],
                    content: item['c'],
                    stu: List<String>.from(item['stu'] ?? []),
                    attachments: (item['att'] as List<dynamic>)
                        .map((attachment) => Attachment(
                              displayName: attachment['dn'],
                              url: attachment['p'],
                            ))
                        .toList(),
                  ))
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
    print('UserID: $userID, StudentID: $studentID');
    List<LearningResourcesPost> filteredLearningResources =
        learningResourcesList.where((resource) {
      // Ensure currentStudentId is a String
      String currentId = currentStudentId ??
          ""; // Provide a default value if currentStudentId is null
      return resource.stu.contains(currentId);
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
            height: 110,
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
                    'Learning Resources',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/newIcons/LearningResources.png',
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
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : filteredLearningResources.isEmpty
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
                        itemCount: filteredLearningResources.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LearningResourceDetailSrceen(
                                    resources: learningResourcesList[index],
                                  ),
                                ),
                              );
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                margin: EdgeInsets.all(8.0),
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
                                    child: ListTile(
                                      title: Text(
                                        filteredLearningResources[index]
                                                .title ??
                                            '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 71, 71, 71),
                                        ),
                                      ),
                                      subtitle: Text(
                                        filteredLearningResources[index]
                                                .subject ??
                                            '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 172, 172, 172),
                                        ),
                                      ),
                                      // No attachments icon for this list
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
}
