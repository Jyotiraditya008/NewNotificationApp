import 'dart:convert';

import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:minervaschool/Resources/app_colors.dart';
import 'package:minervaschool/SharedPref/pref.dart';
import 'package:minervaschool/SharedPref/pref_constants.dart';

import '../../Common/custom_rounded_button.dart';
import '../../Common/custom_text_form_field.dart';
import '../../Resources/app_images.dart';
import '../../Resources/app_strings.dart';
import '../../Resources/constants.dart';
import '../DashBoardScreen/dashboard_screen.dart';

class SpecialLoginScreen extends StatefulWidget {
  static const id = "LoginScreen";
  const SpecialLoginScreen({Key? key}) : super(key: key);

  @override
  State<SpecialLoginScreen> createState() => _SpecialLoginScreen();
}

class _SpecialLoginScreen extends State<SpecialLoginScreen> {
  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  void submitButtonPressed() async {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.id; //UUID for Android
      deviceModel = "android";
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor; //UUID for iOS
      deviceModel = "ios";
    }
    Prefs.setString(PreferenceConstants.deviceId, identifier.toString());
    Map<String, dynamic> map = {};
    map['deviceId'] = identifier;
    map['ip'] = "1.0.0.1";
    map['browser'] = "";
    map['browserVersion'] = "";
    map['platform'] = Platform.isAndroid ? "Android" : "iOS";
    map['manufacturer'] = deviceModel;
    map['deviceName'] = deviceName;
    await FirebaseMessaging.instance.getToken().then((value) async {
      if (value != null) {
        map['fcmToken'] = value.toString();
      } else {
        map['fcmToken'] = "";
      }
    });
    final enteredEmail = userNameController.text;
    try {
      final recordId = await generateOTP(enteredEmail);
      setState(() {
        showOtpFields = true;
        generatedRecordId = recordId; // Store the recordId in a variable
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  static const SizedBox verticalSpace = SizedBox(
    height: 10,
  );
  bool isLoading = false;
  String? deviceName;
  String? deviceVersion;
  String? identifier;
  String? deviceModel;
  String generatedRecordId = '';
  // Int r = '';
  // String t = '';
  // // int i = '';

  bool showOtpFields = false;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  TextEditingController userNameController = TextEditingController(text: '');
  TextEditingController otpController = TextEditingController(text: '');
  String base641 = "";

  Future<void> submitOTPApiCall(String recordId, String otp) async {
    setState(() {
      isLoading = true;
    });

    //final baseUrl = 'http://10.0.0.5/cle8';
    final baseUrl = 'http://mycampus.cloud';
    try {
      final apiUrl = '$baseUrl/api/mobile2/submitOTP';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'recordId': recordId,
        'otp': otp,
      });

      print('API Request: POST $apiUrl');
      print('Request Headers: $headers');
      print('Request Body: $body');

      final responseOTP =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      print('API Response: ${responseOTP.statusCode}');
      print('Response Body: ${responseOTP.body}');

      //print(responseData);

      String tokenGenerator(String r, String i, String t) {
        final jsonEncoder = JsonEncoder();

        Map<String, String> part1 = {"u": "", "p": "", "c": "", "t": t};
        String part1Stringyfy = jsonEncoder.convert(part1);
        String bs164 = base64.encode(part1Stringyfy.codeUnits);

        var part2 = {"r": r, "i": i};

        String part2Stringyfy = jsonEncoder.convert(part2);
        String bs264 = base64.encode(part2Stringyfy.codeUnits);
        print(bs164 + "." + bs264);
        return "$bs164.$bs264";
      }

      if (responseOTP.statusCode == 200) {
        final responseData = json.decode(responseOTP.body);
        print('Response Data: $responseData');
        // String r = responseData['data']['role'];
        // String i = responseData['data']['userId'];
        // String t = responseData['data']['authToken'];
        String authToken = tokenGenerator(
          responseData['data']['role'].toString(),
          responseData['data']['userId'].toString(),
          responseData['data']['authToken'].toString(),
        );
        //required in special login

        Prefs.setString(PreferenceConstants.authToken, authToken).then((value) {
          Navigator.pushReplacementNamed(context, DashboardScreen.id);
        });
        print(responseData);
        print(authToken);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login failed')));
        print(responseOTP);
      }
    } catch (error) {
      print('Error submitting OTP: $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: ListView(
          children: [
            AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
            ),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  UnconstrainedBox(
                    child: Image.asset(
                      AppImages.splashImage,
                      fit: BoxFit.fill,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  verticalSpace,
                  verticalSpace,
                  verticalSpace,
                  Center(
                    child: Text(
                      AppStrings.Speciallogin.toUpperCase(),
                      style: ts22Bold,
                    ),
                  ),
                  verticalSpace,
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.white),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: Column(
                children: [
                  // ... Rest of your code ...

                  if (!showOtpFields) ...[
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppStrings.SpecialLoginuserName,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    CustomTextFormField(
                      controller: userNameController,
                      height: MediaQuery.of(context).size.width / 8,
                      textStyle: ts16Normal,
                      textAlign: TextAlign.start,
                    ),
                    verticalSpace,
                    verticalSpace,
                    CustomRoundedButton(
                      controller: otpController,
                      height: MediaQuery.of(context).size.width / 7,
                      width: MediaQuery.of(context).size.width / 2,
                      boxDecoration: BoxDecoration(
                        color: AppColors.black1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        AppStrings.signIn,
                        style: ts18Bold.copyWith(color: AppColors.white),
                      ),
                      onPress: () {
                        submitButtonPressed();
                      },
                    ),
                  ] else ...[
                    // Show OTP input fields here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) => Container(
                          width: 50,
                          child: TextField(
                            controller:
                                otpControllers[index], // Use the controller
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '-',
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace,
                    verticalSpace,
                    CustomRoundedButton(
                      controller: otpController,
                      height: MediaQuery.of(context).size.width / 7,
                      width: MediaQuery.of(context).size.width / 2,
                      boxDecoration: BoxDecoration(
                        color: AppColors.black1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "verifyOTP",
                        style: ts18Bold.copyWith(color: AppColors.white),
                      ),
                      onPress: () {
                        String enteredOTP = otpControllers
                            .map((controller) => controller.text)
                            .join();
                        submitOTPApiCall(generatedRecordId, enteredOTP);
                      },
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> generateOTP(String email) async {
    final baseUrl =
        'https://mycampus.cloud'; // Replace with your actual base URL
    //final baseUrl = 'http://10.0.0.5/cle8';

    final apiUrl = '$baseUrl/api/mobile2/generateOTP';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'code': 'STELLAR', // School code
      'email': userNameController.text,
      'deviceId': identifier // Replace with your actual device ID
    });

    print('API Request: POST $apiUrl');
    print('Request Headers: $headers');
    print('Request Body: $body');

    final response =
        await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    print('API Response: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'OK') {
        return responseData['data']; // Return the record ID
      } else {
        throw Exception(responseData['message']); // Handle error case
      }
    } else {
      throw Exception('Failed to generate OTP'); // Handle error case
    }
  }
}
