import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/DashBoardScreen/dashboard_screen.dart';

import 'Screens/HomeScreen/pdf_viewer.dart';
import 'Screens/PreLoginScreens/login_screen.dart';
import 'Screens/PreLoginScreens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args1 = settings.arguments;
    // var args2 = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case DashboardScreen.id:
        return MaterialPageRoute(
            builder: (_) => const DashboardScreen(
                  userRole: '',
                ));
      // case FamilyProfileScreen.id:
      //   return MaterialPageRoute(builder: (_) => const FamilyProfileScreen());

      case PDFView.id:
        if (args1 is String) {
          return MaterialPageRoute(builder: (_) => PDFView(pdf: args1));
        }
        return errorRoute(settings);

      default:
        return errorRoute(settings);
    }
  }

  static Route<dynamic> errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            body:
                Center(child: Text('No route defined for ${settings.name}'))));
  }
}
