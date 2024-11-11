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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          description == other.description;
  @override
  int get hashCode => question.hashCode ^ description.hashCode;

  // fromJson
  Question.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        description = json['description'],
        answered = json['answered'],
        mosqueName = json['mosqueName'],
        isParagraph = json['isParagraph'];

  // toJson
  Map<String, dynamic> toJson() => {
        'question': question,
        'description': description,
        'answered': answered,
        'mosqueName': mosqueName,
        'isParagraph': isParagraph,
      };
}
