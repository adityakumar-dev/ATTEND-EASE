import 'package:attend_ease/Models/attendance_model.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/attendance_provider.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // For date formatting

class ViewAttendancePage extends StatefulWidget {
  const ViewAttendancePage({super.key});

  @override
  _ViewAttendancePageState createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  DateTime selectedDate =
      DateTime.parse(DateTime.now().toString().split(" ")[0]);
  String? selectedDepartment = 'All';
  String? selectedYear = 'All';
  String currentDate = DateTime.now().toString().split(" ")[0];
  List<String> departments = [];
  List<String> years = [];
  List<String> subjects = [];
  List<AttendanceModel> studentList = [];
  late final CurrentStlList currentStlList;
  late final AttendanceProvider attendanceProvider;
  // Function to select a date using date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = DateTime.parse(pickedDate.toString().split(" ")[0]);
        changeStudentList();
        currentDate = selectedDate.toString().split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentStlList = Provider.of<CurrentStlList>(context, listen: false);
      attendanceProvider =
          Provider.of<AttendanceProvider>(context, listen: false);
      setState(() {
        departments = currentStlList.deptList ?? [];
        years = currentStlList.yearList ?? [];
        // print(selectedDate.toString().split(' ')[0]);
        // print(attendanceProvider.attendanceList.keys);

        studentList = attendanceProvider.attendanceList[
                DateTime.parse(selectedDate.toString().split(' ')[0])] ??
            [];
        // print(studentList.first.subject);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentStlList = Provider.of<CurrentStlList>(context);
    currentDate = selectedDate.toString().split(" ")[0];
    // If the list data is not yet available, show CircularProgressIndicator
    if (currentStlList.deptList == null || currentStlList.yearList == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: softBlue,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(),
          const SizedBox(height: 16),
          _buildDepartmentSelector(),
          const SizedBox(height: 16),
          _buildYearSelector(),
          // const SizedBox(height: 16),
          // _buildSubjectSelector(),
          const SizedBox(height: 16),
          _buildAttendanceList(),
        ],
      ),
    );
  }

  // Date selector
  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              "Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void changeStudentList() {
    if (attendanceProvider.attendanceList[selectedDate] != null) {
      if (selectedDepartment == 'All' && selectedYear == 'All') {
        studentList = attendanceProvider.attendanceList[selectedDate]!;
      } else if (selectedDepartment != 'All' && selectedYear == 'All') {
        studentList = attendanceProvider.attendanceList[selectedDate]!
            .where((el) => el.department == selectedDepartment)
            .toList();
      } else if (selectedDepartment != 'All' && selectedYear != 'All') {
        studentList = attendanceProvider.attendanceList[selectedDate]!
            .where((el) =>
                el.department == selectedDepartment && el.year == selectedYear)
            .toList();
      } else if (selectedDepartment == 'All' && selectedYear != 'All') {
        studentList = attendanceProvider.attendanceList[selectedDate]!
            .where((el) => el.year == selectedYear)
            .toList();
      } else {
        studentList = attendanceProvider.attendanceList[selectedDate]!;
      }
    } else {
      studentList = List.empty();
    }
  }

  // Department selector dropdown
  Widget _buildDepartmentSelector() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Select Department",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: selectedDepartment,
      items: departments.map((String dept) {
        return DropdownMenuItem<String>(
          value: dept,
          child: Text(dept),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDepartment = value;

          changeStudentList();
        });
      },
    );
  }

  // Year selector dropdown
  Widget _buildYearSelector() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Select Year",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: selectedYear,
      items: years.map((String year) {
        return DropdownMenuItem<String>(
          value: year,
          child: Text(year),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value;
        });
      },
    );
  }

  // Attendance records list (replace with real data)
  Widget _buildAttendanceList() {
    return Expanded(
      child: ListView.builder(
        itemCount: studentList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: () =>
                  showStudentAttendanceDialog(context, studentList[index]),
              leading: Icon(Icons.person, color: Colors.blue[300]),
              title: Text("Student ${studentList[index].name}"),
              subtitle: Text("Roll Number : ${studentList[index].rollNumber}"),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}

void showStudentAttendanceDialog(
    BuildContext context, AttendanceModel student) {
  List<String> subjects = student.subject.keys.toList();

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title: Student Attendance
            const Text(
              'Student Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Student Info Section
            _buildStudentInfo("Name", student.name),
            _buildStudentInfo("Roll Number", student.rollNumber),
            _buildStudentInfo("Department", student.department),
            _buildStudentInfo("Year", student.year),
            _buildStudentInfo(
                "Date", DateFormat('dd/MM/yyyy').format(student.date)),

            const SizedBox(height: 10),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 10),

            // Attendance Details
            Text(
              'Subjects and Attendance:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // List of subjects and attendance status
            ...List.generate(subjects.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subjects[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: student.subject[subjects[index]] == 'Present'
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        student.subject[subjects[index]]!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: student.subject[subjects[index]] == 'Present'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            // Close Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Widget to display student information rows
Widget _buildStudentInfo(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
