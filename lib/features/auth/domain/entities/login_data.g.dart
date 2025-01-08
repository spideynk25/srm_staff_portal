// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginDataAdapter extends TypeAdapter<LoginData> {
  @override
  final int typeId = 0;

  @override
  LoginData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginData(
      eid: fields[0] as String,
      officeId: fields[1] as String,
      designation: fields[2] as String,
      department: fields[3] as String,
      menuIds: (fields[4] as List).cast<String>(),
      employeeId: fields[5] as String,
      employeeName: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.eid)
      ..writeByte(1)
      ..write(obj.officeId)
      ..writeByte(2)
      ..write(obj.designation)
      ..writeByte(3)
      ..write(obj.department)
      ..writeByte(4)
      ..write(obj.menuIds)
      ..writeByte(5)
      ..write(obj.employeeId)
      ..writeByte(6)
      ..write(obj.employeeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
