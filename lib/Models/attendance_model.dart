class AttendanceModel {
  String studentId;
  String name;
  String rollNumber;
  DateTime date;
  Map<String, String> subject;
  String department;
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
