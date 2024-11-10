import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/add_questions_page.dart';
import 'package:masel/mosque_page.dart';
import 'package:masel/question_model.dart';
import 'package:masel/settings.dart';
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
                                Icons.table_chart_outlined,
                                size: 20,
                              ),
                            ),
                            value: QuestionsView.tableView),
                        ButtonSegment(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Icon(
                                Icons.list_outlined,
                                size: 20,
                              ),
                            ),
                            value: QuestionsView.listView),
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
                                              editDialog(
                                                  context, questions, index);
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
                                                child: Text(question.question,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                        fontFamily:
                                                            "Scheherazade",
                                                        letterSpacing: 0)),
                                              ),
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
}

List<Question> filterUniqueQuestions(List<Question> questions) {
  final uniqueQuestions = <Question>{};

  for (var question in questions) {
    uniqueQuestions.add(question);
  }

  return uniqueQuestions.toList();
}

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.carouselController,
    required this.questions,
    required this.index,
  });

  final CarouselSliderController carouselController;
  final List<Question> questions;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_new.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.outlined(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withOpacity(0.5))),
                    icon: Icon(Icons.close,
                        color: Theme.of(context).colorScheme.primaryContainer),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    initialPage: index,
                    enableInfiniteScroll: false,
                    height: MediaQuery.of(context).size.height,
                  ),
                  carouselController: carouselController,
                  items: questions
                      .map((question) => Column(children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 8),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Center(
                                      child: Text(question.question,
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontFamily: "Scheherazade",
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0,
                                              fontSize: 25)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: AutoSizeText(
                                        question.description!,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontFamily: "Scheherazade",
                                            letterSpacing: 0),
                                        minFontSize: 18,
                                        stepGranularity: 18,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]))
                      .toList()),
            ),
            if (questions.length > 1)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // two buttons to forward and backward
                      IconButton.outlined(
                        iconSize: 30,
                        icon: Icon(Icons.arrow_back,
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        onPressed: () {
                          carouselController.previousPage();
                        },
                      ),
                      const SizedBox(width: 20),
                      IconButton.outlined(
                        iconSize: 30,
                        icon: Icon(Icons.arrow_forward,
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        onPressed: () {
                          carouselController.nextPage();
                        },
                      ),
                    ]),
              ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
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

class MyTable extends StatelessWidget {
  final List<Question> allQuestions;

  MyTable({required this.allQuestions});

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
            3: FlexColumnWidth(4),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('النوع',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      question['isParagraph'] ? "خطبة" : "مسألة",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
