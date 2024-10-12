import 'package:flutter/material.dart';

class HomePageHandler extends ChangeNotifier {
  late String currentAppBarText;
  late Widget currentPage;
  int currentIndex = 0;

  HomePageHandler(BuildContext context, Function() onTapIcon) {}
}
