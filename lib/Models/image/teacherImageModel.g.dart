// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacherImageModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherImageModelAdapter extends TypeAdapter<TeacherImageModel> {
  @override
  final int typeId = 2;

  @override
  TeacherImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeacherImageModel(
      selectedImage: fields[0] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, TeacherImageModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.selectedImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
