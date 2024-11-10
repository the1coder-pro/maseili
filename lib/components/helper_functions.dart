import 'package:masel/models/question_model.dart';

List<Question> filterUniqueQuestions(List<Question> questions) {
  final uniqueQuestions = <Question>{};

  for (var question in questions) {
    uniqueQuestions.add(question);
  }

  return uniqueQuestions.toList();
}

List<Map<String, dynamic>> groupQuestions(List<Question> questions) {
  Map<String, Map<String, dynamic>> groupedQuestions = {};

  for (var question in questions) {
    String key = '${question.question}_${question.description}';

    if (!groupedQuestions.containsKey(key)) {
      groupedQuestions[key] = {
        'question': question.question,
        'description': question.description,
        'mosques': [],
        'isParagraph': question.isParagraph
      };
    }
    // don't add empty mosques
    if (question.mosqueName.isNotEmpty) {
      groupedQuestions[key]!['mosques'].add(
          {'mosqueName': question.mosqueName, 'answered': question.answered});
    }
  }

  return groupedQuestions.values.toList();
}
