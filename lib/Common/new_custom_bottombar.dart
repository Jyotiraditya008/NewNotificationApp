import 'package:flutter/material.dart';
import 'package:minervaschool/Resources/app_colors.dart';
import 'package:minervaschool/Resources/app_strings.dart';
import 'package:minervaschool/Resources/constants.dart';
import 'package:minervaschool/Screens/DashBoardScreen/academics/academics_screen.dart';
import 'package:minervaschool/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:minervaschool/Screens/DashBoardScreen/fee/fee_screen.dart';
import 'package:minervaschool/Screens/DashBoardScreen/transport/transport_screen.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Essentials.dart';
import 'package:minervaschool/Screens/Routines/routines_screen.dart';
import 'package:minervaschool/Screens/HomeScreen/home_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  static late TabController _tabController;
  GlobalKey bottomNavigationKey = GlobalKey();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(_selectedIndex);
      print("------->" +
          index.toString() +
          "  -- " +
          _tabController.index.toString());
    });
  }

  List<Widget> pages = [];

  initialization() {
    pages.add(HomeScreen(
      role: '',
    ));
    // pages.add(TransportScreen());
    pages.add(EssentialScreen());
    pages.add(AcademicsScreen());
    pages.add(FeeScreen());
    pages.add(RoutinesScreen());
    // pages.add(RoutinesScreen());
    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: bottomNavigationKey,
      backgroundColor: AppColors.orangeAccent,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      unselectedLabelStyle: ts10Normal.copyWith(fontWeight: FontWeight.w700),
      selectedLabelStyle: ts10Normal.copyWith(fontWeight: FontWeight.w700),
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.blue300,
      selectedIconTheme: IconThemeData(color: AppColors.white),
      onTap: (value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen(
                  userRole: '',
                  data: value,
                )));
      },
      currentIndex: _selectedIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _selectedIndex == 0 ? AppColors.white : AppColors.black,
          ),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          /*icon: Image.asset(
                      AppImages.progress,
                      height: 30,
                      width: 30,
                    ),*/
          icon: Icon(
            Icons.markunread_mailbox_outlined,
            color: _selectedIndex == 1 ? AppColors.white : AppColors.black,
          ),
          label: AppStrings.mailBox,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.view_module_outlined,
            color: _selectedIndex == 2 ? AppColors.white : AppColors.black,
          ),
          label: AppStrings.modules,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month,
            color: _selectedIndex == 3 ? AppColors.white : AppColors.black,
          ),
          label: AppStrings.calender,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.more_horiz,
            color: _selectedIndex == 4 ? AppColors.white : AppColors.black,
          ),
          label: AppStrings.more,
        ),
      ],
    );
  }
}
