import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/components/question_view.dart';
import 'package:masel/pages/add_questions_page.dart';
import 'package:masel/dialogs/adding_questions_dialog.dart';
import 'package:masel/dialogs/copy_multiple_questions_to_mosques.dart';
import 'package:masel/dialogs/copy_to_multiple_mosques_dialog.dart';
import 'package:masel/dialogs/delete_dialog.dart';
import 'package:masel/pages/paragraph_page.dart';
import 'package:masel/models/question_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:masel/components/preferences.dart';
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
    final themeMode = Provider.of<GeneralPrefrencesProvider>(context);
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
                      tooltip: "إلغاء",
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
                        tooltip: "نسخ المسائل المحددة",
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
                            tooltip: "حذف المسائل المحددة",
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
                          PopupMenuButton(
                              tooltip: "المزيد",
                              itemBuilder: (context) {
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
                              },
                              onSelected: (value) {
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
                        .toList()
                        .reversed
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
                                ? const Color(0xFF83d0da).withValues(alpha: 0.2)
                                : const Color(0xFF83d0da)
                                    .withValues(alpha: 0.4),
                            leading: Icon(
                              questions[index].answered
                                  ? Icons.check_circle_outline
                                  : Icons.circle_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            trailing: const Icon(Icons.article_outlined),
                            splashColor: themeMode.darkTheme
                                ? const Color(0xFF83d0da).withValues(alpha: 0.2)
                                : const Color(0xFF83d0da)
                                    .withValues(alpha: 0.4),
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
                                subtitle: questions[index].answered
                                    ? Text(
                                        intl.DateFormat('E (h:mm a) yyyy/MM/dd')
                                            .format(
                                                questions[index].dateOfAnswer!)
                                            .replaceFirst("PM", "مساءً")
                                            .replaceFirst("AM", "صباحًا")
                                            .replaceFirst("Sun", "الأحد")
                                            .replaceFirst("Mon", "الإثنين")
                                            .replaceFirst("Tue", "الثلاثاء")
                                            .replaceFirst("Wed", "الأربعاء")
                                            .replaceFirst("Thu", "الخميس")
                                            .replaceFirst("Fri", "الجمعة")
                                            .replaceFirst("Sat", "السبت"),
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(fontSize: 15),
                                      )
                                    : null,
                                onChanged: (value) {
                                  // show dialog to confirm
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: AlertDialog(
                                          icon: const Icon(Icons.check),
                                          title: Text(
                                              "تأكيد ${questions[index].dateOfAnswer != null ? 'عدم' : ''} الشرح"),
                                          content: Text(
                                              "هل أنت متأكد من ${questions[index].dateOfAnswer != null ? 'عدم ' : ''}شرح هذه المسألة؟"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("إلغاء"),
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                questions[index].answered =
                                                    value!;
                                                questions[index].dateOfAnswer =
                                                    DateTime.now();
                                                questions[index].save();
                                              },
                                              child: const Text("تأكيد"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  // questions[index].answered = value!;
                                  // questions[index].dateOfAnswer = DateTime.now();
                                  //
                                  //
                                  // questions[index].save();
                                },
                                secondary: PopupMenuButton(
                                  tooltip: "المزيد",
                                  itemBuilder: (context) =>
                                      const <PopupMenuEntry>[
                                    PopupMenuItem(
                                      value: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.image_outlined),
                                          Text("عرض"),
                                        ],
                                      ),
                                    ),
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
                                    switch (value) {
                                      case 0:
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CopyToMultipleMosquesDialog(
                                                    question:
                                                        questions[index]));
                                        break;
                                      case 1:
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditQuestionPage(context,
                                                        questions, index)));
                                        break;
                                      case 2:
                                        deleteAQuestion(
                                            context, questions, index);
                                        break;
                                      case 3:
                                        // use question view
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QuestionView(
                                                        index: 0,
                                                        carouselController:
                                                            CarouselSliderController(),
                                                        questions: [
                                                          questions[index]
                                                        ])));
                                        break;
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
              const SizedBox(height: 80)
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
}
