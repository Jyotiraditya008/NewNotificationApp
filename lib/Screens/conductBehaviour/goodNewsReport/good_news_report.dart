import 'package:flutter/material.dart';

class GoodNewsReportScreen extends StatefulWidget {
  const GoodNewsReportScreen({super.key});

  @override
  State<GoodNewsReportScreen> createState() => _GoodNewsReportScreenState();
}

class _GoodNewsReportScreenState extends State<GoodNewsReportScreen> {
   int expandState = -1;

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
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
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
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/assignment.png",
                                  height: 100,
                                  width: 100,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Meera Mohamand Ei Meski",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0XFF974889),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Row(
                                        children: [
                                          Text(
                                            "Student id ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0XFF974889),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "6515-23",
                                            style: TextStyle(
                                              color: Color(0XFF974889),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
                                          child: Text(
                                            "ACTIVE",
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Placing the "2-As" text at the end of the row
                                      const Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "2-A",
                                          style: TextStyle(
                                            color: Color(0XFF974889),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
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
                },),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandState = index;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFFe9e9e9),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    Image.asset(
                                        height: 25,
                                        "assets/images/ic_calender.png"),
                                    SizedBox(width: 10,),
                                    Text(
                                      "Jan 28,2023",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                      ),
                      expandState == index ? Container(
                        color: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                "Hello How Are you ?",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : SizedBox.shrink()
                    ],
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
