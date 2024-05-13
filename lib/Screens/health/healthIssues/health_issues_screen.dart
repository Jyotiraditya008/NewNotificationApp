import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Common/student_info_list.dart';

class HealthIssuesScreen extends StatefulWidget {
  final dynamic title;
  const HealthIssuesScreen({super.key, required this.title});

  @override
  State<HealthIssuesScreen> createState() => _HealthIssuesScreenState();
}

class _HealthIssuesScreenState extends State<HealthIssuesScreen> {
  int _expandState = 0;
  String? currentStudentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF974889),
        title: Text(
          widget.title,
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
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandState = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recorded on:',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                const Text(
                                  '08 September 2024, Sunday',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          _expandState == index
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Column(
                                      children: [
                                        Text(
                                          'Brain and nerve condition (e.g. seizures and headache Brain and nerve condition (e.g. seizures and headache',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
