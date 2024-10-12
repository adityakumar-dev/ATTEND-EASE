import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:attend_ease/services/providers/student_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterStudentScreen extends StatefulWidget {
  static const String rootName = "RegisterStudent";
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  late CurrentStlList stl;
  List<String> years = [];
  List<String> dep = [];

  // Separate variables for year and department selection
  String? selectedYear;
  String? selectedDept;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access Provider data in a safe manner here.
    stl = Provider.of<CurrentStlList>(context, listen: true);

    setState(() {
      years = stl.yearList.sublist(1);
      dep = stl.deptList.sublist(1);
    });
  }

  TextEditingController name = TextEditingController();
  TextEditingController rollNumber = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    name.dispose();
    rollNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: name,
            ),
            TextField(
              controller: rollNumber,
              decoration: const InputDecoration(labelText: 'Roll Number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              width: size.width,
              child: DropdownButtonFormField<String>(
                value: selectedYear,
                hint: const Text('Select Year'),
                items: List.generate(
                  years.length,
                  (index) => DropdownMenuItem(
                    value: years[index],
                    child: Text(years[index]),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a year' : null,
              ),
            ),
            SizedBox(
              width: size.width,
              child: DropdownButtonFormField<String>(
                value: selectedDept,
                hint: const Text('Select Department'),
                items: List.generate(
                  dep.length,
                  (index) => DropdownMenuItem(
                    value: dep[index],
                    child: Text(dep[index]),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedDept = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a department' : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: rollNumber.text.isNotEmpty &&
                      name.text.isNotEmpty &&
                      selectedDept != null &&
                      selectedYear != null
                  ? () {
                      // Add student to the provider
                      // final CurrentStlList currentList =
                      //     Provider.of<CurrentStlList>(context, listen: false);
                      // final index = currentList.deptList
                      //     .indexWhere((el) => el == _selectedDepartment);
                      // if (index == -1) {
                      //   currentList.addDeptList(_selectedDepartment!);
                      // }

                      Provider.of<StudentListProvider>(context, listen: false)
                          .addStudent(
                              selectedYear!,
                              Student(
                                  uniqueId: const Uuid().v4(),
                                  rollNumber: rollNumber.text,
                                  name: name.text,
                                  year: selectedYear!,
                                  department: selectedDept!));

                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}
