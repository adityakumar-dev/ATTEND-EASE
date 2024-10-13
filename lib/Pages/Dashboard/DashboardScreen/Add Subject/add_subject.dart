import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSubjectScreen extends StatefulWidget {
  static const String rootName = "AddSubjectScreen";
  const AddSubjectScreen({super.key});

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
        centerTitle: true,
        title: Text(
          "Add Subjects",
          style: kTextStyle(ksize24, whiteColor, true),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [softBlue, Colors.blueAccent.withOpacity(0.1)],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
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
                  child: Text(stl.deptList[index + 1]),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;

                  if (stl.subjectList[selectedDepartment] != null) {
                    if (stl.subjectList[selectedDepartment]!.isNotEmpty) {
                      subjectCount =
                          stl.subjectList[selectedDepartment]!.length;
                      for (int i = 0; i < subjectCount; i++) {
                        subjectControllers[i].text =
                            stl.subjectList[selectedDepartment]![i];
                      }
                    }
                  } else {
                    subjectCount = 1;
                    subjectControllers.removeRange(
                        1, subjectControllers.length);
                    subjectControllers[0].text = '';
                  }
                });
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
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: ksize10, vertical: ksize10),
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(width: 1),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (index == subjectControllers.length - 1)
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.blue),
                                onPressed: () {
                                  if (subjectControllers[index]
                                      .text
                                      .isNotEmpty) {
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
                                icon:
                                    const Icon(Icons.remove, color: Colors.red),
                                onPressed: () => removeSubjectField(index),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Save button
            if (selectedDepartment != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: ksize16, vertical: ksize10),
                  decoration: BoxDecoration(
                      color: softBlue,
                      borderRadius: BorderRadius.circular(ksize12)),
                  child: InkWell(
                    onTap: () {
                      List<String> subjects = subjectControllers
                          .map((controller) => controller.text.trim())
                          .where((subject) => subject.isNotEmpty)
                          .toSet()
                          .toList();

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
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save Subjects",
                      style: kTextStyle(ksize16, whiteColor, true),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
