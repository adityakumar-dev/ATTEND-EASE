import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/services/local%20storage/local_storage_manager.dart';
import 'package:flutter/material.dart';

class StudentListProvider extends ChangeNotifier {
  Map<String, List<Student>> _studentData = {};

  void setStudentList(Map map) {
    _studentData = map as Map<String, List<Student>>;
    notifyListeners();
  }

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

    LocalStorageManager.storeStudentList(studentData);
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
    LocalStorageManager.storeStudentList(studentData);
  }
}
