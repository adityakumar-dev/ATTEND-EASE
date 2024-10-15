// ignore_for_file: use_build_context_synchronously

import 'package:attend_ease/Models/attendance_model.dart';
import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/Pages/Dashboard/home_scree.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/local%20storage/local_storage_manager.dart';
import 'package:attend_ease/services/providers/attendance_provider.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:attend_ease/services/providers/student_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String rootName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future initLocal() async {
    final data = await LocalStorageManager.getStoredData();
    // print(data['studentList']['2024'][0].name);

    return data;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await initLocal();
      // data['']
      final StudentListProvider studentList =
          Provider.of<StudentListProvider>(context, listen: false);
      final CurrentStlList currentStl =
          Provider.of<CurrentStlList>(context, listen: false);
      final AttendanceProvider attendanceList =
          Provider.of<AttendanceProvider>(context, listen: false);
      if (data['studentList'] != '{}') {
        // print("data is : ${data['studentList']}");
        final Map<String, List<Student>> studentData =
            (data['studentList'] as Map).map<String, List<Student>>(
          (key, value) {
            return MapEntry(
              key.toString(),
              (value as List).map((val) => val as Student).toList(),
            );
          },
        );
        if (studentData.isNotEmpty) {
          studentList.setStudentList(studentData);
        }
      }

      if (data['depList'] != '[]') {
        final dep =
            (data['depList'] as List).map((value) => value as String).toList();
        if (dep.contains('All')) {
          currentStl.setDeptlist(dep);
        } else {
          dep.insert(0, 'All');
          currentStl.setDeptlist(dep);
        }
      } else {
        currentStl.setDeptlist(['All']);
      }
      if (data['currentList'] != '[]') {
        currentStl.setList((data['currentList'] as List)
            .map((value) => value as Student)
            .toList());
      }
      if (data['subjectList'] != '{}') {
        currentStl.setSubjects(
          (data['subjectList'] as Map).map(
            (key, value) => MapEntry(
              key,
              (value as List).map((val) => val as String).toList(),
            ),
          ),
        );
      }
      if (data['attendanceList'] != '{}') {
        attendanceList.setAttendance(
          (data['attendanceList'] as Map).map(
            (key, value) => MapEntry(
              DateTime.parse(key.toString()),
              (value as List).map((val) => val as AttendanceModel).toList(),
            ),
          ),
        );
      }
      print(data['yearList']);
      if (data['yearList'] != '[]') {
        final List<String> y =
            (data['yearList'] as List).map((value) => value as String).toList();
        if (y.contains('All')) {
          currentStl.setYears(y);
        } else {
          y.insert(0, 'All');
          currentStl.setYears(y);
        }
      } else {
        currentStl.setYears(['All']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacementNamed(context, HomeScreen.rootName);
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
