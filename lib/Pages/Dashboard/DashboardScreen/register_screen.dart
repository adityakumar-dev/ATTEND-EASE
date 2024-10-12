import 'package:attend_ease/Pages/Dashboard/DashboardScreen/Add%20Subject/add_subject.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/Register/register_student_screen.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentStlList currentStlList = Provider.of<CurrentStlList>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose an option",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // ListTile for Register Student
          ListTile(
            leading: const Icon(Icons.person_add, color: Colors.blue),
            title: const Text("Register Student"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, RegisterStudentScreen.rootName);
            },
          ),
          const Divider(),

          // ListTile for Add New Department
          ListTile(
            leading: const Icon(Icons.business, color: Colors.green),
            title: const Text("Add New Department"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              addNewField(context, "dept");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.orange),
            title: const Text("Add Year"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              addNewField(context, "year");
            },
          ),
          const Divider(),
          if (currentStlList.deptList.length > 1)
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.orange),
              title: const Text("Add Subject"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSubjectScreen(),
                    ));
              },
            ),
          if (currentStlList.deptList.length > 1) const Divider(),
        ],
      ),
    );
  }

  // Helper function to display the dialog and add new fields (department or year)
  void addNewField(BuildContext context, String type) {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type == "dept" ? "Add New Department" : "Add New Year",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: type == "dept" ? 'Department' : 'Year',
                          hintText: type == "dept"
                              ? 'Enter department name'
                              : 'Enter year',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a ${type == "dept" ? "department name" : "year"}';
                          }

                          final provider = Provider.of<CurrentStlList>(context,
                              listen: false);

                          if (type == "dept") {
                            if (provider.deptList.contains(value)) {
                              return 'Department already exists';
                            }
                          } else {
                            if (provider.yearList.contains(value)) {
                              return 'Year already exists';
                            }
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final provider = Provider.of<CurrentStlList>(
                                context,
                                listen: false);

                            if (type == "dept") {
                              provider.addDeptList(controller.text);
                            } else {
                              provider.addYearList(controller.text);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${type == "dept" ? "Department" : "Year"} added successfully',
                                ),
                              ),
                            );

                            controller.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                            'Add ${type == "dept" ? "Department" : "Year"}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
