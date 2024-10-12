import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/services/providers/attendance_provider.dart';
import 'package:attend_ease/services/providers/student_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  static const String rootName = "AttendanceScreen";
  final args; // Typing for args (Map)
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

    // Fetch the student list for the selected department and year
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        stl = Provider.of<StudentListProvider>(context, listen: false);
        studentList =
            stl.studentData[year]!.where((st) => st.department == dep).toList();
        isPresent = List.generate(studentList.length, (index) => null);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance - $dep ($year)"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
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
      ),
    );
  }

  Widget _buildDateAndInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date: $dateTime",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Students List",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
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
            elevation: 4,
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
                ),
              ),
              subtitle: Text(
                "Roll Number : ${student.rollNumber}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isPresent[index] != null ? isPresent[index]! : "Choose Action",
          style: TextStyle(
            color: isPresent[index] != null ? Colors.teal : Colors.black54,
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
          // final AttendanceProvider provider =
          //     Provider.of<AttendanceProvider>(context);
          // provider.addAttendance(DateTime.parse(dateTime), , subject, isPresent)
          final attendanceProvider = Provider.of<AttendanceProvider>(context);
          for (int i = 0; i < studentList.length; i++) {}
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.teal,
        ),
        child: const Text(
          "Mark Attendance",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _markAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Attendance marked successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
