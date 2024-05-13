import 'package:flutter/material.dart';
import 'package:minervaschool/Resources/app_images.dart';
import 'package:minervaschool/Resources/global_variable.dart';

import '../../Common/inkwell_widget.dart';
import '../../Resources/app_colors.dart';
import '../../Resources/constants.dart';

class ModuleListScreen extends StatelessWidget {
  final TabController? tabController;
  const ModuleListScreen(this.tabController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.background), fit: BoxFit.fill)),
        padding: EdgeInsets.only(bottom: 110),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkwellWidget(
              onTap: () {
                tabController?.animateTo(5);
                GlobalData.moduleIndex = 0;
                // setState(() {
                //   index = 0;
                //   url =
                //   "https://mycampus.cloud/app_Assets/webviews/school.html";
                //   webViewController?.loadUrl(
                //       urlRequest: URLRequest(url: Uri.parse(url)));
                // });
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ModuleScreen()));*/
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: GlobalData.moduleIndex == 0
                        ? AppColors.darkBlueBackground
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.darkBlueBackground, width: 2)),
                child: Text(
                  "School",
                  style: ts16Normal.copyWith(
                      color: GlobalData.moduleIndex == 0
                          ? AppColors.white
                          : AppColors.darkBlueBackground),
                ),
              ),
            ),
            InkwellWidget(
              onTap: () {
                tabController?.animateTo(5);
                GlobalData.moduleIndex = 1;
                // setState(() {
                //   index = 1;
                //   url =
                //   "https://mycampus.cloud/app_Assets/webviews/class.html";
                //   webViewController?.loadUrl(
                //       urlRequest: URLRequest(url: Uri.parse(url)));
                // });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: GlobalData.moduleIndex == 1
                        ? AppColors.darkBlueBackground
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.darkBlueBackground, width: 2)),
                child: Text(
                  "Class",
                  style: ts16Normal.copyWith(
                      color: GlobalData.moduleIndex == 1
                          ? AppColors.white
                          : AppColors.darkBlueBackground),
                ),
              ),
            ),
            InkwellWidget(
              onTap: () {
                tabController?.animateTo(5);
                GlobalData.moduleIndex = 2;
                // setState(() {
                //   index = 2;
                //   url =
                //   "https://mycampus.cloud/app_Assets/webviews/routines.html";
                //   webViewController?.loadUrl(
                //       urlRequest: URLRequest(url: Uri.parse(url)));
                // });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: GlobalData.moduleIndex == 2
                        ? AppColors.darkBlueBackground
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.darkBlueBackground, width: 2)),
                child: Text(
                  "Routines",
                  style: ts16Normal.copyWith(
                      color: GlobalData.moduleIndex == 2
                          ? AppColors.white
                          : AppColors.darkBlueBackground),
                ),
              ),
            ),
            // InkwellWidget(
            //   onTap: () {
            //     tabController?.animateTo(5);
            //     GlobalData.moduleIndex = 3;
            //     // setState(() {
            //     //   index = 3;
            //     //   url =
            //     //   "https://mycampus.cloud/app_Assets/webviews/wellbeing.html";
            //     //   webViewController?.loadUrl(
            //     //       urlRequest: URLRequest(url: Uri.parse(url)));
            //     // });
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            //     decoration: BoxDecoration(
            //         color: GlobalData.moduleIndex == 3
            //             ? AppColors.darkBlueBackground
            //             : AppColors.white,
            //         borderRadius: BorderRadius.circular(20),
            //         border: Border.all(
            //             color: AppColors.darkBlueBackground, width: 2)),
            //     child: Text(
            //       "Well-Being",
            //       style: ts16Normal.copyWith(
            //           color: GlobalData.moduleIndex == 3
            //               ? AppColors.white
            //               : AppColors.darkBlueBackground),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
