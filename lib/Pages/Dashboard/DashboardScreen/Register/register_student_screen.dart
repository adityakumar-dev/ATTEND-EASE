import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
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
  String nameValue = "";
  String rollValue = "";
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
        centerTitle: true,
        title: Text(
          "Register Student",
          style: kTextStyle(ksize24, whiteColor, true),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [softBlue, Colors.blueAccent.withOpacity(0.3)])),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNameField(softBlue),
            height10,
            _buildRollNumberField(greenColor),
            height10,
            _buildDropdownField("Select Year", selectedYear, years, (value) {
              setState(() {
                selectedYear = value;
              });
            }, Colors.orange),
            height10,
            _buildDropdownField("Select Department", selectedDept, dep,
                (value) {
              setState(() {
                selectedDept = value;
              });
            }, Colors.purple),
            heightBox(20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: softBlue,
                // onPrimary: whiteColor,
                backgroundColor: softBlue,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: rollValue.isNotEmpty &&
                      nameValue.isNotEmpty &&
                      selectedDept != null &&
                      selectedYear != null
                  ? () {
                      // Add student to the provider
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
              child: Text(
                'Add Student',
                style: kTextStyle(
                    ksize16,
                    rollValue.isNotEmpty &&
                            nameValue.isNotEmpty &&
                            selectedDept != null &&
                            selectedYear != null
                        ? whiteColor
                        : blackColor,
                    true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: softBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(Color color) {
    return TextField(
      controller: name,
      onChanged: (v) {
        setState(() {
          nameValue = v;
        });
      },
      decoration: InputDecoration(
        labelText: 'Student Name',
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: whiteColor,
            ),
            borderRadius: BorderRadius.circular(12)),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: color.withOpacity(0.1),
      ),
      // keyboardType: TextInputType.number,
    );
  }

  Widget _buildRollNumberField(Color color) {
    return TextField(
      onChanged: (v) {
        setState(() {
          rollValue = v;
        });
      },
      controller: rollNumber,
      decoration: InputDecoration(
        labelText: 'Roll Number',
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: color.withOpacity(0.1),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdownField(String hint, String? value, List<String> items,
      ValueChanged<String?> onChanged, Color color) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Select Year",
        fillColor: color.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: value,
      hint: Text(hint),
      items: items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
