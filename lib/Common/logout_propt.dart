import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minervaschool/Common/new_app_drawer.dart';

import '../Cubits/RegisterCubit/register_cubit.dart';
import '../Screens/PreLoginScreens/login_screen.dart';
import '../SharedPref/pref.dart';
import '../SharedPref/pref_constants.dart';

class LogoutPrompt extends StatefulWidget {
  const LogoutPrompt({super.key});

  @override
  State<LogoutPrompt> createState() => _LogoutPromptState();
}

class _LogoutPromptState extends State<LogoutPrompt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure you want to logout?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await LogoutApiCall().then((value) {
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                        (route) =>
                            false, //if you want to disable back feature set to false
                      );
                    });
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> LogoutApiCall() async {
    Map<String, dynamic> map = {};
    map['deviceId'] = Prefs.getString(PreferenceConstants.deviceId);
    map['code'] = Prefs.getString(PreferenceConstants.schoolId);

    // print("======> $identifier  $deviceVersion $deviceName $deviceModel");
    context
        .read<RegisterCubit>()
        .logout(map, Prefs.getString(PreferenceConstants.authToken).toString())
        .then((value) {
      if (value!.status!.toLowerCase() == "ok".toLowerCase()) {
        Prefs.clear();
        if (value.data != null) {
          // Prefs.setString(
          //     PreferenceConstants.userId, value.data!.id.toString());
          // Prefs.setString(
          //     PreferenceConstants.phone, value.data!.phone.toString());
          // Navigator.pushReplacementNamed(context, DashboardScreen.id);

          if (kDebugMode) {
            print(
                "Logout Response1: ${Prefs.getString(PreferenceConstants.authToken.toString())}");
          }
        }
      }
      if (kDebugMode) {
        print(
            "Logout Response: ${Prefs.getString(PreferenceConstants.authToken.toString())}");
      }
    });
  }
}
