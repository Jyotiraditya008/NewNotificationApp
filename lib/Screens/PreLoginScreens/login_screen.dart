//////       APP WHICH IS AVAILABLE ON PLAY STORE /////////
import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:minervaschool/Models/PreLoginModels/login_model.dart';
import 'package:minervaschool/Resources/app_colors.dart';
import 'package:minervaschool/SharedPref/pref.dart';
import 'package:minervaschool/SharedPref/pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';

import '../../Common/custom_rounded_button.dart';
import '../../Common/custom_text_form_field.dart';
import '../../Cubits/RegisterCubit/register_cubit.dart';
import '../../Resources/app_images.dart';
import '../../Resources/app_strings.dart';
import '../../Resources/constants.dart';
import '../DashBoardScreen/dashboard_screen.dart';
import 'special_login_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = "LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class Student {
  final String fullName;
  final String sId;
  final String id;
  final String nowIn;

  Student({
    required this.fullName,
    required this.sId,
    required this.id,
    required this.nowIn,
  });
}

class _LoginScreenState extends State<LoginScreen> {
  late String _userID; // Declare as late
  late String _studentID; // Declare as late

  @override
  void initState() {
    super.initState();

    // Initialize late variables here
    _userID = '';
    _studentID = '';
  }

  static const SizedBox verticalSpace = SizedBox(
    height: 10,
  );
  bool isLoading = false;
  String? deviceName;
  String? deviceVersion;
  String? identifier;
  String? deviceModel;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController userNameController = TextEditingController(text: '');
  String base641 = "";

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
                  Center(
                    child: Text(
                      AppStrings.proceedAcc.toUpperCase(),
                      style: ts14Bold,
                    ),
                  ),
                  verticalSpace,
                  verticalSpace,
                  verticalSpace,
                  Center(
                    child: Text(
                      AppStrings.login.toUpperCase(),
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
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppStrings.userName,
                        textAlign: TextAlign.start,
                      )),
                  CustomTextFormField(
                    controller: userNameController,
                    height: MediaQuery.of(context).size.width / 8,
                    textStyle: ts16Normal,
                    textAlign: TextAlign.start,
                  ),
                  verticalSpace,
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppStrings.password,
                        textAlign: TextAlign.start,
                      )),
                  CustomTextFormField(
                    controller: passwordController,
                    height: MediaQuery.of(context).size.width / 8,
                    textStyle: ts16Normal,
                    textAlign: TextAlign.start,
                  ),
                  verticalSpace,
                  verticalSpace,
                  CustomRoundedButton(
                    controller: passwordController,
                    height: MediaQuery.of(context).size.width / 7,
                    width: MediaQuery.of(context).size.width / 2,
                    boxDecoration: BoxDecoration(
                        color: AppColors.black1,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      AppStrings.signIn,
                      style: ts18Bold.copyWith(color: AppColors.white),
                    ),
                    onPress: () {
                      basic();
                    },
                  ),
                  verticalSpace,
                  verticalSpace,
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SpecialLoginScreen()),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void basic() {
    setState(() {
      isLoading = true;
    });
    String publickey = AppStrings.publicKey;
    var pem =
        '-----BEGIN RSA PUBLIC KEY-----\n$publickey\n-----END RSA PUBLIC KEY-----';
    var public = CryptoUtils.rsaPublicKeyFromPem(pem);
    var cipher = PKCS1Encoding(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(public));
    Uint8List output = cipher
        .process(Uint8List.fromList(utf8.encode(passwordController.text)));
    var base64EncodedText = base64Encode(output);
    base641 = base64EncodedText;
    setState(() {});
    loginApiCall();
  }

  String loginTokenGenrator() {
    final jsonEncoder = JsonEncoder();

    Map<String, String> part1 = {
      "u": userNameController.text,
      "p": base641,
      "c": "minerva",
      // "c": "ais",
      "t": ""
    };
    String part1Stringyfy = jsonEncoder.convert(part1);
    String bs164 = base64.encode(part1Stringyfy.codeUnits);

    var part2 = {"r": 0, "i": ""};

    String part2Stringyfy = jsonEncoder.convert(part2);
    String bs264 = base64.encode(part2Stringyfy.codeUnits);

    print(bs164 + "." + bs264);
    print("auth token is here");

    return "$bs164.$bs264";
  }

  Future<void> loginApiCall() async {
    String token = loginTokenGenrator();
    setState(() {
      isLoading = true;
    });

    // Obtain device information
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

    // Save device ID
    Prefs.setString(PreferenceConstants.deviceId, identifier.toString());

    // Construct request parameters
    Map<String, dynamic> map = {};
    map['deviceId'] = identifier;
    map['ip'] = "1.0.0.1";
    map['browser'] = "";
    map['browserVersion'] = "";
    map['platform'] = Platform.isAndroid ? "Android" : "iOS";
    map['manufacturer'] = deviceModel;
    map['deviceName'] = deviceName;

    // Get FCM token
    await FirebaseMessaging.instance.getToken().then((value) async {
      if (value != null) {
        map['fcmToken'] = value.toString();
      } else {
        map['fcmToken'] = "";
      }
    });

    print("auth token is here 2");

    // Perform login API call
    context.read<RegisterCubit>().login(map, token).then((value) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print("======${value.toString()}");
      }

      print('Login API Response to be used: $value');

      if (value != null && value.data != null) {
        if (value.data!.authToken != null) {
          // Extract user role and ID
          String authToken = tokenGenerator(value.data!.role.toString(),
              value.data!.userId.toString(), value.data!.authToken.toString());
          String userRole = value.data!.role.toString();
          String userId = value.data!.userId.toString();

          List<Student> students = [];
          // Save user ID
          TokenManager().saveUserId(userId);

          if (value.data!.students != null &&
              value.data!.students!.isNotEmpty) {
            for (var studentData in value.data!.students!) {
              String fullName = studentData.fullName ?? '';
              String sId = studentData.sId ?? '';
              String id = studentData.id ?? '';
              String nowIn = studentData.nowIn ?? '';

              // Print the data before saving
              print('Saving data for student:');
              print('Full Name: $fullName');
              print('SId: $sId');
              print('ID: $id');
              print('Now In: $nowIn');

              // Create a Student object and add it to the list
              students.add(Student(
                fullName: fullName,
                sId: sId,
                id: id,
                nowIn: nowIn,
              ));
            }

            TokenManager().saveStudents(students);

            print('List of saved students:');
            for (var student in students) {
              print('Full Name: ${student.fullName}');
              print('SId: ${student.sId}');
              print('ID: ${student.id}');
              print('Now In: ${student.nowIn}');
            }
            Navigator.pushReplacementNamed(
              context,
              DashboardScreen.id,
              arguments: {
                'userRole': userRole,
              },
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(value.data!.message.toString())));
        }
      }
    });
  }

  String tokenGenerator(String r, String i, String t) {
    final jsonEncoder = JsonEncoder();

    Map<String, String> part1 = {"u": "", "p": "", "c": "", "t": t};
    String part1Stringyfy = jsonEncoder.convert(part1);
    String bs164 = base64.encode(part1Stringyfy.codeUnits);

    var part2 = {"r": r, "i": i};

    String part2Stringyfy = jsonEncoder.convert(part2);
    String bs264 = base64.encode(part2Stringyfy.codeUnits);

    // Do not store the token here
    String authToken = "$bs164.$bs264";
    print("auth token is here");

    // Use TokenManager to save the token
    TokenManager().saveAuthToken(authToken);

    return authToken;
  }

  Future<void> storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppColors.white;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.26);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.26);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class UserData {
  static final UserData _singleton = UserData._internal();

  factory UserData() {
    return _singleton;
  }

  UserData._internal() {
    // Initialize late variables here
    _userID = '';
    _studentID = '';
  }

  late String _userID;
  late String _studentID;

  String get userID => _userID;
  String get studentID => _studentID;

  setUserData(String userID, String studentID) {
    _userID = userID;
    _studentID = studentID;
  }
}
