import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'teacherImageModel.g.dart';

@HiveType(typeId: 2)
class TeacherImageModel {
  @HiveField(0)
  Uint8List? selectedImage; // Store image as bytes

  TeacherImageModel({this.selectedImage});
}
