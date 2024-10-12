import 'package:attend_ease/Pages/Splash/splash_screen.dart';
import 'package:attend_ease/app_routes.dart';
import 'package:attend_ease/services/providers/attendance_provider.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:attend_ease/services/providers/home_page_handler.dart';
import 'package:attend_ease/services/providers/student_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomePageHandler(context, () {}),
        ),
        ChangeNotifierProvider(
          create: (context) => StudentListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AttendanceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrentStlList(),
        )
      ],
      child: const MaterialApp(
        title: 'ATTEND EASE',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        initialRoute: SplashScreen.rootName,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
