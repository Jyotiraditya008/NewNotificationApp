import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../Common/common_app_bar_widget.dart';
import '../../Common/screen holder/screen_holder.dart';
import '../../Resources/app_colors.dart';
import '../../Resources/app_images.dart';
import '../../Resources/app_strings.dart';
import '../../Resources/constants.dart';
import '../../SharedPref/pref.dart';
import '../../SharedPref/pref_constants.dart';
import '../DashBoardScreen/dashboard_screen.dart';

class SiblingApplication extends StatefulWidget {
  const SiblingApplication({
    super.key,
  });

  @override
  State<SiblingApplication> createState() => _SiblingApplicationState();
}

class _SiblingApplicationState extends State<SiblingApplication> {
  late int _selectedIndex = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  bool isLoading = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(Prefs.getString(PreferenceConstants.authToken)!);
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavigationKey,
        backgroundColor: AppColors.bottomBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.selectedItem,
        unselectedItemColor: AppColors.unSelectedItem,
        onTap: (value) {
          // _onItemTapped(value);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return DashboardScreen(
              userRole: '',
            );
          }));
        },
        selectedFontSize: 0,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(AppImages.home, AppStrings.home, 0),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppImages.essentials, AppStrings.essentials, 1),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppImages.mainBox, AppStrings.mailBox, 2),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppImages.fee, AppStrings.calender, 3),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppImages.routines, AppStrings.module, 4),
            label: "",
          ),
        ],
      ),
      appBar: CommonAppBarDash(context, true),
      body: viewMethod(
          'http://mycampus.cloud/app_Assets/webviews/admission.html?n=2',
          // 'http://10.0.0.5/cle8/app_Assets/webviews/admission.html?n=2',
          webViewKey,
          webViewController,
          isLoading),
    );
  }

  Widget _buildIcon(String iconData, String text, int index) => Container(
        width: double.infinity,
        height: kBottomNavigationBarHeight * 1.2,
        decoration: BoxDecoration(
            color: AppColors.bottomBackground,
            border: Border.all(color: AppColors.unSelectedItem)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Icon(iconData, color: _getItemColor(index)),
            Image.asset(iconData,
                color: AppColors.unSelectedItem, height: 25, width: 25),
            Text(text,
                style: ts14Bold.copyWith(color: AppColors.unSelectedItem)),
          ],
        ),
      );
}
