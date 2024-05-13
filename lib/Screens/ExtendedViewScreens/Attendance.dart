import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:html/parser.dart' as htmlParser;

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class Attendance {
  final String studentName;
  final Map<DateTime, String> attendanceRecords;

  Attendance({
    required this.studentName,
    required this.attendanceRecords,
  });
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Attendance> attendanceList = [];
  late String savedToken;
  bool isLoading = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _selectedStudent;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      setState(() {
        isLoading = true;
      });

      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';
      final apiProvider = APIProvider();

      final Response response = await apiProvider.fetchAttendance(savedToken);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        attendanceList = []; // Clear existing data

        for (var item in data) {
          var htmlContent = item['month']['content'];
          print('HTML Content: $htmlContent');

          var document = htmlParser.parse(htmlContent);
          var dateElements = document.querySelectorAll('span');

          var attendanceRecords = <DateTime, String>{};

          for (var dateElement in dateElements) {
            var dateString = dateElement.text.trim();
            var status =
                determineAttendanceStatus(dateElement.attributes['style']);

            print('Date: $dateString');
            print('Status: $status');

            if (dateString.isNotEmpty) {
              var dayNumber = int.tryParse(dateString);
              if (dayNumber != null) {
                var year = DateTime.now().year;
                var month = DateTime.now().month;
                var formattedDateString =
                    '$year-$month-${dayNumber.toString().padLeft(2, '0')}';

                try {
                  var date = DateTime.parse(formattedDateString);
                  attendanceRecords[date] = status;
                } catch (e) {
                  print('Parsing Error: $e');
                }
              }
            }
          }

          print('Attendance Records: $attendanceRecords');
          print('----------------------------------------');

          var attendance = Attendance(
            studentName: item['sname'],
            attendanceRecords: attendanceRecords,
          );
          attendanceList.add(attendance);
        }

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String determineAttendanceStatus(String? style) {
    if (style == null || style.isEmpty) {
      return 'Unknown';
    }

    var colorMatch = RegExp(r'#([0-9a-fA-F]{6})').firstMatch(style);
    var backgroundColor = colorMatch?.group(0) ?? '';

    switch (backgroundColor) {
      case '#43B581':
        return 'Present';
      case '#b66303':
        return 'Ex Tardy';
      case '#0099FF':
        return 'Early Out';
      case '#FFB':
        return 'Holidays';
      case '#CCC':
        return 'Weekends';
      default:
        return 'No data';
    }
  }

  List<Object?> getEventColors(DateTime date) {
    var color = getSingleEventColor(date);
    // Return a list with the color if it is not null, otherwise return an empty list
    return color != null ? [color] : [];
  }

  Color? getSingleEventColor(DateTime date) {
    for (var attendance in attendanceList) {
      if (_selectedStudent == attendance.studentName) {
        var status = attendance.attendanceRecords[date];
        if (status != null) {
          // Return the corresponding color based on the status
          switch (status) {
            case 'Present':
              return Colors.green; // Adjust colors as needed
            case 'Absent':
              return Colors.red;
            case 'Leave':
              return Colors.orange;
            case 'Holiday':
              return Colors.blue;
            default:
              return Colors.grey;
          }
        }
      }
    }
    return null; // Return null if no status is found
  }

  @override
  Widget build(BuildContext context) {
    print('Attendance List Length: ${attendanceList.length}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Attendance', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : attendanceList.isEmpty
              ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attendanceList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Attendance attendance = attendanceList[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedStudent = attendance.studentName;
                                print('Selected Student: $_selectedStudent');
                              });
                            },
                            child: Card(
                              color: _selectedStudent == attendance.studentName
                                  ? Colors.teal
                                  : Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  attendance.studentName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    TableCalendar(
                      firstDay: DateTime.utc(2023, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      eventLoader: getEventColors,
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isNotEmpty && events.first is Color) {
                            return Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: events.first as Color,
                              ),
                            );
                          } else {
                            return null;
                          }
                        },
                        // selectedBuilder: (context, date, events) {
                        //   if (events.isNotEmpty && events.first is Color) {
                        //     return Container(
                        //       margin: const EdgeInsets.all(4.0),
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: events.first as Color,
                        //       ),
                        //       child: Text(
                        //         '${date.day}',
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     );
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: attendanceList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Attendance attendance = attendanceList[index];
                          if (_selectedStudent == attendance.studentName) {
                            return ExpansionTile(
                              title: Text(attendance.studentName),
                              initiallyExpanded:
                                  _selectedStudent == attendance.studentName,
                              children: [
                                for (var entry
                                    in attendance.attendanceRecords.entries)
                                  if (isSameDay(entry.key, _selectedDay))
                                    ListTile(
                                      title: Text(DateFormat('yyyy-MM-dd')
                                          .format(entry.key)),
                                      trailing: Text(entry.value),
                                    ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
