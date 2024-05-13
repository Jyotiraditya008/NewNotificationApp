import 'package:flutter/material.dart';

class AnnouncementDetails extends StatefulWidget {
  const AnnouncementDetails({super.key});

  @override
  State<AnnouncementDetails> createState() => _AnnouncementDetailsState();
}

class _AnnouncementDetailsState extends State<AnnouncementDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF974889),
        title: const Text(
          'Announcement Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.network("https://img.freepik.com/free-photo/friendly-confident-woman-writing-her-organizer-isolated-white-wall_231208-1176.jpg?size=626&ext=jpg&ga=GA1.1.1463914310.1709965237&semt=sph"),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '12/02/2024 12:10 pm',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            SizedBox(height: 20,),
            const Text(
              'Please check your username or password. if you want to change the password please go to the setting screen',
              style: TextStyle(color: Colors.black,fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
