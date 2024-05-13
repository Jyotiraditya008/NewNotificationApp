import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../Common/student_info_list.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class PhysicalStateScreen extends StatefulWidget {
  const PhysicalStateScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalStateScreen> createState() => _PhysicalStateScreenState();
}

class _PhysicalStateScreenState extends State<PhysicalStateScreen> {
  String? currentStudentId;
  List<dynamic> physicalStats = [];

  @override
  void initState() {
    super.initState();
    fetchPhysicalStats(); // Fetch physical stats when widget initializes
  }

  static const SizedBox verticalSpace = SizedBox(
    height: 2,
  );

  Future<void> fetchPhysicalStats() async {
    try {
      final apiProvider = APIProvider();
      String? savedToken = await TokenManager().getStoredAuthToken();

      final response = await apiProvider.fetchPhysicalStats(token: savedToken);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          setState(() {
            physicalStats = responseData['data'];
            if (currentStudentId == null) {
              // Set currentStudentId to the stId of the first student if it's not already set
              currentStudentId =
                  physicalStats.isNotEmpty ? physicalStats.first['stId'] : null;
            }
          });
        } else {
          print('Invalid response format');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching characterTraits: $error');
    }
  }

  void updateSelectedStudentId(String? studentId) {
    setState(() {
      // If the studentId parameter is not null, update currentStudentId with it
      if (studentId != null) {
        currentStudentId = studentId;
      }
      print('Selected Student ID in Physical_State_Screen: $currentStudentId');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter physicalStats based on currentStudentId
    List<dynamic> filteredStats = physicalStats
        .where((stat) => stat['stId'] == currentStudentId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        // Your app bar code
        title: const Text(
          'Physical Stats',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          StudentInfoList(
            onStudentChanged: updateSelectedStudentId,
          ),
          Text(
            '<< Please select the students to view the data >>',
            // style: montserratTextStyle(
            //   color: Color.fromARGB(255, 74, 74, 74),
            //   fontSize: 11.0,
            //   fontWeight: FontWeight.bold,
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              // Your container code
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(const Radius.circular(5))),
              child: Column(
                children: [
                  Container(
                    // Your container code
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Physique',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            filteredStats.isNotEmpty &&
                                    filteredStats.first != null &&
                                    filteredStats.first['data'] != null &&
                                    filteredStats.first['data'].isNotEmpty &&
                                    filteredStats.first['data'][0]
                                            ['physique'] !=
                                        null &&
                                    filteredStats.first['data'][0]['physique']
                                        .isNotEmpty &&
                                    filteredStats.first['data'][0]['physique']
                                            [0]['examdate'] !=
                                        null
                                ? _getFormattedDate(filteredStats.first['data']
                                    [0]['physique'][0]['examdate'])
                                : 'Date not available',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (filteredStats.isNotEmpty)
                    Column(
                      children: [
                        for (var stat in filteredStats)
                          Column(
                            children: [
                              Container(
                                // Your container code
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Height',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        stat['data'][0]['physique'][0]
                                            ['height'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              verticalSpace,
                              Container(
                                // Your container code
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Weight',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        stat['data'][0]['physique'][0]
                                            ['weight'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              verticalSpace,
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'BMI',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  8), // Add some spacing between the text and HTML content
                                          Text(
                                            stat['data'][0]['physique'][0]
                                                ['bmi'], // Display BMI value
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  8), // Add some spacing between the text and HTML content
                                          // Show HTML content
                                          Container(
                                            width:
                                                200, // Set a fixed width here
                                            child: Html(
                                              data: stat['data'][0]['physique']
                                                  [0]['bmiHtml'],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                      ],
                    ),
                  if (filteredStats.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No physical stats available for the selected student',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

// class ColorPicker extends StatefulWidget {
//   final double width;
//   final double seekValue;
//   final Function(double) onPositionChanged;

//   const ColorPicker(
//       {super.key,
//       required this.width,
//       required this.onPositionChanged,
//       required this.seekValue});

//   @override
//   _ColorPickerState createState() => _ColorPickerState();
// }

// class _ColorPickerState extends State<ColorPicker> {
//   final List<Color> _colors = [
//     Colors.blue,
//     Colors.green,
//     Colors.yellow,
//     Colors.red,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     /** set value */
//     double circleLeftPosition = (widget.seekValue / 100) * widget.width - 20;

//     return Column(
//       children: <Widget>[
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               width: widget.width,
//               height: 15,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 2, color: Colors.grey.shade50),
//                 borderRadius: BorderRadius.circular(15),
//                 gradient: LinearGradient(colors: _colors),
//               ),
//             ),
//             Positioned(
//               left: circleLeftPosition,
//               child: Container(
//                 width: 16, // Diameter of the circle
//                 height: 16,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   border: Border.all(width: 2, color: Colors.black),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
