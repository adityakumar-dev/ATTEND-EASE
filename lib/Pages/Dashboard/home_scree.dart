import 'dart:io';

import 'package:attend_ease/Models/image/teacherImageModel.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/mark_attendance.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/register_screen.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/student_list_screen.dart';
import 'package:attend_ease/Pages/Dashboard/DashboardScreen/view_attendance.dart';
import 'package:attend_ease/Utils/ui_helper.dart';
import 'package:attend_ease/services/local%20storage/local_storage_manager.dart';
import 'package:attend_ease/services/providers/user_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String rootName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  File? selectedImage;
  TeacherImageModel teacherImageModel = TeacherImageModel();

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

  Widget getCurrentWidget(int index) {
    switch (index) {
      case 0:
        return const RegisterScreen();
      case 1:
        return const MarkAttendancePage();
      case 2:
        return ViewAttendancePage();
      case 3:
        return const StudentDetails();
      default:
        return Container();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final TeacherImageModel? imageModel = await getLocalImage();

        if (imageModel != null && imageModel.selectedImage != null) {
          final directory = await getApplicationDocumentsDirectory();
          selectedImage = await File("${directory.path}/teacherImage")
              .writeAsBytes(imageModel.selectedImage!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
      } catch (e) {
        print("Error loading image: $e");
      }
    });
  }

  Future<TeacherImageModel?> getLocalImage() async {
    return await LocalStorageManager.getTeacherImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text(
          appBarTitle(),
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                softBlue,
                Colors.blueAccent.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: getCurrentWidget(index),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
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
                      index = 0;
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
                      index = 1;
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
                      index = 2;
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
    showInputDailog(
        String title, String description, Function(String txt) onDone) {
      TextEditingController controller = TextEditingController();
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            title,
            style: kTextStyle(ksize16, blackColor, false),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                description,
                style: kTextStyle(ksize12, greyColor, false),
              ),
              heightBox(ksize10),
              TextField(
                controller: controller,
              )
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => onDone(controller.text),
              child: Text(
                "Okay",
                style: kTextStyle(ksize12, blackColor, false),
              ),
            )
          ],
        ),
      );
    }

    final provider = Provider.of<UserStateProvider>(context);
    Future<void> selectImage() async {
      ImagePicker imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);

        final bytes = await selectedImage!.readAsBytes();

        await LocalStorageManager.teacherImage(
            TeacherImageModel(selectedImage: bytes));
        // await TeacherImageModel.se(teacherImageModel);

        setState(() {});
      }
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: ksize20, vertical: ksize50),
      color: coral,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: selectImage,
            child: CircleAvatar(
              backgroundColor: whiteColor,
              minRadius: ksize50,
              child: selectedImage == null
                  ? const Icon(
                      Icons.person,
                      color: blackColor,
                      size: 80,
                    )
                  : ClipOval(
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
            ),
          ),
          widthBox(ksize10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.userName,
                    style:
                        kTextStyle(ksize16, whiteColor, true, changeFont: true),
                  ),
                  widthBox(ksize10),
                  IconButton(
                      onPressed: () => showInputDailog(
                              "Teacher", "Enter your name", (String txt) async {
                            provider.updateName(txt);
                            await LocalStorageManager.storeTeacherName(txt);
                            Navigator.pop(context);
                          }),
                      icon: const Icon(Icons.edit, size: ksize16))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.userPosition,
                    style: kTextStyle(ksize14, whiteColor, true),
                  ),
                  widthBox(ksize10),
                  IconButton(
                      onPressed: () =>
                          showInputDailog("Position", "Enter your position",
                              (String txt) async {
                            provider.updatePositions(txt);
                            await LocalStorageManager.storeTeacherPosition(txt);
                            Navigator.pop(context);
                          }),
                      icon: const Icon(Icons.edit))
                ],
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
