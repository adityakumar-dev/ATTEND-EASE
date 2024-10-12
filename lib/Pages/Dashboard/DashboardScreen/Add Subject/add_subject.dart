import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({Key? key}) : super(key: key);

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  String? selectedDepartment;
  List<TextEditingController> subjectControllers = [];
  int subjectCount = 1;

  @override
  void initState() {
    super.initState();
    subjectControllers.add(TextEditingController());
  }

  void addSubjectField() {
    setState(() {
      subjectControllers.add(TextEditingController());
      subjectCount++;
    });
  }

  void removeSubjectField(int index) {
    setState(() {
      if (subjectCount > 1) {
        subjectControllers.removeAt(index);
        subjectCount--;
      }
    });
  }

  @override
  void dispose() {
    for (TextEditingController controller in subjectControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CurrentStlList stl = Provider.of<CurrentStlList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subjects"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for department selection
            DropdownButton<String>(
              value: selectedDepartment,
              hint: const Text('Select Department'),
              isExpanded: true,
              items: List.generate(stl.deptList.length - 1, (index) {
                return DropdownMenuItem(
                    value: stl.deptList[index + 1],
                    child: Text(stl.deptList[index + 1]));
              }),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;

                  print(value);
                });
                if (stl.subjectList[selectedDepartment] != null) {
                  if (stl.subjectList[selectedDepartment]!.isNotEmpty) {
                    subjectCount = stl.subjectList[selectedDepartment]!.length;
                    print(subjectCount);
                    for (int i = 0; i < subjectCount; i++) {
                      subjectControllers[i].text =
                          stl.subjectList[selectedDepartment]![i];
                      subjectControllers.add(TextEditingController());
                    }
                  }
                } else {
                  subjectCount = 1;

                  subjectControllers.removeRange(1, subjectControllers.length);
                  subjectControllers[0].text = '';
                }
              },
            ),
            const SizedBox(height: 20),

            // List of dynamically added subject TextFields
            if (selectedDepartment != null)
              Expanded(
                child: ListView.builder(
                  itemCount: subjectControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          // Subject input field
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Please fill the field";
                                }
                                return null;
                              },
                              controller: subjectControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Subject ${index + 1}',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Add/Remove buttons
                          if (index == subjectControllers.length - 1)
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.blue),
                              onPressed: () {
                                if (subjectControllers[index].text.isNotEmpty) {
                                  addSubjectField();
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please fill the Subject ${index + 1} field'),
                                      ),
                                    );
                                }
                              },
                            ),
                          if (subjectControllers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => removeSubjectField(index),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            // Save button
            if (selectedDepartment != null)
              ElevatedButton(
                onPressed: () {
                  List<String> subjects = subjectControllers
                      .map((controller) => controller.text.trim())
                      .where((subject) => subject.isNotEmpty)
                      .toSet()
                      .toList();
                  print(subjects);

                  if (selectedDepartment == null || subjects.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please select a department and add at least one subject'),
                      ),
                    );
                    return;
                  }

                  // Process the selected subjects
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Subjects added for $selectedDepartment'),
                  ));
                  if (selectedDepartment != null) {
                    stl.addSubjects(selectedDepartment!, subjects);
                  }
                  // Clear the fields (Optional)
                  setState(() {
                    for (var controller in subjectControllers) {
                      controller.clear();
                    }
                    selectedDepartment = null;
                  });
                  print(stl.subjectList);
                  Navigator.pop(context);
                },
                child: const Text("Save Subjects"),
              ),
          ],
        ),
      ),
    );
  }
}
