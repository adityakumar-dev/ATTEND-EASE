import 'package:hive/hive.dart';

part 'attendance_model.g.dart';

@HiveType(typeId: 1)
class AttendanceModel {
  @HiveField(0)
  String studentId;
  @HiveField(1)
  String name;
  @HiveField(2)
  String rollNumber;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  Map<String, String> subject;
  @HiveField(5)
  String department;
  @HiveField(6)
  String year;

  AttendanceModel({
    required this.rollNumber,
    required this.name,
    required this.year,
    required this.department,
    required this.studentId,
    required this.date,
    required this.subject,
  });
}
