import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minervaschool/Resources/app_strings.dart';
import 'package:minervaschool/Resources/constants.dart';
import 'package:minervaschool/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Resources/app_colors.dart';
import '../../Resources/app_images.dart';
import '../../SharedPref/pref.dart';
import '../../SharedPref/pref_constants.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String version = "1.2";
  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    await Prefs.init();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    if (Prefs.getString(PreferenceConstants.authToken) == null) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()));
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(

            //builder: (BuildContext context) => DashboardScreen()));
            builder: (BuildContext context) => DashboardScreen(
                  userRole: '',
                )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  AppImages.splashImage,
                  fit: BoxFit.fill,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Text(
              "${AppStrings.version.toUpperCase()} $version",
              style: ts12Bold,
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
