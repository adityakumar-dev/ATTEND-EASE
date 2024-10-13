import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/attendance_provider.dart';
import 'package:attend_ease/services/providers/student_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  static const String rootName = "AttendanceScreen";
  final args;
  const AttendanceScreen({super.key, required this.args});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late final StudentListProvider stl;
  late final String dep;
  late final String year;
  late final String subject;
  late final String dateTime;
  List<Student> studentList = [];
  List<String?> isPresent = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dep = widget.args['dep']!;
    year = widget.args['year']!;
    dateTime = widget.args['date']!.toString().split(' ')[0];
    subject = widget.args['subject'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        stl = Provider.of<StudentListProvider>(context, listen: false);
        if (stl.studentData[year] != null) {
          studentList = stl.studentData[year]!
                  .where((st) => st.department == dep)
                  .toList() ??
              [];
        }
        if (studentList.isEmpty) {
          studentList = [];
        }
        isPresent = List.generate(studentList.length, (index) => null);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${subject.toUpperCase()} | ${dep.toUpperCase()} | $year",
          style: kTextStyle(ksize16, whiteColor, true),
        ),
        backgroundColor: softBlue,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
      ),
      body: studentList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateAndInfo(),
                  const SizedBox(height: 20),
                  _buildStudentList(),
                  const SizedBox(height: 20),
                  _buildMarkAttendanceButton(),
                ],
              ),
            )
          : const Center(
              child: Text("Student List is empty"),
            ),
    );
  }

  Widget _buildDateAndInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Date: $dateTime",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (studentList.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.person_off,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              "No students available.",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: studentList.length,
        itemBuilder: (context, index) {
          Student student = studentList[index];
          return Card(
            elevation: 6,
            shadowColor: softBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              trailing: _buildAttendanceDropdown(index),
              title: Text(
                student.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
              ),
              subtitle: Text(
                "Roll Number: ${student.rollNumber}",
                style: const TextStyle(fontSize: 14, color: greyColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceDropdown(int index) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: lavender,
          border: Border.all(color: softBlue),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isPresent[index] != null ? isPresent[index]! : "Choose Action",
          style: TextStyle(
            color: isPresent[index] != null ? coral : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(
          value: "Present",
          child: Text("Present"),
        ),
        const PopupMenuItem(
          value: "Leave",
          child: Text("Leave"),
        ),
        const PopupMenuItem(
          value: "Absent",
          child: Text("Absent"),
        ),
      ],
      onSelected: (value) {
        setState(() {
          isPresent[index] = value;
        });
      },
    );
  }

  Widget _buildMarkAttendanceButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _markAttendance();
          final AttendanceProvider attendanceProvider =
              Provider.of<AttendanceProvider>(context, listen: false);
          for (int i = 0; i < studentList.length; i++) {
            attendanceProvider.addAttendance(
              DateTime.parse(dateTime),
              studentList[i],
              subject,
              isPresent[i] ?? "Absent",
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: softBlue,
          shadowColor: Colors.black45,
          elevation: 8,
        ),
        child: const Text(
          "Mark Attendance",
          style: TextStyle(
            fontSize: 16,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _markAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Attendance marked successfully!"),
        backgroundColor: lightGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
