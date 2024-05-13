import 'package:flutter/material.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

// class Homework {
//   final String title;
//   final String description;

//   Homework({required this.title, required this.description});
// }

class _AssignmentScreenState extends State<AssignmentScreen> {
  // Dummy homework data for testing
  // final List<Homework> homeworkList = [
  //   Homework(title: 'Math Assignment', description: 'Solve problems 1 to 10.'),
  //   Homework(
  //       title: 'History Reading', description: 'Read chapter 3 and summarize.'),
  //   // Add more homework items as needed
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
      ),
      body: ListView.builder(
        //itemCount: homeworkList.length,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
            child: ListTile(
              title: Text("Hi"),
              subtitle:
                  Text("jhsdcldusbjdhscblsucbsdchsbd;ccldsclscvscksdmcodskj"),
              // Add more details as needed
            ),
          );
        },
      ),
    );
  }
}
