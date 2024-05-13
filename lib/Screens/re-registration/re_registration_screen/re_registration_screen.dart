import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom_toggle_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static const SizedBox verticalSpace5 = SizedBox(height: 5,);
  final bool _isSubmitBtn = false;
  bool isChecked = false;
  bool isAgreeOrSubmitBtn = false;

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms and Condition'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                          debugPrint("isChecked: $isChecked");
                        });
                      },
                      visualDensity: VisualDensity.compact, // Remove padding
                    ),
                    const Expanded(
                        child: Text('i heareby attest that im the parent/legal quardian of the above student and i have personally complete...',style: TextStyle(
                            fontSize: 14
                        ),)),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Disagree'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agree'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  final reRegistrationList = [
    RegistrationModel(
        title: "Aram Terzian", isContinue: false, isTransport: false),
    RegistrationModel(
        title: "Raman sharma", isContinue: false, isTransport: false),
    RegistrationModel(
        title: "Raman sharma", isContinue: false, isTransport: false),
    RegistrationModel(
        title: "Raman sharma", isContinue: false, isTransport: false),
    RegistrationModel(
        title: "Raman sharma", isContinue: false, isTransport: false),
    RegistrationModel(
        title: "Raman sharma", isContinue: false, isTransport: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF974889),
        title: const Text(
          'Purchase History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: reRegistrationList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.red,
                                  ),
                                  height: 75,
                                  width: 75,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        'Aram Terzian',
                                        style: TextStyle(color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '3',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        '234432',
                                        style: TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: const Column(
                                children: [
                                  SizedBox(height: 7,),
                                  Icon(Icons.invert_colors_outlined),
                                  Text('Received',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        verticalSpace5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Will continue in 2024-2025?',
                              style: TextStyle(color: Colors.black),
                            ),
                            CustomSwitch(
                              value: reRegistrationList[index].isContinue,
                              onChanged: (bool val) {
                                setState(() {
                                  reRegistrationList[index].isContinue = val;
                                  isAgreeOrSubmitBtn = reRegistrationList.any((element) => element.isContinue == true);
                                });
                              },
                            ),
                          ],
                        ),
                        verticalSpace5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Avail school transport in 2024-2025',
                              style: TextStyle(color: Colors.black),
                            ),
                            CustomSwitch(
                              value: reRegistrationList[index].isTransport,
                              onChanged: (bool val) {
                                setState(() {
                                  reRegistrationList[index].isTransport = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },),
          ),
          Visibility(
            visible: _isSubmitBtn,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(25),
                      topLeft: Radius.circular(25))
              ),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.green,
                      child: Row(
                        children: [
                          Icon(Icons.cancel_outlined, color: Colors.black,),
                          const Text(
                            'Avail school transport in 2024-2025',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        Visibility(
            visible: isAgreeOrSubmitBtn,
            child: GestureDetector(
              onTap: () {
                _showMyDialog(context);
              },
              child: Container(
                color: Colors.green,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Accept & Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationModel{
  String? title;
  bool isContinue;
  bool isTransport;

  RegistrationModel({this.title,
    required this.isContinue,
    required this.isTransport,
  });

}


