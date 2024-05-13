import 'package:flutter/material.dart';
import '../../Common/student_info_list.dart';
import 'eventsDetails/events_details.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String? currentStudentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF974889),
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          body: Column(
            children: [
              StudentInfoList(
                onStudentChanged: (studentId) {
                  setState(() {
                    currentStudentId = studentId;
                  });
                },
              ),
              const TabBar(
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "MY EVENTS",
                  ),
                  Tab(
                    text: "NEW EVENTS",
                  )
                ],
                labelStyle: TextStyle(
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return const EventsDetails();
                                            },
                                          ));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "ES Robostics 23/24",
                                                      style: TextStyle(
                                                        color: Colors.black87
                                                            .withOpacity(0.7),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Sept 25,2024 - Sept 28,2024",
                                                      style: TextStyle(
                                                        color: Colors.black87
                                                            .withOpacity(0.7),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "sidam maldan",
                                                      style: TextStyle(
                                                        color: Colors.black87
                                                            .withOpacity(0.7),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Icon(
                                                  Icons.navigate_next,
                                                  size: 30,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
