import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/services/local%20storage/local_storage_manager.dart';
import 'package:flutter/material.dart';

class CurrentStlList extends ChangeNotifier {
  List<String> _deptList = ['All'];
  List<String> get deptList => _deptList;
  List<String> _yearList = ['All'];
  List<String> get yearList => _yearList;
  Map<String, List<String>> _subjectList = {};
  Map<String, List<String>> get subjectList => _subjectList;

  List<Student> _currentStudentList = [];
  List<Student> get currentList => _currentStudentList;

  void setList(List<Student> stl) {
    _currentStudentList = stl;

    // LocalStorageManager.storeCurrentStl(
    //     _currentStudentList, deptList, subjectList);
    notifyListeners();
  }

  void addYearList(String name) {
    _yearList.add(name);

    LocalStorageManager.storeCurrentStl(
        _currentStudentList, deptList, _yearList, subjectList);
    notifyListeners();
  }

  void setSubjects(Map<String, List<String>> map) {
    _subjectList = map;
    notifyListeners();
  }

  void setYears(List<String> list) {
    _yearList = list;
    notifyListeners();
  }

  void addDeptList(String name) {
    _deptList.add(name);

    LocalStorageManager.storeCurrentStl(
        _currentStudentList, deptList, _yearList, subjectList);
    notifyListeners();
  }

  void addSubjects(String dept, List<String> subjects) {
    if (_subjectList[dept] == null) {
      _subjectList[dept] = [];
    }
    _subjectList[dept]!.addAll(subjects);

    LocalStorageManager.storeCurrentStl(
        _currentStudentList, deptList, _yearList, subjectList);
    notifyListeners();
  }

  void setDeptlist(List<String> name) {
    _deptList = name;

    // LocalStorageManager.storeCurrentStl(
    //     _currentStudentList, deptList, subjectList);
    notifyListeners();
  }
}
