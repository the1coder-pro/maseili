import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/main.dart';
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
                final questions = value.values.toList();
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
                                          element.answered.toString().contains(
                                              themeProvider
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                // columns (question, description, mosque)
                                columns: const [
                                  DataColumn(label: Text("السؤال")),
                                  DataColumn(label: Text("الوصف")),
                                  DataColumn(label: Text("المسجد")),
                                  DataColumn(label: Text("مشروحة"))
                                ],
                                rows: questions
                                    .map((question) => DataRow(cells: [
                                          DataCell(Text(question.question)),
                                          DataCell(SizedBox(
                                              width: 300,
                                              child:
                                                  Text(question.description!))),
                                          DataCell(Text(question.mosqueName)),
                                          DataCell(Icon(
                                              question.answered
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: question.answered
                                                  ? Colors.green
                                                  : Colors.red))
                                        ]))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 3,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddQuestionDialog(),
                );
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
