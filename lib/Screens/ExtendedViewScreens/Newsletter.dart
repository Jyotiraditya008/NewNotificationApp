import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/NewsletterDetailScreen.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:dotted_border/dotted_border.dart';

class NewsletterScreen extends StatefulWidget {
  @override
  _NewsletterState createState() => _NewsletterState();
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

class NewsletterPost {
  final String title;
  final String subject;
  final String content;
  final List<Attachment> attachments;

  NewsletterPost({
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

List<NewsletterPost> apiData = [];

class _NewsletterState extends State<NewsletterScreen> {
  List<NewsletterPost> NewsletterList = [];
  late String savedToken;
  String userID = ""; // Initialize to an empty string
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchNewsletterData(); // Fetch learning resources data when the screen is initialized
  }

  Future<void> getUserData() async {
    // Fetch user data from the token_provider.dart file
    userID = await TokenManager().getStoredUserId() ?? "";
    print("Value of userID $userID");
    // Ensure that the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        // Update the state with the fetched user data
      });
    }
  }

  Future<void> fetchNewsletterData() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when starting data fetch
      });

      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';
      userID = (await TokenManager().getStoredUserId()) ?? '';

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchNewsletter(savedToken,
          userId: userID, pageNumber: 1, pageSize: 20);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['Content'];

        setState(() {
          NewsletterList = data
              .map((item) => NewsletterPost(
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
                      'Newsletter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(),
                    Image.asset(
                      'assets/newIcons/NewsLetter.png',
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
          : NewsletterList.isEmpty
              ? Center(
                  child: Text(
                    'No Newsletter!!',
                    style: montserratTextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: NewsletterList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to NewsletterDetailScreen when a tile is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsletterDetailScreen(
                              resources: NewsletterList[index],
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
                                      NewsletterList[index].title ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                            255, 71, 71, 71),
                                      ),
                                    ),
                                    subtitle: Text(
                                      NewsletterList[index].subject ?? '',
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
