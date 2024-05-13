import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PurchaseLimit extends StatefulWidget {
  const PurchaseLimit({super.key});

  @override
  State<PurchaseLimit> createState() => _PurchaseLimitState();
}

class _PurchaseLimitState extends State<PurchaseLimit> {
  static const SizedBox verticalSpace = SizedBox(height: 10,);
  TextEditingController purchaseLimitController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0XFF974889),
          title: const Text(
            'Purchase History',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                  verticalSpace,
                  Text(
                    "Spending Limit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace,
                  Text(
                    "0",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: purchaseLimitController,
                      decoration: InputDecoration(
                        hintText: 'Enter Purchase Limit',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "All digit are in AED",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child:  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('Set Purchase Limit',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white),)),
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
