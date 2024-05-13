import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/NewsDetailScreen.dart';
import 'package:minervaschool/Common/student_info_list.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
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

class NewsPost {
  final String title;
  final String subject;
  final String content;
  final List<Attachment> attachments;

  NewsPost({
    required this.title,
    required this.subject,
    required this.content,
    required this.attachments,
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

List<NewsPost> apiData = [];

class _NewsScreenState extends State<NewsScreen> {
  List<NewsPost> newsList = [];
  late String savedToken;
  String? currentStudentId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchNewsData();
  }

  Future<void> getUserData() async {
    currentStudentId = await TokenManager().getStoredStudentId();
    setState(() {});
  }

  Future<void> fetchNewsData() async {
    try {
      setState(() {
        isLoading = true;
      });

      savedToken = (await TokenManager().getStoredAuthToken())!;

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchNews(
        savedToken,
        userId: currentStudentId,
        pageNumber: 1,
        pageSize: 20,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['Content'];

        setState(() {
          newsList = data
              .map((item) => NewsPost(
                    title: item['t'],
                    subject: item['st'],
                    content: item['c'],
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
        List<int> bytes = base64.decode(studentId);
        String decodedStudentId = utf8.decode(bytes);

        currentStudentId = decodedStudentId;
      }
      print('Selected Student ID: $currentStudentId');
      fetchNewsData(); // Fetch news data when student changes
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    'News',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/newIcons/News.png',
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
                : newsList.isEmpty
                    ? Center(
                        child: Text(
                          'No new News!!',
                          style: montserratTextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                    resources: newsList[index],
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
                                        newsList[index].title ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 71, 71, 71),
                                        ),
                                      ),
                                      subtitle: Text(
                                        newsList[index].subject ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 172, 172, 172),
                                        ),
                                      ),
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
