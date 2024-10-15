import 'package:attend_ease/Models/student_model.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:attend_ease/services/providers/student_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({super.key});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  String? yearListDropDown = 'All';
  String? depListDropDown = 'All';
  late final StudentListProvider stl;
  late CurrentStlList currentList;
  List<Student> allStudent = [];
  late List<DropdownMenuItem<String>> deptDropDownList;
  late List<DropdownMenuItem<String>> itemList;
  @override
  void initState() {
    super.initState();

    // Initialize dropdowns on first load

    WidgetsBinding.instance.addPostFrameCallback((_) {
      stl = Provider.of<StudentListProvider>(context, listen: false);
      currentList = Provider.of<CurrentStlList>(context, listen: false);
      if (currentList.yearList.isNotEmpty) {
        yearListDropDown = currentList.yearList[0];
      }

      if (currentList.deptList.isNotEmpty) {
        depListDropDown = currentList.deptList[0];
      }
      setState(() {
        for (String st in stl.studentData.keys) {
          // print("$st , value : ${stl.studentData[st]}");

          allStudent.addAll(stl.studentData[st] ?? []);
        }
        // List<Student> studentWithYear = [];
        // if (yearListDropDown != 'All') {
        //   studentWithYear.addAll(stl.studentData[yearListDropDown] ?? []);
        // }

        deptDropDownList = List.generate(
          currentList.deptList.length,
          (index) => DropdownMenuItem(
              value: currentList.deptList[index],
              child: Text(currentList.deptList[index])),
        );
        itemList = List.generate(
          currentList.yearList.length,
          (index) {
            return DropdownMenuItem(
                value: currentList.yearList[index],
                child: Text(currentList.yearList[index]));
          },
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    if (allStudent.isEmpty) {
      return const Center(child: Text('No students available.'));
    }

    void generateList() {
      if (yearListDropDown == 'All') {
        if (depListDropDown != 'All') {
          currentList.setList(allStudent
              .where((el) => el.department == depListDropDown)
              .toList());
        } else {
          currentList.setList(allStudent ?? []);
        }
      } else {
        if (depListDropDown == 'All') {
          currentList.setList(stl.studentData[yearListDropDown]!);
        } else {
          currentList.setList(stl.studentData[yearListDropDown]!
                  .where((el) => el.department == depListDropDown)
                  .toList() ??
              []);
        }
      }
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: ksize10, vertical: ksize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ksize16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Year",
                      style: kTextStyle(ksize16, blackColor, true),
                    ),
                    widthBox(ksize20),
                    DropdownButton<String>(
                      items: itemList,
                      onChanged: (String? value) {
                        setState(() {
                          yearListDropDown = value;
                          generateList();
                        });

                        // if (yearListDropDown == 'All') {
                        //   if (depListDropDown != 'All') {
                        //     currentList.setList(allStudent
                        //         .where((el) => el.department == depListDropDown)
                        //         .toList());
                        //   } else {
                        //     currentList.setList(allStudent ?? []);
                        //   }
                        // } else {
                        //   if (depListDropDown == 'All') {
                        //     currentList.setList(
                        //         stl.studentData[yearListDropDown] ?? []);
                        //   } else {
                        //     currentList.setList(stl
                        //         .studentData[yearListDropDown]!
                        //         .where((el) => el.department == depListDropDown)
                        //         .toList());
                        //   }
                        // }
                      },
                      value: yearListDropDown,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Department",
                        style: kTextStyle(ksize16, blackColor, true)),
                    widthBox(ksize20),
                    DropdownButton(
                        value: depListDropDown,
                        items: deptDropDownList,
                        onChanged: (value) {
                          setState(() {
                            depListDropDown = value;
                            generateList();
                          });
                        }),
                  ],
                )
              ],
            ),
          ),
          // const SizedBox(height: 20),
          Expanded(
            child: Consumer<CurrentStlList>(
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: value.currentList.length,
                  itemBuilder: (context, index) {
                    final student = value.currentList[index];
                    // List<Color> colors = [
                    //   softBlue,
                    //   greenColor,
                    //   Colors.orange,
                    //   Colors.purple
                    // ];
                    Color getCardColor() {
                      if (index == 0) {
                        return softBlue;
                      }
                      if (index == 1) {
                        return greenColor;
                      }
                      if (index == 2) {
                        return Colors.orange;
                      }
                      if (index == 3) {
                        return Colors.purple;
                      } else {
                        return softBlue;
                      }
                    }

                    return Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: ksize10, vertical: ksize10),
                        decoration: BoxDecoration(
                            color: getCardColor().withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            student.name.toUpperCase(),
                            style: kTextStyle(ksize20, blackColor, true),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Roll Number: ${student.rollNumber}',
                                style: kTextStyle(ksize16, blackColor, false),
                              ),
                              Text(
                                'Department: ${student.department}',
                                style: kTextStyle(ksize16, blackColor, false),
                              ),
                              Text(
                                'Section: ${student.rollNumber}',
                                style: kTextStyle(ksize16, blackColor, false),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              stl.deleteStudent(uuid: student.uniqueId);
                              setState(() {
                                generateList();
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: blackColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
