// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mosque_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MosqueAdapter extends TypeAdapter<Mosque> {
  @override
  final int typeId = 0;

  @override
  Mosque read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mosque(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Mosque obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MosqueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
