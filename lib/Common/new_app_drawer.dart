import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minervaschool/Common/logout_propt.dart';
import 'package:minervaschool/Resources/app_images.dart';
import 'package:minervaschool/Resources/constants.dart';
import 'package:minervaschool/SharedPref/pref_constants.dart';

import '../Cubits/RegisterCubit/register_cubit.dart';
import '../Resources/app_colors.dart';
import '../Resources/app_strings.dart';
import '../Screens/drawerscreens/apply_for_leave.dart';
import '../Screens/drawerscreens/attendance_screen.dart';
import '../Screens/drawerscreens/family_profile_screen.dart';
import '../Screens/drawerscreens/feedback.dart';
import '../Screens/drawerscreens/re-registration.dart';
import '../Screens/drawerscreens/student_prpfile_screen.dart';
import '../SharedPref/pref.dart';

class DrawerFb1 extends StatelessWidget {
  final TabController? tabController;

  const DrawerFb1(
    this.tabController, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: AppColors.drawerCreambackground,
        child: ListView(
          children: <Widget>[
            Container(
              // padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ProfileFb1(
                    imageUrl: AppImages.splashImage,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  InkWell(
                    splashColor: AppColors.transparent,
                    focusColor: AppColors.transparent,
                    onTap: () {
                      tabController!.animateTo(6);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FamilyProfileScreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(color: AppColors.white),
                      child: Row(
                        children: [
                          Image.asset('assets/newIcons/Family.png',
                              width: 54, height: 54),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              AppStrings.familyprofile,
                              style:
                                  ts16Normal.copyWith(color: AppColors.black1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    splashColor: AppColors.transparent,
                    focusColor: AppColors.transparent,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StudentProfileScreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(color: AppColors.white),
                      child: Row(
                        children: [
                          Image.asset('assets/newIcons/STUDENT.png',
                              width: 42, height: 42),
                          SizedBox(width: 26),
                          Expanded(
                            child: Text(
                              AppStrings.studentprofiel,
                              style: ts16Normal.copyWith(
                                  color: AppColors.oddButtonGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    splashColor: AppColors.transparent,
                    focusColor: AppColors.transparent,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ApplyForLeave()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(color: AppColors.white),
                      child: Row(
                        children: [
                          Image.asset('assets/newIcons/ApplyForLeave.png',
                              width: 48, height: 48),
                          SizedBox(width: 22),
                          Expanded(
                            child: Text(
                              AppStrings.applyforleave,
                              style:
                                  ts16Normal.copyWith(color: AppColors.black1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //ONLY FOR STAFF
                  // const SizedBox(height: 5),
                  // InkWell(
                  //   splashColor: AppColors.transparent,
                  //   focusColor: AppColors.transparent,
                  //   onTap: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             const Attendance()));
                  //   },
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  //     decoration: BoxDecoration(
                  //         color: AppColors.drawerButtonBackground),
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.favorite_border, color: AppColors.white),
                  //         SizedBox(width: 20),
                  //         Expanded(
                  //           child: Text(
                  //             AppStrings.attendance,
                  //             style:
                  //                 ts16Normal.copyWith(color: AppColors.white),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // // const SizedBox(height: 5),
                  // InkWell(
                  //   splashColor: AppColors.transparent,
                  //   focusColor: AppColors.transparent,
                  //   onTap: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             const ReRegistration()));
                  //   },
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  //     decoration: BoxDecoration(
                  //         color: AppColors.drawerButtonBackground),
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.favorite_border, color: AppColors.white),
                  //         SizedBox(width: 20),
                  //         Expanded(
                  //           child: Text(
                  //             AppStrings.reregistration,
                  //             style:
                  //                 ts16Normal.copyWith(color: AppColors.white),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 5),
                  // InkWell(
                  //   splashColor: AppColors.transparent,
                  //   focusColor: AppColors.transparent,
                  //   onTap: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             const FeedBackScreen()));
                  //   },
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  //     decoration: BoxDecoration(
                  //         color: AppColors.drawerButtonBackground),
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.favorite_border, color: AppColors.white),
                  //         SizedBox(width: 20),
                  //         Expanded(
                  //           child: Text(
                  //             AppStrings.feedback,
                  //             style:
                  //                 ts16Normal.copyWith(color: AppColors.white),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 5),
                  InkWell(
                    splashColor: AppColors.transparent,
                    focusColor: AppColors.transparent,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LogoutPrompt()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(color: AppColors.white),
                      child: Row(
                        children: [
                          Image.asset('assets/newIcons/Logut.png',
                              width: 40, height: 40),
                          SizedBox(width: 31),
                          Expanded(
                            child: Text(
                              AppStrings.logout,
                              style: ts16Normal.copyWith(
                                  color: AppColors.oddButtonGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(), // Page 1
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(), // Page 2
        ));
        break;
    }
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onClicked;

  const MenuItem({
    required this.text,
    required this.icon,
    this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}

class SearchFieldDrawer extends StatelessWidget {
  const SearchFieldDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(
          Icons.search,
          color: color,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}

class ProfileFb1 extends StatelessWidget {
  const ProfileFb1({required this.imageUrl, this.radius = 70.0, Key? key})
      : super(key: key);
  final String imageUrl;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.white,
      backgroundImage: AssetImage(
        imageUrl,
      ),
    );
  }
}

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
