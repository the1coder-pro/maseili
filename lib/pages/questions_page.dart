import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/pages/add_questions_page.dart';
import 'package:masel/dialogs/delete_dialog.dart';
import 'package:masel/components/helper_functions.dart';
import 'package:masel/components/question_view.dart';
import 'package:masel/models/question_model.dart';
import 'package:masel/components/settings.dart';
import 'package:provider/provider.dart';

enum QuestionsView { tableView, listView }

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  Set<QuestionsView> selected = {QuestionsView.listView};

  TextEditingController searchController = TextEditingController();
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("المسائل"),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  child: SegmentedButton<QuestionsView>(
                      onSelectionChanged: (Set<QuestionsView> value) {
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
                                Icons.list_outlined,
                                size: 20,
                              ),
                            ),
                            value: QuestionsView.listView),
                        ButtonSegment(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Icon(
                                Icons.table_chart_outlined,
                                size: 20,
                              ),
                            ),
                            value: QuestionsView.tableView),
                      ],
                      selected: selected),
                )
              ],
            ),
            body: ValueListenableBuilder<Box<Question>>(
              // show all questions in a list

              valueListenable: Hive.box<Question>('questions').listenable(),
              builder: (BuildContext context, value, _) {
                var allQuestions = value.values.toList();
                var questions = filterUniqueQuestions(allQuestions);
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
                    child: selected.contains(QuestionsView.listView)
                        ? Padding(
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
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: "ابحث عن سؤال",
                                        suffixIcon: const Icon(Icons.search)),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: questions
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
                                        .length,
                                    itemBuilder: (context, index) {
                                      final question = questions
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
                                          .toList()[index];

                                      return GestureDetector(
                                        onLongPressStart:
                                            (LongPressStartDetails details) {
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(Icons.delete_outline),
                                                    Text("حذف"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ).then((value) {
                                            if (value == 0) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditQuestionPage(
                                                              context,
                                                              questions,
                                                              index)));
                                            } else if (value == 1) {
                                              // Delete mosque
                                              deleteAQuestion(
                                                  context, questions, index);
                                            }
                                          });
                                        },
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
                                              title: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              "${question.question}\n",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Rubik",
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSecondaryContainer,
                                                              fontSize: 15),
                                                        ),
                                                        TextSpan(
                                                            text: question
                                                                .description,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Scheherazade",
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSecondaryContainer,
                                                                fontSize: 25)),
                                                      ],
                                                    ),
                                                  )),
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return QuestionView(
                                                      index: index,
                                                      carouselController:
                                                          carouselController,
                                                      questions: questions);
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
                          )
                        : ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyTable(allQuestions: allQuestions),
                              ),
                            ],
                          ));
              },
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 3,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddQuestionPage();
                }));
              },
              child: const Icon(Icons.add),
            )));
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
                  child: Text('المساجد',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
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
                            Text(
                              " - ${mosque['mosqueName']}",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
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
