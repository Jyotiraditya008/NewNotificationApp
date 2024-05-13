import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Incident.dart';
import 'package:minervaschool/Screens/conductBehaviour/characterTraits/characterTraits.dart';

import 'goodNewsReport/good_news_report.dart';

class WellBingScreen extends StatefulWidget {
  const WellBingScreen({super.key});

  @override
  State<WellBingScreen> createState() => _WellBingScreenState();
}

class _WellBingScreenState extends State<WellBingScreen> {
  static const SizedBox verticalSpace = SizedBox(
    width: 15,
  );
  static const SizedBox verticalSpace5 = SizedBox(
    height: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0XFF974889),
          title: const Text(
            'Welling',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IncidentScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag,
                        size: 30,
                      ),
                      verticalSpace,
                      const Text(
                        'Incidents',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 55),
                color: Color(0xFFe9e9e9),
                height: 2,
                width: MediaQuery.of(context).size.width,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoodNewsReportScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag,
                        size: 30,
                      ),
                      verticalSpace,
                      const Text(
                        'Good News Report',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 55),
                color: Color(0xFFe9e9e9),
                height: 2,
                width: MediaQuery.of(context).size.width,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterTraits(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Colors.white,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.flag,
                        size: 30,
                      ),
                      verticalSpace,
                      Text(
                        'Character Traits',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 55),
                color: Color(0xFFe9e9e9),
                height: 2,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ));
  }
}
