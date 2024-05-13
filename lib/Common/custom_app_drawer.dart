import 'package:flutter/material.dart';

import '../Resources/app_colors.dart';

Widget appDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: AppColors.white,
    child: Padding(
      padding: const EdgeInsets.only(top: 0),
      // child:
      // DrawerFb1()
      //         ListView(

      //   padding: EdgeInsets.zero,
      //   children: <Widget>[

      //     ListTile(
      //         title: const Text(AppStrings.familyprofile),
      //         onTap: () {
      //           // Navigate to Item 1 page
      //           Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => const FamilyProfileScreen()));
      //         },
      //     ),
      //     ListTile(
      //         title:const Text(AppStrings.studentprofiel),
      //         onTap: () {
      //            Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => const StudentProfileScreen()));
      //         },
      //     ),
      //     ListTile(
      //         title:const Text(AppStrings.applyforleave),
      //         onTap: () {
      //           Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => const ApplyForLeave()));
      //         },
      //     ),
      //     ListTile(
      //         title: const Text(AppStrings.reregistration),
      //         onTap: () {
      //          Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => const ReRegistration()));
      //         },
      //     ),
      //     ListTile(
      //         title: const Text(AppStrings.siblingapplication),
      //         onTap: () {
      //           Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => const SiblingApplication()));
      //         },
      //     ),
      //     ListTile(
      //         title: const Text(AppStrings.feedback),
      //         onTap: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => const FeedBackScreen()));
      //         },
      //     ),
      //     ListTile(
      //         title: const Text(AppStrings.logout),
      //         onTap: () {

      //         },
      //     ),
      //   ],
      // ),
    ),
  );
}
