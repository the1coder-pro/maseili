import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/add_questions_page.dart';
import 'package:masel/main.dart';
import 'package:masel/paragraph_page.dart';
import 'package:masel/question_model.dart';
import 'package:masel/questions_page.dart';
import 'package:masel/settings.dart';
import 'package:provider/provider.dart';

enum PageMode { normal, select, delete }

class MosquePage extends StatefulWidget {
  const MosquePage({
    required this.mosqueName,
    super.key,
  });

  final String mosqueName;

  @override
  State<MosquePage> createState() => _MosquePageState();
}

class _MosquePageState extends State<MosquePage> {
  List selectedMosques = [];
  List<Question> selectedQuestion = [];

  PageMode pageMode = PageMode.normal;

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkThemeProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: pageMode == PageMode.normal
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.secondaryContainer,
              title: Text(widget.mosqueName,
                  style: TextStyle(
                    color: pageMode == PageMode.normal
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSecondaryContainer,
                  )),
              centerTitle: true,
              leading: pageMode == PageMode.normal
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      color: pageMode == PageMode.normal
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                      onPressed: () {
                        setState(() {
                          pageMode = PageMode.normal;
                        });
                      }),
              // more actions
              actions: pageMode == PageMode.select
                  ? [
                      IconButton(
                        icon: const Icon(Icons.copy_all_outlined),
                        color: pageMode == PageMode.normal
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                        onPressed: () {
                          showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CopyMultipleQuestionsToMosques(
                                          mosqueName: widget.mosqueName,
                                          selectedQuestion: selectedQuestion))
                              .then((value) {
                            if (value == PageMode.normal) {
                              setState(() {
                                pageMode = PageMode.normal;
                              });
                            }
                          });
                        },
                      )
                    ]
                  : pageMode == PageMode.delete
                      ? [
                          IconButton(
                            icon: const Icon(Icons.delete_outlined),
                            color: pageMode == PageMode.normal
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                            onPressed: () {
                              // show dialog to delete selected questions

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      icon: const Icon(Icons.delete_outline),
                                      iconColor:
                                          Theme.of(context).colorScheme.error,
                                      title: const Text("حذف المسائل"),
                                      content: const Text(
                                          "هل أنت متأكد من حذف المسائل المحددة؟"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("إلغاء"),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            for (var question
                                                in selectedQuestion) {
                                              question.delete();
                                            }

                                            setState(() {
                                              pageMode = PageMode.normal;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("حذف"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ]
                      : [
                          PopupMenuButton(itemBuilder: (context) {
                            return const <PopupMenuEntry>[
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.copy_outlined),
                                    Text("نسخ"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.delete_outlined),
                                    Text("حذف"),
                                  ],
                                ),
                              ),
                            ];
                          }, onSelected: (value) {
                            if (value == 0) {
                              setState(() {
                                selectedMosques.clear();
                                selectedQuestion.clear();
                                pageMode = PageMode.select;
                              });
                            } else if (value == 1) {
                              setState(() {
                                selectedMosques.clear();
                                selectedQuestion.clear();
                                pageMode = PageMode.delete;
                              });
                            }
                          }),
                        ]),
          body: Center(
              child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder<Box<Question>>(
                  valueListenable: Hive.box<Question>('questions').listenable(),
                  builder: (context, box, _) {
                    var questions = box.values
                        .where((question) =>
                            question.mosqueName == widget.mosqueName)
                        .toList();
                    if (questions.isEmpty) {
                      return const Center(
                        child: Text("لا توجد مسائل",
                            style: TextStyle(fontSize: 25)),
                      );
                    }
                    if (pageMode == PageMode.select ||
                        pageMode == PageMode.delete) {
                      return ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  questions[index].question,
                                  overflow: TextOverflow.fade,
                                ),
                                Chip(
                                    labelPadding: EdgeInsets.zero,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                    label: Text(
                                      questions[index].isParagraph == true
                                          ? "خطبة"
                                          : "مسألة",
                                      style: const TextStyle(fontSize: 15),
                                    ))
                              ],
                            ),
                            value: selectedQuestion.contains(questions[index]),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  selectedQuestion.add(questions[index]);
                                } else {
                                  selectedQuestion.remove(questions[index]);
                                }
                              });
                            },
                          );
                        },
                      );
                    }
                    return ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        if (questions[index].isParagraph == true) {
                          return ListTile(
                            tileColor: themeMode.darkTheme
                                ? const Color(0xFF83d0da).withOpacity(0.2)
                                : const Color(0xFF83d0da).withOpacity(0.4),
                            leading: Icon(
                              questions[index].answered
                                  ? Icons.check_circle_outline
                                  : Icons.circle_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            trailing: const Icon(Icons.article_outlined),
                            splashColor: themeMode.darkTheme
                                ? const Color(0xFF83d0da).withOpacity(0.2)
                                : const Color(0xFF83d0da).withOpacity(0.4),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ParagraphPage(
                                      question: questions[index]);
                                },
                              ));
                            },
                            titleTextStyle: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer),
                            title: Text(questions[index].question,
                                style: const TextStyle(
                                    fontSize: 20, fontFamily: "Rubik")),
                          );
                        }
                        return ExpansionTile(
                          title: Text(questions[index].question,
                              style: const TextStyle(
                                fontSize: 20,
                              )),
                          leading: Icon(
                            questions[index].answered
                                ? Icons.check_circle_outline
                                : Icons.circle_outlined,
                            color: questions[index].answered
                                ? const Color(0xFF1fba42)
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            if (questions[index].description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: Card.filled(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  child: ListTile(
                                    titleTextStyle: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                    title: Text(questions[index].description!),
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: CheckboxListTile(
                                value: questions[index].answered,
                                title: const Text("تم شرحه"),
                                onChanged: (value) {
                                  questions[index].answered = value!;
                                  
                                  questions[index].save();
                                },
                                secondary: PopupMenuButton(
                                  itemBuilder: (context) =>
                                      const <PopupMenuEntry>[
                                    PopupMenuItem(
                                        value: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.copy_outlined),
                                            Text("نسخ"),
                                          ],
                                        )),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.edit_outlined),
                                          Text("تعديل"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuDivider(),
                                    PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.delete_outlined),
                                            Text("حذف"),
                                          ],
                                        )),
                                  ],
                                  onSelected: (value) {
                                    if (value == 0) {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CopyToMultipleMosquesDialog(
                                                  question: questions[index]));
                                    } else if (value == 1) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditQuestionPage(context,
                                                      questions, index)));
                                    } else if (value == 2) {
                                      deleteDialog(context, questions, index);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
          floatingActionButton:
              pageMode == PageMode.select || pageMode == PageMode.delete
                  ? Container()
                  : FloatingActionButton(
                      elevation: 3,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AddingQuestionsDialog(widget: widget);
                            });
                      },
                      tooltip: 'إضافة مسألة',
                      child: const Icon(Icons.add),
                    )),
    );
  }

  Future<dynamic> deleteAQuestion(
      BuildContext context, List<Question> questions, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              icon: const Icon(Icons.delete_outline),
              iconColor: Theme.of(context).colorScheme.error,
              title: const Text("حذف سؤال"),
              content:
                  Text("هل أنت متأكد من حذف '${questions[index].question}'؟"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("لا"),
                ),
                FilledButton(
                  onPressed: () {
                    Box<Question> questionsBox =
                        Hive.box<Question>('questions');
                    questionsBox.deleteAt(index);
                    Navigator.pop(context);
                  },
                  child: const Text("نعم"),
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> deleteDialog(
      BuildContext context, List<Question> questions, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.delete_outline),
            iconColor: Theme.of(context).colorScheme.error,
            title: const Text("حذف المسألة"),
            content: const Text("هل أنت متأكد من حذف المسألة؟"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("إلغاء"),
              ),
              FilledButton(
                onPressed: () {
                  questions[index].delete();
                  Navigator.pop(context);
                },
                child: const Text("حذف"),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
        height: 200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: FilledButton.tonal(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))))),
                      onPressed: () {
                        Navigator.pop(context);
                        var questionsList =
                            Hive.box<Question>('questions').values.toList();
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
                                          padding: const EdgeInsets.all(8.0),
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
                                                  border: OutlineInputBorder()),

                                              onChanged: (value) {
                                                // add question to this mosque
                                                Question question =
                                                    value as Question;
                                                // add the question to the mosque questions as new question

                                                selectedQuestion = Question(
                                                    question.question,
                                                    question.description,
                                                    question.answered,
                                                    widget.widget.mosqueName,
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
                                                        .map((e) => e.question)
                                                        .contains(question
                                                            .question) ==
                                                    false;
                                              }).map((question) {
                                                return DropdownMenuItem(
                                                  alignment: Alignment.center,
                                                  value: question,
                                                  child: Text(
                                                    question.question,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: "Rubik"),
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
                                                      duration: const Duration(
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
                            Icon(Icons.add_comment_outlined),
                            Text("الاسئلة\nالعامة"),
                          ],
                        ),
                      )),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: FilledButton.tonal(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))))),
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
                            Text("إضافة\nسؤال"),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> editDialog(
    BuildContext context, List<Question> questions, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      final TextEditingController questionController = TextEditingController();
      final TextEditingController descriptionController =
          TextEditingController();
      questionController.text = questions[index].question;
      descriptionController.text = questions[index].description ?? "";
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text("تعديل المسألة"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "المسألة",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "الوصف",
                ),
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
                if (questionController.text.isNotEmpty) {
                  questions[index].question = questionController.text;
                  questions[index].description = descriptionController.text;
                  questions[index].save();
                  Navigator.pop(context);
                }
              },
              child: const Text("حفظ"),
            ),
          ],
        ),
      );
    },
  );
}
