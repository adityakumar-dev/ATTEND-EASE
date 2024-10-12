import 'package:attend_ease/Models/attendance_model.dart';
import 'package:attend_ease/Models/student_model.dart';
import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  Map<DateTime, List<AttendanceModel>> _attendanceList = {};

  Map<DateTime, List<AttendanceModel>> get attendanceList => _attendanceList;

  // void markAttendance(
  //   DateTime date,
  //   AttendanceModel attendance,
  // ) {
  //   if (_attendanceList[date] == null) {
  //     _attendanceList[date] = [];
  //   }

  //   int index = _attendanceList[date]!
  //       .indexWhere((el) => el.studentId == attendance.studentId);

  //   if (index != -1) {
  //     _attendanceList[date]![index] = attendance;
  //   } else {
  //     _attendanceList[date]!.add(attendance);
  //   }

  //   notifyListeners();
  // }

  void addAttendance(
      DateTime date, Student st, String subject, bool isPresent) {
    if (_attendanceList[date] == null) {
      _attendanceList[date] = [];
    }

    int index =
        _attendanceList[date]!.indexWhere((el) => el.studentId == st.uniqueId);

    if (index != -1) {
      _attendanceList[date]![index].subject[subject] = isPresent;
    } else {
      _attendanceList[date]!.add(AttendanceModel(
        year: st.year,
        department: st.department,
        studentId: st.uniqueId,
        date: date,
        subject: {subject: isPresent},
      ));
    }

    notifyListeners();
  }

  List<AttendanceModel> getAttendanceByStudentId(String id) {
    List<AttendanceModel> stData = [];

    for (DateTime date in _attendanceList.keys) {
      var attendance = _attendanceList[date]!.where((el) => el.studentId == id);
      if (attendance.isNotEmpty) {
        stData.addAll(attendance);
      }
    }

    return stData;
  }

  // List<AttendanceModel> getAttendanceByStudent(String studentId) {
  //   return _attendanceList.where((att) => att.studentId == studentId).toList();
  // }

  // List<AttendanceModel> getAttendanceByDate(DateTime date) {
  //   return _attendanceList.where((att) => att.date == date).toList();
  // }

  // List<AttendanceModel> getAttendanceByYearAndDepartment({
  //   required String uuid,
  //   required String year,
  //   required String department,
  // }) {
  //   return _attendanceList
  //       .where((att) =>
  //           att.studentId == uuid &&
  //           att.department == department &&
  //           att.year == year)
  //       .toList();
  // }

  // void updateAttendance(
  //     String studentId, DateTime date, bool isPresent, String subject) {
  //   final index = _attendanceList
  //       .indexWhere((att) => att.studentId == studentId && att.date == date);
  //   if (index != -1) {
  //     _attendanceList[index].subject[subject] = isPresent;
  //     notifyListeners();
  //   }
  // }

  // void markAttendanceForDay({
  //   required String id,
  //   required String year,
  //   required DateTime date,
  //   required String subject,
  //   required String department,
  //   required bool isPresent,
  // }) {
  //   // Attempt to find existing attendance for the student on that date
  //   final existingAttendance = _attendanceList.firstWhere(
  //     (att) => att.studentId == id && att.date == date,
  //     orElse: () => AttendanceModel(
  //       year: year,
  //       department: department,
  //       studentId: id,
  //       date: date,
  //       subject: {},
  //     ),
  //   );

  //   if (existingAttendance.subject.isNotEmpty) {
  //     if (existingAttendance.subject.containsKey(subject)) {
  //       existingAttendance.subject[subject] = isPresent;
  //     } else {
  //       existingAttendance.subject[subject] = isPresent;
  //     }
  //   } else {
  //     _attendanceList.add(AttendanceModel(
  //       year: year,
  //       department: department,
  //       studentId: id,
  //       date: date,
  //       subject: {subject: isPresent},
  //     ));
  //   }

  //   notifyListeners();
  // }
}
