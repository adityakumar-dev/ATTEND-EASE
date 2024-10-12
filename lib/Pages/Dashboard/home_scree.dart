import 'package:attend_ease/Pages/Dashboard/DashboardScreen/mark_attendance.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/register_screen.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/student_list_screen.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/view_attendance.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String rootName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final drawerKey = GlobalKey<DrawerControllerState>();

  // Updated method for getting app bar title
  String appBarTitle() {
    switch (index) {
      case 0:
        return "Register";
      case 1:
        return "Mark Attendance";
      case 2:
        return "View Attendance";
      case 3:
        return "Student List";
      default:
        return "Route Not Found";
    }
  }

  // Updated method for fetching the current widget
  Widget getCurrentWidget(int index) {
    switch (index) {
      case 0:
        return RegisterScreen();
      case 1:
        return MarkAttendancePage();
      case 2:
        return ViewAttendancePage(context);
      case 3:
        return const StudentDetails();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: Text(appBarTitle()),
      ),
      drawer: _buildDrawer(context),
      body:
          getCurrentWidget(index), // Directly calling the method for the widget
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      key: drawerKey,
      surfaceTintColor: blueColor,
      backgroundColor: whiteColor,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDrawerHeader(),
                heightBox(ksize20),
                _drawerItemsUi(
                  context,
                  "Register Student",
                  Icons.person_add,
                  index == 0,
                  () {
                    setState(() {
                      index = 0; // Fixed the index to 0 for Register Student
                    });
                    Navigator.pop(context);
                  },
                ),
                _drawerItemsUi(
                  context,
                  "Mark Attendance",
                  Icons.check_circle,
                  index == 1,
                  () {
                    setState(() {
                      index = 1; // Corrected index for Mark Attendance
                    });
                    Navigator.pop(context);
                  },
                ),
                _drawerItemsUi(
                  context,
                  "View Attendance",
                  Icons.view_list,
                  index == 2,
                  () {
                    setState(() {
                      index = 2; // Corrected index for View Attendance
                    });
                    Navigator.pop(context);
                  },
                ),
                _drawerItemsUi(
                  context,
                  "Student List",
                  Icons.view_list,
                  index == 3,
                  () {
                    setState(() {
                      index = 3;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          _buildSignOutSection(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: ksize20, vertical: ksize50),
      color: coral,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: whiteColor,
            minRadius: ksize50,
            child: Icon(
              Icons.person,
              color: blackColor,
              size: 80,
            ),
          ),
          widthBox(ksize10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Teacher Name",
                style: kTextStyle(ksize20, whiteColor, true, changeFont: true),
              ),
              Text(
                "H.O.D",
                style: kTextStyle(ksize14, whiteColor, true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutSection() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: ksize20, vertical: ksize30),
      child: Row(
        children: [
          const Icon(Icons.logout, size: ksize30),
          widthBox(ksize16),
          Text(
            "Sign Out",
            style: kTextStyle(ksize20, blackColor, false, changeFont: true),
          ),
        ],
      ),
    );
  }

  Widget _drawerItemsUi(BuildContext context, String heading, IconData iconData,
      bool isSelected, Function() onTap) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: ksize10, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? blackColor : null,
            borderRadius: BorderRadius.circular(ksize10),
          ),
          child: ListTile(
            minVerticalPadding: 0,
            leading: Icon(
              iconData,
              color: isSelected ? whiteColor : blackColor,
              size: ksize30,
            ),
            title: Text(
              heading,
              style: kTextStyle(ksize20, isSelected ? whiteColor : blackColor,
                  isSelected ? true : false),
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
