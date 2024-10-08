import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

part 'question_model.g.dart';

@HiveType(typeId: 1)
class Question extends HiveObject {
  @HiveField(0)
  late String question;

  @HiveField(1)
  String? description;

  @HiveField(2)
  late bool answered;

  @HiveField(3)
  late String mosqueName;

  @HiveField(4)
  bool? isParagraph = false;

  Question(this.question, this.description, this.answered, this.mosqueName,
      this.isParagraph);
}
