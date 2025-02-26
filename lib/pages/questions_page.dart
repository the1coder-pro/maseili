import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/tag_model.dart';
import 'package:masel/pages/add_questions_page.dart';
import 'package:masel/dialogs/delete_dialog.dart';
import 'package:masel/components/helper_functions.dart';
import 'package:masel/components/question_view.dart';
import 'package:masel/models/question_model.dart';
import 'package:masel/components/preferences.dart';
import 'package:masel/pages/mosque_page.dart';
import 'package:provider/provider.dart';

enum ScreenView { tableView, listView }

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  Set<ScreenView> selected = {ScreenView.listView};

  TextEditingController searchController = TextEditingController();
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<GeneralPrefrencesProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("التصنيفات"),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  child: SegmentedButton<ScreenView>(
                      onSelectionChanged: (Set<ScreenView> value) {
                        setState(() {
                          selected = {value.first};
                        });
                      },
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Icon(
                                Icons.view_agenda_outlined,
                                size: 20,
                              ),
                            ),
                            value: ScreenView.listView),
                        ButtonSegment(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Icon(
                                Icons.table_chart_outlined,
                                size: 20,
                              ),
                            ),
                            value: ScreenView.tableView),
                      ],
                      selected: selected),
                )
              ],
            ),
            body: ValueListenableBuilder<Box<Question>>(
                valueListenable: Hive.box<Question>('questions').listenable(),
                builder: (BuildContext context, box, _) {
                  var allQuestions = box.values.toList();
                  var questions =
                      filterUniqueQuestions(allQuestions).reversed.toList();
                  // filter questions to show unique questions only
                  if (questions.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا توجد أسئلة",
                        style: TextStyle(fontSize: 25),
                      ),
                    );
                  }
                  return PageTransitionSwitcher(
                      transitionBuilder: (Widget child,
                          Animation<double> primaryAnimation,
                          Animation<double> secondaryAnimation) {
                        return FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        );
                      },
                      child: selected.contains(ScreenView.listView)
                          ? ValueListenableBuilder<Box<Tag>>(
                              valueListenable: Hive.box<Tag>('tags')
                                  .listenable(), // for tags
                              builder: (BuildContext context, box, _) {
                                var tags = box.values.toList();
                                if (tags.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "لا توجد تصنيفات",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  );
                                }
                                // return grid of tags
                                return ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: tags.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card.filled(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondaryContainer,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ListTile(
                                                  splashColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer,
                                                  tileColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer,
                                                  title: Text(
                                                    tags[index].name,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSecondaryContainer),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      if (questions
                                                          .where((element) {
                                                            if (element.tags ==
                                                                null) {
                                                              return false;
                                                            }
                                                            return element.tags!
                                                                .contains(
                                                                    tags[index]
                                                                        .name);
                                                          })
                                                          .toList()
                                                          .isEmpty) {
                                                        return Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: Scaffold(
                                                            appBar: AppBar(
                                                              title: Text(
                                                                  tags[index]
                                                                      .name),
                                                            ),
                                                            body: Center(
                                                              child: Text(
                                                                  "لا توجد أسئلة بهذا التصنيف"),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Scaffold(
                                                          appBar: AppBar(
                                                            title: Text(
                                                                tags[index]
                                                                    .name),
                                                          ),
                                                          body: ListViewSection(
                                                            searchController:
                                                                searchController,
                                                            themeProvider:
                                                                themeProvider,
                                                            questions: questions
                                                                .where(
                                                                    (element) {
                                                              if (element
                                                                      .tags ==
                                                                  null) {
                                                                return false;
                                                              } else {
                                                                return element
                                                                    .tags!
                                                                    .contains(tags[
                                                                            index]
                                                                        .name);
                                                              }
                                                            }).toList(),
                                                            carouselController:
                                                                carouselController,
                                                          ),
                                                        ),
                                                      );
                                                    }));
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyTable(allQuestions: allQuestions),
                                ),
                              ],
                            ));
                }),
            floatingActionButton: FloatingActionButton(
              elevation: 3,
              onPressed: () {
                if (selected.contains(ScreenView.tableView)) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddQuestionPage();
                  }));
                } else {
                  createTagDialog(context);
                }
              },
              child: const Icon(Icons.add),
            )));
  }
}

void createTagDialog(BuildContext context) {
  final TextEditingController tagController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("إضافة تصنيف"),
        content: TextField(
          controller: tagController,
          decoration: const InputDecoration(hintText: "اسم التصنيف"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              if (tagController.text.isNotEmpty) {
                Hive.box<Tag>('tags').add(Tag(tagController.text));
                Navigator.pop(context);
              }
            },
            child: const Text("إضافة"),
          ),
        ],
      );
    },
  );
}

class ListViewSection extends StatelessWidget {
  const ListViewSection({
    super.key,
    required this.searchController,
    required this.themeProvider,
    required this.questions,
    required this.carouselController,
  });

  final TextEditingController searchController;
  final GeneralPrefrencesProvider themeProvider;
  final List<Question> questions;
  final CarouselSliderController carouselController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                themeProvider.searchQuery = value;
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                      onPressed: () {
                        themeProvider.searchQuery = "";
                        searchController.clear();
                      },
                      icon: Icon(Icons.clear)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "ابحث عن سؤال",
                  suffixIcon: const Icon(Icons.search)),
            ),
          ),
          questions
                  .where((element) =>
                      element.question.contains(themeProvider.searchQuery) ||
                      element.description!
                          .contains(themeProvider.searchQuery) ||
                      element.mosqueName.contains(themeProvider.searchQuery) ||
                      element.answered
                          .toString()
                          .contains(themeProvider.searchQuery))
                  .toList()
                  .isEmpty
              ? Expanded(
                  child: Center(
                      child: Text(
                          "لا توجد أسئلة عن: ${themeProvider.searchQuery}")))
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemCount: questions
                        .where((element) =>
                            element.question
                                .contains(themeProvider.searchQuery) ||
                            element.description!
                                .contains(themeProvider.searchQuery) ||
                            element.mosqueName
                                .contains(themeProvider.searchQuery) ||
                            element.answered.toString().contains(themeProvider
                                .searchQuery) // if nothing show all
                            ||
                            themeProvider.searchQuery.isEmpty)
                        .length,
                    itemBuilder: (context, index) {
                      final question = questions
                          .where((element) =>
                              element.question
                                  .contains(themeProvider.searchQuery) ||
                              element.description!
                                  .contains(themeProvider.searchQuery) ||
                              element.mosqueName
                                  .contains(themeProvider.searchQuery) ||
                              element.answered.toString().contains(themeProvider
                                  .searchQuery) // if nothing show all
                              ||
                              themeProvider.searchQuery.isEmpty)
                          .toList()[index];

                      return GestureDetector(
                        onLongPressStart: (LongPressStartDetails details) {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                            ),
                            items: [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.edit_outlined),
                                    Text("تعديل"),
                                  ],
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.delete_outline),
                                    Text("حذف"),
                                  ],
                                ),
                              ),
                            ],
                          ).then((value) {
                            if (value == 0) {
                              if (context.mounted) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditQuestionPage(
                                            context,
                                            questions
                                                .where((element) =>
                                                    element.question.contains(
                                                        themeProvider
                                                            .searchQuery) ||
                                                    element.description!
                                                        .contains(themeProvider
                                                            .searchQuery) ||
                                                    element.mosqueName.contains(
                                                        themeProvider
                                                            .searchQuery) ||
                                                    element.answered
                                                        .toString()
                                                        .contains(themeProvider
                                                            .searchQuery) // if nothing show all
                                                    ||
                                                    themeProvider
                                                        .searchQuery.isEmpty)
                                                .toList(),
                                            index)));
                              }
                            } else if (value == 1) {
                              // Delete mosque
                              if (context.mounted) {
                                deleteAQuestion(
                                    context,
                                    questions
                                        .where((element) =>
                                            element.question.contains(
                                                themeProvider.searchQuery) ||
                                            element.description!.contains(
                                                themeProvider.searchQuery) ||
                                            element.mosqueName.contains(
                                                themeProvider.searchQuery) ||
                                            element.answered
                                                .toString()
                                                .contains(themeProvider
                                                    .searchQuery) // if nothing show all
                                            ||
                                            themeProvider.searchQuery.isEmpty)
                                        .toList(),
                                    index);
                              }
                            }
                          });
                        },
                        child: Card.filled(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: themeProvider.showAnswer
                                      ? RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "${question.question}\n",
                                                style: TextStyle(
                                                    fontFamily: "Rubik",
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                    fontSize: 15),
                                              ),
                                              TextSpan(
                                                  text: question.description,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Scheherazade",
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer,
                                                      fontSize: 25)),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          question.question,
                                          style: TextStyle(
                                              fontFamily: "Rubik",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                              fontSize: 22),
                                        )),
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return QuestionView(
                                      index: index,
                                      carouselController: carouselController,
                                      questions: questions
                                          .where((element) =>
                                              element.question.contains(
                                                  themeProvider.searchQuery) ||
                                              element.description!.contains(
                                                  themeProvider.searchQuery) ||
                                              element.mosqueName.contains(
                                                  themeProvider.searchQuery) ||
                                              element.answered
                                                  .toString()
                                                  .contains(themeProvider
                                                      .searchQuery) // if nothing show all
                                              ||
                                              themeProvider.searchQuery.isEmpty)
                                          .toList());
                                }));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class MyTable extends StatelessWidget {
  final List<Question> allQuestions;

  const MyTable({super.key, required this.allQuestions});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> groupedQuestions = groupQuestions(allQuestions);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 780,
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(6),
            1: FlexColumnWidth(8),
            2: FlexColumnWidth(10),
          },
          border: TableBorder.all(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onSurface),
          children: [
            TableRow(
              decoration: BoxDecoration(
                  // only border radius of top left and right
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Theme.of(context).colorScheme.primaryContainer),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('المسألة',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('الوصف',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المساجد',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                      // make a small table to define check and cross icons and mean
                      Text('تم الشرح ✔️\n لم يتم الشرح ❌',
                          style: TextStyle(fontSize: 15))
                    ],
                  ),
                ),
              ],
            ),
            ...groupedQuestions.map((question) {
              return TableRow(
                children: [
                  TableRowInkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return QuestionView(
                            index: allQuestions.indexWhere((element) =>
                                element.question == question['question'] &&
                                element.description == question['description']),
                            carouselController: CarouselSliderController(),
                            questions: allQuestions);
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(question['question'],
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      question['description'],
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: question['mosques'].map<Widget>((mosque) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // open mosque page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MosquePage(
                                        mosqueName: mosque['mosqueName']),
                                  ),
                                );
                              },
                              child: Text(
                                " - ${mosque['mosqueName']}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              mosque['answered'] ? Icons.check : Icons.close,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
