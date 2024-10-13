import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/Add%20Subject/add_subject.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/Register/register_student_screen.dart';
import 'package:attend_ease/services/providers/current_stl_list.dart';
import 'package:attend_ease/Utils/ui_helper.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentStlList currentStlList = Provider.of<CurrentStlList>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose an Option",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                buildRegisterCard(
                  context,
                  title: "Register Student",
                  icon: Icons.person_add_alt_1,
                  onTap: () {
                    Navigator.pushNamed(
                        context, RegisterStudentScreen.rootName);
                  },
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                buildRegisterCard(
                  context,
                  title: "Add New Department",
                  icon: Icons.business_center,
                  onTap: () {
                    addNewField(context, "dept");
                  },
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                buildRegisterCard(
                  context,
                  title: "Add Year",
                  icon: Icons.calendar_today,
                  onTap: () {
                    addNewField(context, "year");
                  },
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                if (currentStlList.deptList.length > 1)
                  buildRegisterCard(
                    context,
                    title: "Add Subject",
                    icon: Icons.library_books,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddSubjectScreen(),
                        ),
                      );
                    },
                    color: Colors.purple,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRegisterCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Function() onTap,
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
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  void addNewField(BuildContext context, String type) {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1)),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type == "dept" ? "Add New Department" : "Add New Year",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: type == "dept" ? 'Department' : 'Year',
                    hintText:
                        type == "dept" ? 'Enter department name' : 'Enter year',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a ${type == "dept" ? "department name" : "year"}';
                    }

                    final provider =
                        Provider.of<CurrentStlList>(context, listen: false);

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
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: kTextStyle(ksize16, blackColor, true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: ksize16, vertical: ksize10),
                    decoration: BoxDecoration(
                        color: softBlue,
                        border: Border.all(color: whiteColor),
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          final provider = Provider.of<CurrentStlList>(context,
                              listen: false);

                          if (type == "dept") {
                            provider.addDeptList(controller.text);
                          } else {
                            provider.addYearList(controller.text);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${type == "dept" ? "Department" : "Year"} added successfully!',
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Add ',
                        style: kTextStyle(ksize16, whiteColor, true),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
