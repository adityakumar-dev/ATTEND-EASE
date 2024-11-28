import 'dart:convert';
import 'dart:io';
import 'package:attend_ease/Models/attendance_model.dart';
import 'package:attend_ease/Models/image/teacherImageModel.dart';
import 'package:attend_ease/Models/student_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class LocalStorageManager {
  static const String _localData = "localData";
  static const String _studentList = "studentList";
  static const String _attendanceList = "attendanceList";
  static const String _subjectList = "subjectList";
  static const String _depList = "depList";
  static const String _currentList = "currentList";
  static const String _yearList = "yearList";
  static const String _teacherImage = "teacherImage";
  // Check if the box is already open, otherwise open it
  static Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_localData)) {
      return await Hive.openBox(_localData);
    } else {
      return Hive.box(_localData);
    }
  }

  // Store attendance data
  static Future<void> storeAttendanceData(
      Map<DateTime, List<AttendanceModel>> attendanceList) async {
    final box = await _getBox();
    await box.put(
      _attendanceList,
      attendanceList,
    );
  }

  static Future<TeacherImageModel?> getTeacherImage() async {
    final box = await _getBox();

    final data = box.get(_teacherImage, defaultValue: null);
    if (data == null) {
      return null;
    }
    if (kDebugMode) {
      print("data is not null");
    }
    return data as TeacherImageModel;
  }

  static Future<void> teacherImage(TeacherImageModel model) async {
    final box = await _getBox();
    await box.put(_teacherImage, model);
  }

  // Store student list
  static Future<void> storeStudentList(
      Map<String, List<Student>> studentList) async {
    final box = await _getBox();

    await box.put(
      _studentList,
      studentList,
    );
  }

  // Store current list, department list, and subject list
  static Future<void> storeCurrentStl(List currentListData, List depListData,
      List years, Map subjectListData) async {
    final box = await _getBox();
    await box.put(_currentList, jsonEncode(currentListData));
    await box.put(_depList, jsonEncode(depListData));
    await box.put(_subjectList, jsonEncode(subjectListData));
    await box.put(_yearList, jsonEncode(years));
  }

  // Retrieve stored data
  static Future<Map<String, dynamic>> getStoredData() async {
    final box = await _getBox();
    Map<String, dynamic> data = {};

    data[_studentList] = box.get(_studentList, defaultValue: '{}');

    data[_attendanceList] = (box.get(_attendanceList, defaultValue: '{}'));
    data[_currentList] = jsonDecode(box.get(_currentList, defaultValue: '[]'));
    data[_depList] = jsonDecode(box.get(_depList, defaultValue: '[]'));
    data[_subjectList] = jsonDecode(box.get(_subjectList, defaultValue: '{}'));
    data[_yearList] = jsonDecode(box.get(_yearList, defaultValue: '[]'));
    data['userName'] = box.get('userName', defaultValue: "Teacher Name");
    data['position'] = box.get('position', defaultValue: "Position");

    return data;
  }

  static Future storeTeacherName(txt) async {
    final box = await _getBox();
    box.put('userName', txt);
  }

  static Future storeTeacherPosition(txt) async {
    final box = await _getBox();
    box.put('position', txt);
  }
}
