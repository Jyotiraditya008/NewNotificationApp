import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:collection/collection.dart';

class HolidaysScreen extends StatefulWidget {
  @override
  _HolidaysScreenState createState() => _HolidaysScreenState();
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

class Holiday {
  final String title;
  final DateTime start;
  final DateTime end;
  final int duration;
  final String classInfo;

  Holiday({
    required this.title,
    required this.start,
    required this.end,
    required this.duration,
    required this.classInfo,
  });
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late String savedToken;
  Map<DateTime, List<Holiday>> _holidays = {};

  Future<void> fetchHolidays() async {
    try {
      savedToken = (await TokenManager().getStoredAuthToken()) ?? '';
      final apiProvider = APIProvider();

      // Replace the following line with your actual API call
      final response = await apiProvider.fetchUpcomingHolidays(savedToken,
          pageNumber: 1, pageSize: 20);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final holidays = data.map((item) {
          return Holiday(
            title: item['t'],
            start: DateTime.parse(item['b']),
            end: DateTime.parse(item['e']),
            duration: item['d'],
            classInfo: item['c'],
          );
        }).toList();

        for (var holiday in holidays) {
          // Check if the title is not already present for any date
          {
            // Check if the title is not already present for any date
            var isDuplicate = false;
            _holidays.forEach((date, dateHolidays) {
              if (dateHolidays
                  .any((existing) => existing.title == holiday.title)) {
                isDuplicate = true;
              }
            });

            if (!isDuplicate) {
              for (int i = 0; i < holiday.duration; i++) {
                final date = holiday.start.add(Duration(days: i));
                _holidays[date] = _holidays[date] ?? [];
                _holidays[date]!.add(holiday);
              }
            }
          }
        }

        setState(() {});
      } else {
        // Handle API error
      }
    } catch (e) {
      // Handle other errors or exceptions
    }
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    // Initialize holidays map (remove the test data)
    _holidays = {};
    fetchHolidays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Holidays',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color((0xFFFF8A65)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
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
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.red),
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color((0xFFFF8A65)),
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final markers = <Widget>[];

                  final isHoliday = _holidays.entries.any((entry) {
                    final holiday = entry.value.first;
                    return date.isAfter(
                            holiday.start.subtract(Duration(days: 0))) &&
                        date.isBefore(holiday.end.add(Duration(days: 1)));
                  });

                  if (isHoliday) {
                    markers.add(_buildHolidaysMarker(date));
                  }

                  return markers.isEmpty ? null : Row(children: markers);
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _buildStaticListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidaysMarker(DateTime date) {
    final uniqueHolidays = _holidays[date]?.fold<Set<String>>(
      <String>{},
      (acc, holiday) => acc..add(holiday.title),
    );

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      width: 8,
      height: 8,
      child: Text(uniqueHolidays?.first ?? ''),
    );
  }

  Widget _buildStaticListView() {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Upcoming Holidays',
                style: montserratTextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_holidays.isNotEmpty)
              ..._holidays.entries.map((entry) {
                final holiday = entry.value.first;
                return ListTile(
                  title: Text(holiday.title),
                  subtitle: Text(
                    '${holiday.start.day}-${holiday.start.month}-${holiday.start.year} to ${holiday.end.day}-${holiday.end.month}-${holiday.end.year}',
                  ),
                );
              })
            else
              Center(
                child: Text(
                  'No upcoming holidays',
                  style: montserratTextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
