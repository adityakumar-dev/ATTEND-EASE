import 'package:attend_ease/Pages/Attendance/attendance_screen.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      lastDate: DateTime.now(),
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
            buildAttendanceCard(context,
                title: "Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                icon: Icons.calendar_today,
                onTap: () => _selectDate(context),
                color: Colors.blueAccent),
            const SizedBox(height: ksize20),
            buildAttendanceCard(context,
                title: selectedDepartment == null
                    ? "Select Department"
                    : "Department : $selectedDepartment",
                icon: Icons.account_balance,
                onTap: () =>
                    _showDepartmentDialog(context, currentList.subjectList),
                color: Colors.green),
            if (departments.isEmpty)
              _buildWarning("Please add a Department from Register Page"),
            const SizedBox(height: ksize20),
            // _buildSubjectSelector(),
            buildAttendanceCard(context,
                title: selectedSubject == null
                    ? "Select Subject"
                    : "Subject : $selectedSubject",
                icon: Icons.school_outlined,
                onTap: subjects.isNotEmpty
                    ? () => _showDialog(context, "Select Subject",
                            subjects.length, subjects, (index) {
                          setState(() {
                            selectedSubject = subjects[index];
                          });
                          Navigator.pop(context);
                        })
                    : null,
                color: Colors.orange),
            if (subjects.isEmpty)
              _buildWarning(
                  "Please add Subject from registration page or select department"),
            const SizedBox(height: ksize20),
            // _buildYearSelector(),
            buildAttendanceCard(context,
                title: selectedYear == null
                    ? "Select Year"
                    : "Year : $selectedYear",
                icon: Icons.school_sharp,
                onTap: years.isNotEmpty ? () => _showYearDialog(context) : null,
                color: Colors.purple),
            if (years.isEmpty)
              _buildWarning(
                "Please add years from Register Page",
              ),
            const SizedBox(height: ksize30),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget buildAttendanceCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Function()? onTap,
      required Color color}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.1),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            backgroundColor: softBlue),
        child: Text(
          "Mark Attendance",
          style: kTextStyle(
              ksize16,
              selectedDepartment == null ||
                      selectedYear == null ||
                      selectedSubject == null
                  ? greyColor
                  : whiteColor,
              true),
        ),
      ),
    );
  }

  // Warning for no subjects
  Widget _buildWarning(String warning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_outlined,
            size: 24,
            color: greyColor,
          ),
          width10,
          Expanded(
            child: Text(
              warning,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: kTextStyle(ksize10, greyColor, false),
            ),
          ),
        ],
      ),
    );
  }

// Subject selection dialog
  void _showDialog(BuildContext context, String title, int length,
      List<String> list, Function(int index) onPress) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              onPress(index);
                            },
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[100],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  list[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const Divider()
                        ],
                      );
                    },
                  ),
                ),
              ],
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





// // Department Selector widget
// Widget _buildDepartmentSelector() {
//   return Card(
//     elevation: 4,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: ListTile(
//       leading: Icon(Icons.account_balance,
//           color: departments.isNotEmpty ? Colors.blue : softGrey),
//       title: Text(
//         selectedDepartment ?? "Select Department",
//         style: kTextStyle(
//             ksize14, departments.isNotEmpty ? blackColor : softGrey, false),
//       ),
//       trailing: Icon(Icons.arrow_drop_down,
//           color: departments.isNotEmpty ? blackColor : softGrey),
//       onTap: departments.isNotEmpty
//           ? () {
//               _showDepartmentDialog(context, currentList.subjectList);
//             }
//           : null,
//     ),
//   );
// }

// // Subject Selector widget
// Widget _buildSubjectSelector() {
//   return Card(
//     elevation: 4,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: ListTile(
//       leading: Icon(Icons.school_outlined,
//           color: subjects.isNotEmpty ? Colors.blue : softGrey),
//       title: Text(
//         selectedSubject ?? "Select Subject",
//         style: kTextStyle(
//             ksize14, subjects.isNotEmpty ? blackColor : softGrey, false),
//       ),
//       trailing: Icon(Icons.school_outlined,
//           color: subjects.isNotEmpty ? blackColor : softGrey),
//       onTap: subjects.isNotEmpty ? () => _showSubjectDialog(context) : null,
//     ),
//   );
// }

// // Year Selector widget
// Widget _buildYearSelector() {
//   return Card(
//     elevation: 4,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: ListTile(
//       leading:
//           Icon(Icons.school, color: years.isNotEmpty ? Colors.blue : softGrey),
//       title: Text(
//         selectedYear ?? "Select Year",
//         style: kTextStyle(
//             ksize14, years.isNotEmpty ? blackColor : softGrey, false),
//       ),
//       trailing: Icon(Icons.arrow_drop_down,
//           color: years.isNotEmpty ? blackColor : softGrey),
//       onTap: years.isNotEmpty ? () => _showYearDialog(context) : null,
//     ),
//   );
// }
