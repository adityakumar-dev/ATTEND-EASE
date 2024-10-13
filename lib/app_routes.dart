import 'package:attend_ease/Pages/Attendance/attendance_screen.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/Add%20Subject/add_subject.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/Register/register_student_screen.dart';
import 'package:attend_ease/Pages/Dashboard/home_scree.dart';
import 'package:attend_ease/Pages/Login/login_screen.dart';
import 'package:attend_ease/Pages/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.rootName:
        return getPageTransition(const SplashScreen(), settings);
      case HomeScreen.rootName:
        return getPageTransition(const HomeScreen(), settings);
      case RegisterStudentScreen.rootName:
        return getPageTransition(const RegisterStudentScreen(), settings);
      case AttendanceScreen.rootName:
        final args = settings.arguments;
        return getPageTransition(AttendanceScreen(args: args), settings);
      case LoginScreen.rootName:
        return getPageTransition(const LoginScreen(), settings);
      case AddSubjectScreen.rootName:
        return getPageTransition(const AddSubjectScreen(), settings);
      default:
        MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text("Path not Found"),
                  ),
                ));
    }
    return MaterialPageRoute(
        builder: (_) => const Scaffold(
              body: Center(
                child: Text("Path not Found"),
              ),
            ));
  }

  static PageTransition getPageTransition(
      Widget screen, RouteSettings settings) {
    return PageTransition(
        child: screen,
        type: PageTransitionType.theme,
        alignment: Alignment.center,
        settings: settings,
        duration: const Duration(milliseconds: 1000),
        maintainStateData: true,
        curve: Curves.easeInOut);
  }
}
