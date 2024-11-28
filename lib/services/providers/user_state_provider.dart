import 'package:flutter/material.dart';

class UserStateProvider extends ChangeNotifier {
  String _userName = "Teacher";
  String get userName => _userName;
  String _userPosition = "Add";
  String get userPosition => _userPosition;
  void updateName(String txt) {
    _userName = txt;
    notifyListeners();
  }

  void updatePositions(String txt) {
    _userPosition = txt;
    notifyListeners();
  }
}
