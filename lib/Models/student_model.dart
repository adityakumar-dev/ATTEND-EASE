import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class Student {
  @HiveField(0)
  String uniqueId;
  @HiveField(1)
  String rollNumber;
  @HiveField(2)
  String name;
  @HiveField(3)
  String year;
  @HiveField(4)
  String department;

  Student({
    required this.uniqueId,
    required this.rollNumber,
    required this.name,
    required this.year,
    required this.department,
  });
}
