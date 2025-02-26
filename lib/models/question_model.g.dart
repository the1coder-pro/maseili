// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 3;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      fields[0] as String,
      fields[1] as String?,
      fields[2] as bool,
      fields[3] as String,
      fields[4] as bool?,
      fields[5] as DateTime?,
    )..tags = (fields[6] as List?)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.answered)
      ..writeByte(3)
      ..write(obj.mosqueName)
      ..writeByte(4)
      ..write(obj.isParagraph)
      ..writeByte(5)
      ..write(obj.dateOfAnswer)
      ..writeByte(6)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
