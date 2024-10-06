import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/main.dart';
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
                            icon: Center(
                              child: Icon(
                                Icons.table_chart_outlined,
                                size: 20,
                              ),
                            ),
                            value: QuestionsView.tableView),
                        ButtonSegment(
                            icon: Center(
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
                    child: Text("لا توجد أسئلة"),
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
                                      prefixIcon: const Icon(Icons.search)),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: questions
                                      .where((element) =>
                                          element.question!.contains(
                                              themeProvider.searchQuery) ||
                                          element.description!.contains(
                                              themeProvider.searchQuery) ||
                                          element.mosqueName!.contains(
                                              themeProvider.searchQuery) ||
                                          element.answered.toString().contains(
                                              themeProvider
                                                  .searchQuery) // if nothing show all
                                          ||
                                          themeProvider.searchQuery.isEmpty)
                                      .length,
                                  itemBuilder: (context, index) {
                                    final question = questions[index];

                                    return Card.filled(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      child: ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(question.description!,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontFamily: "Scheherazade",
                                                  letterSpacing: 0)),
                                        ),
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Scaffold(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              body: Container(
                                                constraints:
                                                    const BoxConstraints
                                                        .expand(),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/background_new.png"),
                                                    // image: AssetImage(themeProvider
                                                    //         .darkTheme
                                                    //     ? "assets/background_dark.png"
                                                    //     : "assets/background_light.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              30),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: IconButton
                                                              .outlined(
                                                            style: ButtonStyle(
                                                                backgroundColor: WidgetStateProperty.all(Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimaryContainer
                                                                    .withOpacity(
                                                                        0.5))),
                                                            icon: Icon(
                                                                Icons.close,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primaryContainer),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: CarouselSlider(
                                                          options:
                                                              CarouselOptions(
                                                                enableInfiniteScroll: false,
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                          ),
                                                          carouselController:
                                                              carouselController,
                                                          items: questions
                                                              .map((question) =>
                                                                  Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                            height:
                                                                                40),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Flexible(
                                                                                child: Center(
                                                                                  child: Text(question.question, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white.withOpacity(0.7), fontFamily: "Scheherazade", letterSpacing: 0, fontSize: 20)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                20),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 20, right: 20),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text(question.description!, textAlign: TextAlign.right, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontFamily: "Scheherazade", letterSpacing: 0, fontSize: 25)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]))
                                                              .toList()),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                        // two buttons to forward and backward
                                                        IconButton.outlined(
                                                          iconSize: 30,
                                                          icon: Icon(Icons
                                                              .arrow_back, color: Theme.of(context).colorScheme.primaryContainer),
                                                          onPressed: () {
                                                            carouselController
                                                                .previousPage();
                                                          },
                                                        ),
                                                        const SizedBox(width: 20),
                                                        IconButton.outlined(
                                                          iconSize: 30,

                                                          icon: Icon(Icons
                                                              .arrow_forward, color: Theme.of(context).colorScheme.primaryContainer),
                                                          onPressed: () {
                                                            carouselController
                                                                .nextPage();
                                                          },
                                                        ),
                                                      ]),
                                                    ),
                                                      const SizedBox(height: 20)
                                                  ],
                                                ),
                                              ),
                                            );
                                          }));
                                        },
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
                                          DataCell(Text(question.description!)),
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
                // add a new question
                showDialog(
                  context: context,
                  builder: (context) => const AddQuestionDialog(),
                );
              },
              child: const Icon(Icons.add),
            )));
  }
}
