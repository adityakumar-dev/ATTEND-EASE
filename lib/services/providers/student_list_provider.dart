import 'package:attend_ease/Models/student_model.dart';
import 'package:flutter/material.dart';

class StudentListProvider extends ChangeNotifier {
  final Map<String, List<Student>> _studentData = {};
  Map<String, List<Student>> get studentData => _studentData;
  void addStudent(String year, Student st) {
    if (_studentData[year] == null) {
      _studentData[year] = [];
    }

    if (_studentData[year]
            ?.indexWhere((el) => el.rollNumber == st.rollNumber) ==
        -1) {
      _studentData[year]?.add(st);
    }

    notifyListeners();
  }

  void deleteStudent({required String uuid}) {
    final keys = _studentData.keys;
    for (String key in keys) {
      _studentData[key]?.removeWhere((el) => el.uniqueId == uuid);
    }
    notifyListeners();
  }

  void updateStudent({required Student updatedStudent}) {
    final keys = _studentData.keys;
    for (String key in keys) {
      final index = _studentData[key]
          ?.indexWhere((el) => el.uniqueId == updatedStudent.uniqueId);
      if (index != null) {
        _studentData[key]?[index] = updatedStudent;
      }
    }
  }
}
