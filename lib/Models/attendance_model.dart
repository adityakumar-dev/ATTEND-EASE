class AttendanceModel {
  String studentId;
  DateTime date;
  Map<String, bool> subject;
  String department;
  String year;

  AttendanceModel({
    required this.year,
    required this.department,
    required this.studentId,
    required this.date,
    required this.subject,
  });
}
