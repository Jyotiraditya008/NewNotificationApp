import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../Common/student_info_list.dart';
import '../../calender/custom_calender.dart';
import '../../calender/date_time_in_utils.dart';

class MyAttendanceScreen extends StatefulWidget {
  const MyAttendanceScreen({super.key});

  @override
  State<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> {
  late DateTime selectedMonth;
  DateTime? selectedDate;
  final List<CalenderList> daysList = [
    const CalenderList(date: "2024-03-22 11:02:22"),
    const CalenderList(date: "2024-03-11 11:02:22"),
    const CalenderList(date: "2024-03-29 11:02:22"),
    const CalenderList(date: "2024-03-10 11:02:22"),
  ];
  final List<String> monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  var isMonthSelected = 1;
  String? currentStudentId;

  @override
  void initState() {
    selectedMonth = DateTime.now().monthStart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF974889),
        title: const Text(
          'Attendance',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StudentInfoList(
              onStudentChanged: (studentId) {
                setState(() {
                  currentStudentId = studentId;
                });
              },
            ),
            Container(
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: monthList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isMonthSelected = index;
                        selectedMonth = DateTime(2024, index);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: isMonthSelected == index
                              ? Colors.green.shade400
                              : Colors.white12,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 0),
                            child: Text(
                              monthList[index],
                              style: TextStyle(
                                color: isMonthSelected == index
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /** Calender view*/
            Container(
              width: MediaQuery.of(context).size.width,
              child: CalenderView(
                selectedDate: selectedDate,
                selectedMonth: selectedMonth,
                daysList: daysList,
                selectDate: (value) {
                  setState(() {
                    selectedDate = value;
                  });
                },
                onChange: (value) => setState(() => selectedMonth = value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 30,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Present"),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 30,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Absent"),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 15,
                    width: 30,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Holiday"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
