import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';

class BusAttendance extends StatefulWidget {
  @override
  _BusAttendanceState createState() => _BusAttendanceState();
}

class Pickup {
  final String studentId;
  final String studentName;
  final String content;

  Pickup({
    required this.studentId,
    required this.studentName,
    required this.content,
  });
}

class _BusAttendanceState extends State<BusAttendance> {
  List<Map<String, dynamic>> pickupData = [];
  late String savedToken;
  bool isLoading = false;

  PageController _pageController = PageController();

  Future<void> fetchBusAttendance() async {
    try {
      setState(() {
        isLoading = true;
      });

      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';

      final apiProvider = APIProvider();
      final response = await apiProvider.fetchTransportData(savedToken,
          pageNumber: 1, pageSize: 20);

      if (response.statusCode == 200) {
        setState(() {
          pickupData = List.from(response.data['data']);
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

  List<Map<String, String>> extractAttendanceData(String htmlContent) {
    var document = parse(htmlContent);
    var attendanceData = <Map<String, String>>[];

    var rows = document.querySelectorAll('table tbody tr');
    for (var row in rows) {
      var columns = row.children;
      if (columns.length == 3) {
        var date = columns[0].text.trim();
        var pickUp = columns[1].text.trim();
        var dropOff = columns[2].text.trim();

        attendanceData.add({
          'date': date,
          'pickUp': pickUp,
          'dropOff': dropOff,
        });
      }
    }

    return attendanceData;
  }

  @override
  void initState() {
    super.initState();
    fetchBusAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Attendance', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 135, 59, 122),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pickupData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(8.0),
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 135, 59, 122)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                pickupData[index]['sname'],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pickupData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var attendanceData =
                          extractAttendanceData(pickupData[index]['content']);
                      return Container(
                        margin: EdgeInsets.all(16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pickupData[index]['sname'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (attendanceData.isNotEmpty)
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (var entry in attendanceData)
                                      ListTile(
                                        title: Text(entry['date'] ?? ''),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Pick-Up: ${entry['pickUp']}'),
                                            Text(
                                                'Drop-Off: ${entry['dropOff']}'),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Sorry, no attendance data available for ${pickupData[index]['sname']}. Please check back soon...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(
                                        255, 110, 110, 110),
                                  ),
                                ),
                              ),
                          ],
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
