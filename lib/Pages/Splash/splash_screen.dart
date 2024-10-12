import 'package:attend_ease/Pages/Dashboard/home_scree.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const String rootName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) Navigator.pushNamed(context, HomeScreen.rootName);
    });
    return Scaffold(
      backgroundColor: blacklight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "ATTEND EASE",
              style: kTextStyle(ksize32, whiteColor, true),
            ),
            heightBox(ksize10),
            Text(
              "attendance tracking system",
              style: kTextStyle(ksize12, greyColor, false, changeFont: true),
            )
          ],
        ),
      ),
    );
  }
}
