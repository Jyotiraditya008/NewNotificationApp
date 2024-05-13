import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';

import 'dart:async';
import 'package:minervaschool/Screens/ExtendedViewScreens/ResultsDetailScreen.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:dotted_border/dotted_border.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
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

class ResultsPost {
  final String title;
  final String subject;
  final String content;
  final List<Attachment> attachments;

  ResultsPost({
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

List<ResultsPost> apiData = [];

class _ResultsState extends State<Results> {
  List<ResultsPost> ResultsList = [];
  late String savedToken;
  String userID = ""; // Initialize to empty string
  String studentID = ""; // Initialize to an empty string
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchResultsData(); // Fetch learning resources data when the screen is initialized
  }

  Future<void> fetchResultsData() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when starting data fetch
      });

      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchResultData(savedToken,
          pageNumber: 1, pageSize: 20);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['Result'];
        print('RESULT RESPONSE DATA $data');

        setState(() {
          ResultsList = data
              .map((item) => ResultsPost(
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

          isLoading = false; // Set loading to false when data fetch is complete
        });
      }
    } catch (e) {
      // Handle errors or exceptions here
      print(e.toString());
      setState(() {
        isLoading = false;
      }); // Set loading to false on error
    }
  }

  @override
  Widget build(BuildContext context) {
    print('UserID: $userID, StudentID: $studentID');

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              height: 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/newbackground/homeworkBackground.png'),
                  fit: BoxFit.cover,
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
                    SizedBox(width: 16),
                    Text(
                      'Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(),
                    Image.asset(
                      'assets/newIcons/Result.png',
                      width: 65,
                      height: 65,
                    ),
                    SizedBox(width: 22),
                  ],
                ),
              ),
            ),
          )),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ResultsList.isEmpty
              ? Center(
                  child: Text(
                    'No Results available yet!!',
                    style: montserratTextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: ResultsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to ResultsDetailScreen when a tile is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsDetailScreen(
                              resources: ResultsList[index],
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
                              child: Stack(
                                children: [
                                  ListTile(
                                    title: Text(
                                      ResultsList[index].title ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                            255, 71, 71, 71),
                                      ),
                                    ),
                                    subtitle: Text(
                                      ResultsList[index].subject ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(255, 172, 172, 172),
                                      ),
                                    ),
                                  ),
                                  // No attachments icon for this list
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
