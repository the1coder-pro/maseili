import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

part 'question_model.g.dart';

@HiveType(typeId: 3)
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

  @HiveField(5)
  DateTime? dateOfAnswer;

  Question(this.question, this.description, this.answered, this.mosqueName,
      this.isParagraph, this.dateOfAnswer);

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
        isParagraph = json['isParagraph'],
        // check before parsing


        dateOfAnswer = json['dateOfAnswer'] == null ? null : json['dateOfAnswer'].toString().isNotEmpty ?  DateTime.parse(json['dateOfAnswer']!) : null; // 2024-12-08 14:37:01.255625 like format

  // toJson
  Map<String, dynamic> toJson() => {
        'question': question,
        'description': description,
        'answered': answered,
        'mosqueName': mosqueName,
        'isParagraph': isParagraph,
        'dateOfAnswer': dateOfAnswer?.toString()
      };
}
