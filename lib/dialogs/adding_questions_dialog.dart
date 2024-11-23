import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/pages/add_questions_page.dart';
import 'package:masel/components/helper_functions.dart';
import 'package:masel/pages/mosque_page.dart';
import 'package:masel/models/question_model.dart';

class AddingQuestionsDialog extends StatefulWidget {
  const AddingQuestionsDialog({
    super.key,
    required this.widget,
  });

  final MosquePage widget;

  @override
  State<AddingQuestionsDialog> createState() => _AddingQuestionsDialogState();
}

class _AddingQuestionsDialogState extends State<AddingQuestionsDialog> {
  Question? selectedQuestion;

  @override
  Widget build(BuildContext context) {
    final questionsBox = Hive.box<Question>('questions');
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        width: 350,
        height: 220,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_comment_outlined, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Text(
                    "طريقة إضافة السؤال الى المسجد:",
                    style: TextStyle(fontSize: 18),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                          onPressed: () {
                            Navigator.pop(context);
                            var questionsList =
                                Hive.box<Question>('questions').values.toList().reversed.toList();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: (filterUniqueQuestions(
                                                questionsBox.values.toList())
                                            .where((question) {
                                      // if question.question is in the mosque questions
                                      return questionsList
                                              .where((element) =>
                                                  element.mosqueName ==
                                                  widget.widget.mosqueName)
                                              .map((e) => e.question)
                                              .contains(question.question) ==
                                          false;
                                    }).isEmpty)
                                        ? AlertDialog(
                                            title: Text("إستيراد سؤال"),
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "* لا توجد مسائل لإضافتها",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                              ),
                                            ),
                                            actions: [
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("حسنا"),
                                              ),
                                            ],
                                          )
                                        : AlertDialog(
                                            title: Text("إستيراد سؤال"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0),
                                                  )),

                                                  onChanged: (value) {
                                                    // add question to this mosque
                                                    Question question =
                                                        value as Question;
                                                    // add the question to the mosque questions as new question

                                                    selectedQuestion = Question(
                                                        question.question,
                                                        question.description,
                                                        false,
                                                        widget
                                                            .widget.mosqueName,
                                                        question.isParagraph);
                                                  },
                                                  // retrieve questions from questions page to add to this mosque
                                                  items: filterUniqueQuestions(
                                                          questionsList)
                                                      // remove the questions that are already in the mosque
                                                      .where((question) {
                                                    // if question.question is in the mosque questions
                                                    return questionsList
                                                            .where((element) =>
                                                                element
                                                                    .mosqueName ==
                                                                widget.widget
                                                                    .mosqueName)
                                                            .map((e) =>
                                                                e.question)
                                                            .contains(question
                                                                .question) ==
                                                        false;
                                                  }).map((question) {
                                                    return DropdownMenuItem(
                                                      alignment:
                                                          Alignment.center,
                                                      value: question,
                                                      child: Text(
                                                        question.question,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                "Rubik"),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("إلغاء"),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  questionsBox
                                                      .add(selectedQuestion!);
                                                  Navigator.pop(context);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          content: Text(
                                                              "تم إضافة المسألة")));
                                                },
                                                child: const Text("إضافة"),
                                              ),
                                            ],
                                          ),
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.move_to_inbox_outlined),
                                Text("إستيراد"),
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: FilledButton.tonal(
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddQuestionPage(
                                mosqueName: widget.widget.mosqueName,
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.new_releases_outlined),
                                Text("إنشاء"),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
