import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m3e_buttons/m3e_buttons.dart';
import 'package:m3e_card_list/m3e_card_list.dart';
import 'package:masel/components/question_view.dart';
import 'package:masel/pages/add_questions_page.dart';
import 'package:masel/dialogs/adding_questions_dialog.dart';
import 'package:masel/dialogs/copy_multiple_questions_to_mosques.dart';
import 'package:masel/dialogs/copy_to_multiple_mosques_dialog.dart';
import 'package:masel/dialogs/delete_dialog.dart';
import 'package:masel/pages/paragraph_page.dart';
import 'package:masel/models/question_model.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/dialogs/edit_mosque_dialog.dart';
import 'package:masel/dialogs/delete_mosque_dialog.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:intl/intl.dart' as intl;

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
  late String currentMosqueName;

  @override
  void initState() {
    super.initState();
    currentMosqueName = widget.mosqueName;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: pageMode == PageMode.normal
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.secondaryContainer,
              title: Text(
                  pageMode == PageMode.select
                      ? "تحديد مسائل للنسخ"
                      : pageMode == PageMode.delete
                          ? "تحديد مسائل للحذف"
                          : currentMosqueName,
                  style: TextStyle(
                    fontFamily: "Lateef",
                    fontSize: 32,
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
                                          mosqueName: currentMosqueName,
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
                                        M3EOutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("إلغاء"),
                                        ),
                                        M3EFilledButton(
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
                          IconButton(
                            tooltip: "نسخ مسائل",
                            icon: const Icon(Icons.copy_outlined, size: 20),
                            onPressed: () {
                              setState(() {
                                selectedMosques.clear();
                                selectedQuestion.clear();
                                pageMode = PageMode.select;
                              });
                            },
                          ),
                          IconButton(
                            tooltip: "حذف مسائل",
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedMosques.clear();
                                selectedQuestion.clear();
                                pageMode = PageMode.delete;
                              });
                            },
                          ),
                          PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              tooltip: "المزيد",
                              itemBuilder: (context) {
                                return <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      leading: const Icon(Icons.edit_outlined,
                                          size: 20),
                                      title: const Text("تعديل المسجد"),
                                      contentPadding: EdgeInsets.zero,
                                      titleTextStyle: TextStyle(
                                        fontFamily: "Rubik",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: ListTile(
                                      leading: const Icon(
                                          Icons.delete_forever_outlined,
                                          size: 20),
                                      title: const Text("حذف المسجد"),
                                      contentPadding: EdgeInsets.zero,
                                      titleTextStyle: TextStyle(
                                        fontFamily: "Rubik",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                if (value == 2) {
                                  final box = Hive.box<Mosque>('mosques');
                                  final index = box.values.toList().indexWhere(
                                      (element) =>
                                          element.name == currentMosqueName);
                                  if (index != -1) {
                                    showEditMosqueDialog(
                                        context, index, currentMosqueName);
                                    // Watch for state changes to refresh title
                                    box.watch().listen((event) {
                                      final updatedMosque = box.getAt(index);
                                      if (updatedMosque != null &&
                                          mounted &&
                                          updatedMosque.name !=
                                              currentMosqueName) {
                                        setState(() {
                                          currentMosqueName =
                                              updatedMosque.name;
                                        });
                                      }
                                    });
                                  }
                                } else if (value == 3) {
                                  final box = Hive.box<Mosque>('mosques');
                                  final index = box.values.toList().indexWhere(
                                      (element) =>
                                          element.name == currentMosqueName);
                                  if (index != -1) {
                                    final list = box.values.toList();
                                    deleteMosque(context, list, index)
                                        .then((_) {
                                      // If the mosque is deleted, pop the content page
                                      if (!box.containsKey(list[index].key) &&
                                          mounted) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
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
                            question.mosqueName == currentMosqueName)
                        .toList()
                        .reversed
                        .toList();
                    if (questions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            M3EContainer.gem(
                              width: 130,
                              height: 130,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                Icons.assignment_outlined,
                                size: 50,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "لا توجد مسائل",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (pageMode == PageMode.select ||
                        pageMode == PageMode.delete) {
                      return M3ECardList.builder(
                        color: Theme.of(context).colorScheme.surface,
                        itemCount: questions.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    questions[index].question,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontFamily: "Rubik"),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                    labelPadding: EdgeInsets.zero,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        questions[index].isParagraph == true
                                            ? "خطبة"
                                            : "مسألة",
                                        style: const TextStyle(
                                            fontSize: 13, fontFamily: "Rubik"),
                                      ),
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

                    final isDarkMode =
                        Theme.of(context).brightness == Brightness.dark;

                    return ListView.builder(
                      padding: const EdgeInsets.only(
                          bottom: 80, left: 16, right: 16, top: 16),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final isParagraph = question.isParagraph == true;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            leading: Icon(
                              question.answered
                                  ? Icons.check_circle_outline
                                  : Icons.circle_outlined,
                              color: question.answered
                                  ? (isDarkMode
                                      ? Colors.green.shade400
                                      : Colors.green.shade600)
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildItemPopupMenu(
                                    context, questions, question, index),
                                const Icon(Icons.expand_more_rounded),
                              ],
                            ),
                            title: Text(
                              question.question,
                              style: TextStyle(
                                fontFamily: "Rubik",
                                fontSize: 16,
                                fontWeight: isParagraph
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            childrenPadding: const EdgeInsets.all(16),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              if (isParagraph) ...[
                                if (question.description?.isNotEmpty ==
                                    true) ...[
                                  Text(
                                    question.description!,
                                    style: const TextStyle(
                                      fontFamily: "Rubik",
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                M3EOutlinedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return ParagraphPage(
                                            question: question);
                                      },
                                    ));
                                  },
                                  child: const Text(
                                    "عرض كامل الخطبة",
                                    style: TextStyle(fontFamily: "Rubik"),
                                  ),
                                ),
                              ] else ...[
                                if (question.description?.isNotEmpty ==
                                    true) ...[
                                  Card(
                                    elevation: 0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerLow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outlineVariant,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        question.description!,
                                        style: const TextStyle(
                                          fontFamily: "Rubik",
                                          fontSize: 15,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                CheckboxListTile(
                                  value: question.answered,
                                  title: const Text(
                                    "تم الشرح",
                                    style: TextStyle(
                                      fontFamily: "Rubik",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: question.answered
                                      ? Text(
                                          intl.DateFormat(
                                                  'E (h:mm a) yyyy/MM/dd')
                                              .format(question.dateOfAnswer!)
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
                                          style: const TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: 13,
                                          ),
                                        )
                                      : null,
                                  onChanged: (value) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            icon: Icon(
                                              Icons.check_circle_outline,
                                              size: 40,
                                              color: isDarkMode
                                                  ? Colors.green.shade400
                                                  : Colors.green.shade600,
                                            ),
                                            title: Text(
                                              "تأكيد ${question.dateOfAnswer != null ? 'عدم' : ''} الشرح",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: "Rubik",
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              "هل أنت متأكد من ${question.dateOfAnswer != null ? 'عدم ' : ''}شرح هذه المسألة؟",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: "Rubik",
                                                fontSize: 16,
                                              ),
                                            ),
                                            actions: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: M3EFilledButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          question.answered =
                                                              value ?? false;
                                                          question.dateOfAnswer =
                                                              DateTime.now();
                                                          question.save();
                                                        });
                                                      },
                                                      child: const Text("تأكيد",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Rubik")),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: M3EOutlinedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text("إلغاء",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Rubik")),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
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

  Widget _buildItemPopupMenu(BuildContext context, List<Question> questions,
      Question question, int index) {
    return PopupMenuButton<int>(
      tooltip: "المزيد",
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 3,
          child: ListTile(
            leading: const Icon(Icons.visibility_outlined, size: 20),
            title: const Text("عرض"),
            contentPadding: EdgeInsets.zero,
            titleTextStyle: TextStyle(
              fontFamily: "Rubik",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: ListTile(
            leading: const Icon(Icons.copy_outlined, size: 20),
            title: const Text("نسخ"),
            contentPadding: EdgeInsets.zero,
            titleTextStyle: TextStyle(
              fontFamily: "Rubik",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: const Icon(Icons.edit_outlined, size: 20),
            title: const Text("تعديل"),
            contentPadding: EdgeInsets.zero,
            titleTextStyle: TextStyle(
              fontFamily: "Rubik",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: const Icon(Icons.delete_outline_rounded, size: 20),
            title: const Text("حذف"),
            contentPadding: EdgeInsets.zero,
            titleTextStyle: TextStyle(
              fontFamily: "Rubik",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            showDialog(
              context: context,
              builder: (context) =>
                  CopyToMultipleMosquesDialog(question: question),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditQuestionPage(context, questions, index),
              ),
            );
            break;
          case 2:
            deleteAQuestion(context, questions, index);
            break;
          case 3:
            if (question.isParagraph == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParagraphPage(question: question),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionView(
                    index: 0,
                    carouselController: CarouselSliderController(),
                    questions: [question],
                  ),
                ),
              );
            }
            break;
        }
      },
    );
  }
}
