// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceModelAdapter extends TypeAdapter<AttendanceModel> {
  @override
  final int typeId = 1;

  @override
  AttendanceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceModel(
      rollNumber: fields[2] as String,
      name: fields[1] as String,
      year: fields[6] as String,
      department: fields[5] as String,
      studentId: fields[0] as String,
      date: fields[3] as DateTime,
      subject: (fields[4] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.rollNumber)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.subject)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
