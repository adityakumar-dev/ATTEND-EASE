import 'package:attend_ease/Pages/Attendance/attendance_screen.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarkAttendancePage extends StatefulWidget {
  @override
  _MarkAttendancePageState createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  DateTime selectedDate = DateTime.now();
  String? selectedDepartment;
  String? selectedYear;
  String? selectedSubject;

  late CurrentStlList currentList;
  late List<String> departments;
  late List<String> years;
  late List<String> subjects;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentList = Provider.of<CurrentStlList>(context);
    departments = currentList.deptList.sublist(1);
    years = currentList.yearList.sublist(1);
    subjects = [];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: ksize20, vertical: ksize20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: ksize20),
            _buildDepartmentSelector(),
            if (departments.isEmpty) _buildNoDepartmentWarning(),
            const SizedBox(height: ksize20),
            _buildSubjectSelector(),
            if (subjects.isEmpty) _buildNoSubjectWarning(),
            const SizedBox(height: ksize20),
            _buildYearSelector(),
            if (years.isEmpty) _buildNoYearWarning(),
            const SizedBox(height: ksize30),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  // Date Selector widget
  Widget _buildDateSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.blue),
        title: Text(
          "Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }

  // Department Selector widget
  Widget _buildDepartmentSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.account_balance,
            color: departments.isNotEmpty ? Colors.blue : softGrey),
        title: Text(
          selectedDepartment ?? "Select Department",
          style: kTextStyle(
              ksize14, departments.isNotEmpty ? blackColor : softGrey, false),
        ),
        trailing: Icon(Icons.arrow_drop_down,
            color: departments.isNotEmpty ? blackColor : softGrey),
        onTap: departments.isNotEmpty
            ? () {
                _showDepartmentDialog(context, currentList.subjectList);
              }
            : null,
      ),
    );
  }

  // Subject Selector widget
  Widget _buildSubjectSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.school_outlined,
            color: subjects.isNotEmpty ? Colors.blue : softGrey),
        title: Text(
          selectedSubject ?? "Select Subject",
          style: kTextStyle(
              ksize14, subjects.isNotEmpty ? blackColor : softGrey, false),
        ),
        trailing: Icon(Icons.school_outlined,
            color: subjects.isNotEmpty ? blackColor : softGrey),
        onTap: subjects.isNotEmpty ? () => _showSubjectDialog(context) : null,
      ),
    );
  }

  // Year Selector widget
  Widget _buildYearSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.school,
            color: years.isNotEmpty ? Colors.blue : softGrey),
        title: Text(
          selectedYear ?? "Select Year",
          style: kTextStyle(
              ksize14, years.isNotEmpty ? blackColor : softGrey, false),
        ),
        trailing: Icon(Icons.arrow_drop_down,
            color: years.isNotEmpty ? blackColor : softGrey),
        onTap: years.isNotEmpty ? () => _showYearDialog(context) : null,
      ),
    );
  }

  // Confirm Button widget
  Widget _buildConfirmButton() {
    return Center(
      child: ElevatedButton(
        onPressed: (selectedDepartment == null ||
                selectedYear == null ||
                selectedSubject == null)
            ? null
            : () {
                Navigator.pushNamed(context, AttendanceScreen.rootName,
                    arguments: {
                      'date': selectedDate,
                      'dep': selectedDepartment,
                      'subject': selectedSubject,
                      'year': selectedYear
                    });
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              horizontal: ksize40, vertical: ksize14),
          textStyle: kTextStyle(ksize16, Colors.white, true),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text("Mark Attendance"),
      ),
    );
  }

  // Warning for no departments
  Widget _buildNoDepartmentWarning() {
    return Padding(
      padding: const EdgeInsets.only(top: ksize10),
      child: Text(
        "Please add a Department from Register Page",
        style: kTextStyle(ksize12, redColor, false),
      ),
    );
  }

  // Warning for no subjects
  Widget _buildNoSubjectWarning() {
    return Text(
      "Please add Subject from registration page or select department",
      style: kTextStyle(ksize10, redColor, false),
    );
  }

  // Warning for no years
  Widget _buildNoYearWarning() {
    return Padding(
      padding: const EdgeInsets.only(top: ksize10),
      child: Text(
        "Please add years from Register Page",
        style: kTextStyle(ksize12, redColor, false),
      ),
    );
  }

  // Subject selection dialog
  void _showSubjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Select Subject"),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(subjects[index]),
                  onTap: () {
                    setState(() {
                      selectedSubject = subjects[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Department selection dialog
  void _showDepartmentDialog(
      BuildContext context, Map<String, List<String>> map) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Select Department"),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: departments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(departments[index]),
                  onTap: () {
                    setState(() {
                      selectedDepartment = departments[index];
                      if (map[selectedDepartment] != null) {
                        subjects = map[selectedDepartment]!;
                      } else {
                        subjects = [];
                      }
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Year selection dialog
  void _showYearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Select Year"),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: years.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(years[index]),
                  onTap: () {
                    setState(() {
                      selectedYear = years[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
