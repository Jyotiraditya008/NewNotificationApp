import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/PreLoginScreens/login_screen.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';

class StudentInfoList extends StatefulWidget {
  final Function(String?) onStudentChanged; // Define named parameter

  const StudentInfoList({Key? key, required this.onStudentChanged})
      : super(key: key);

  @override
  _StudentInfoListState createState() => _StudentInfoListState();
}

class _StudentInfoListState extends State<StudentInfoList> {
  final ScrollController _scrollController = ScrollController();
  List<Student>? students; // Define students at class level

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchStudents(); // Initiate fetching students when widget initializes
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchStudents() async {
    try {
      final fetchedStudents = await TokenManager().getStudents();
      setState(() {
        students = fetchedStudents;
      });
    } catch (error) {
      // Handle error fetching students
      print('Error fetching students: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (students == null) {
      // Show loading indicator while fetching students
      return Center(child: CircularProgressIndicator());
    } else if (students!.isEmpty) {
      // Show empty state if no students available
      return Center(child: Text('No students available'));
    } else {
      return _buildListView();
    }
  }

  Widget _buildListView() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: students!.length,
        itemBuilder: (context, index) {
          Student student = students![index];
          return GestureDetector(
            onTap: () {
              widget.onStudentChanged(student.id);
              print('Selected Student ID: ${student.id}');
            },
            child: _buildStudentCard(student),
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFf996c2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: Row(
                children: [
                  Image.network(
                    "https://mycampus.cloud//api/student/image/${student.sId}/${student.id}",
                    height: 90,
                    width: 90,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            student.fullName ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFF974889),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            student.nowIn ?? '',
                            style: TextStyle(
                              color: Color(0XFF974889),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 3.0),
                              child: Text(
                                "ACTIVE",
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _scrollListener() {
    final double itemPosition = _scrollController.position.pixels;
    final double itemWidth = MediaQuery.of(context).size.width;
    final int currentIndex = (itemPosition / itemWidth).round();
    if (currentIndex >= 0 && currentIndex < students!.length) {
      widget.onStudentChanged(students![currentIndex].id);
    }
  }
}
