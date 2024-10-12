import 'package:attend_ease/Models/student_model.dart';
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
    notifyListeners();
  }

  void addYearList(String name) {
    _yearList.add(name);
    notifyListeners();
  }

  void addDeptList(String name) {
    _deptList.add(name);
    notifyListeners();
  }

  void addSubjects(String dept, List<String> subjects) {
    if (_subjectList[dept] == null) {
      _subjectList[dept] = [];
    }
    _subjectList[dept]!.addAll(subjects);
    notifyListeners();
  }

  void setDeptlist(List<String> name) {
    _deptList.addAll(name);
    notifyListeners();
  }
}
