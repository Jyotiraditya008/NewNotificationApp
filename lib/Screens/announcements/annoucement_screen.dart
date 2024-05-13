import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'announcement_details.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF974889),
        title: const Text(
          'Announcement',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder:(context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnouncementDetails(),
                        ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5,left: 10,right: 10,top: 5),
                    child: DottedBorder(
                      color: Color.fromARGB(255, 133, 126, 255),
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(16),
                      padding: EdgeInsets.all(4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Please check your username or password. if you want to change the password please go to the setting screen',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              '12/02/2024 12:10 pm',
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            },),
          )
        ],
      ),
    );
  }
}
