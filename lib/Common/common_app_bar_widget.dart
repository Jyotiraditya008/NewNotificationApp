import 'package:flutter/material.dart';

import '../Resources/app_colors.dart';
import '../Resources/app_images.dart';
import 'common_notifications.dart';

PreferredSizeWidget CommonAppBarWidget(BuildContext context, bool draweris) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: AppBar(
      elevation: 0, // Set elevation to 0 to remove shadow
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(
          255, 255, 255, 255), // Make AppBar background transparent
      centerTitle: true,

      title: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              AppImages.splashImage,
              fit: BoxFit.fill,
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),

      leading: draweris
          ? Builder(
              builder: (BuildContext context) {
                return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.white),
                        borderRadius: BorderRadius.circular(5)),
                    margin: EdgeInsets.only(left: 8, top: 5),
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: Image.asset('assets/newIcons/drawer.png')));
              },
            )
          : SizedBox(),

      actions: [
        Container(
            width: 49,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.white),
                borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.only(right: 8, top: 5),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const NotificationScreen()));
                },
                icon: Image.asset('assets/newIcons/Message.png')))
      ],
    ),
  );
}

PreferredSizeWidget CommonAppBarDash(BuildContext context, bool draweris) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent, // Make AppBar background transparent
    centerTitle: true,

    title: Container(
      alignment: Alignment.center,
      child: Image.asset(
        AppImages.splashImage,
        fit: BoxFit.fill,
        width: 50,
        height: 50,
      ),
    ),
    leading: draweris
        ? Builder(
            builder: (BuildContext context) {
              return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  margin: EdgeInsets.only(left: 8, top: 5),
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                      )));
            },
          )
        : SizedBox(),

    actions: [
      Container(
          width: 50,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(5)),
          margin: EdgeInsets.only(right: 8, top: 5),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const NotificationScreen()));
              },
              icon: Image.asset(AppImages.notification)))
    ],
  );
}
