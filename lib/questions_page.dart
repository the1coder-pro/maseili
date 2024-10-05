import 'package:animations/animations.dart';
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
                                        borderRadius: BorderRadius.circular(10)),
                                      hintText: "ابحث عن سؤال",
                                      prefixIcon: const Icon(Icons.search)),

                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: questions.where(
                                      (element) => element.question!.contains(themeProvider.searchQuery) || element.description!.contains(themeProvider.searchQuery) || element.mosqueName!.contains(themeProvider.searchQuery) || element.answered.toString().contains(themeProvider.searchQuery) // if nothing show all
                                    || themeProvider.searchQuery.isEmpty
                                  ).length,
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
                                              MaterialPageRoute(builder: (context) {
                                            return Scaffold(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              body: Stack(
                                                children: [
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints.expand(),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(themeProvider
                                                                .darkTheme
                                                            ? "assets/background_dark.png"
                                                            : "assets/background_light.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: [
                                                      // Padding(
                                                      //   padding: const EdgeInsets.all(20),
                                                      //   child: Row(
                                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //     children: [
                                                      //
                                                      //     Align(
                                                      //       alignment:
                                                      //       Alignment.centerLeft,
                                                      //       child: Padding(
                                                      //         padding:
                                                      //         const EdgeInsets.all(
                                                      //             8.0),
                                                      //         child: IconButton.filled(
                                                      //           style: ButtonStyle(
                                                      //               backgroundColor:
                                                      //               WidgetStateProperty.all(Theme
                                                      //                   .of(
                                                      //                   context)
                                                      //                   .colorScheme
                                                      //                   .onPrimaryContainer
                                                      //                   .withOpacity(
                                                      //                   0.5))),
                                                      //           icon: Icon(Icons.mosque,
                                                      //               color: Theme.of(
                                                      //                   context)
                                                      //                   .colorScheme
                                                      //                   .primaryContainer),
                                                      //           onPressed: () {
                                                      //             // for copy the question and to see what mosques have answerd this
                                                      //             // get all mosques that have same question
                                                      //             var same_questions = questions
                                                      //                 .where((element) =>
                                                      //                     element.question ==
                                                      //                     question.question)
                                                      //                 .toList();
                                                      //
                                                      //
                                                      //             showDialog(
                                                      //               context: context,
                                                      //               builder: (context) =>  Dialog(
                                                      //                 child: ListView.builder(
                                                      //                     itemCount: same_questions.length,
                                                      //                     itemBuilder: (context, index){
                                                      //
                                                      //
                                                      //                       return DataTable(
                                                      //                         columns: const [
                                                      //                           DataColumn(label: Text("المسجد")),
                                                      //                           DataColumn(label: Text("الوصف")),
                                                      //                           DataColumn(label: Text("المشروحة"))
                                                      //                         ],
                                                      //                         rows: [
                                                      //                           DataRow(cells: [
                                                      //                             DataCell(Text(same_questions[index].mosqueName)),
                                                      //                             DataCell(Text(same_questions[index].description!)),
                                                      //                             DataCell(Icon(
                                                      //                                 same_questions[index].answered
                                                      //                                     ? Icons.check_circle
                                                      //                                     : Icons.cancel,
                                                      //                                 color: same_questions[index].answered
                                                      //                                     ? Colors.green
                                                      //                                     : Colors.red))
                                                      //                           ])
                                                      //                         ],
                                                      //                       );
                                                      //
                                                      //
                                                      //                     }
                                                      //
                                                      //                 ),
                                                      //               ),
                                                      //             );
                                                      //           },
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //       Align(
                                                      //         alignment:
                                                      //         Alignment.centerRight,
                                                      //         child: Padding(
                                                      //           padding:
                                                      //           const EdgeInsets.all(
                                                      //               8.0),
                                                      //           child: IconButton.filled(
                                                      //             style: ButtonStyle(
                                                      //                 backgroundColor:
                                                      //                 WidgetStateProperty.all(Theme
                                                      //                     .of(
                                                      //                     context)
                                                      //                     .colorScheme
                                                      //                     .onPrimaryContainer
                                                      //                     .withOpacity(
                                                      //                     0.5))),
                                                      //             icon: Icon(Icons.close,
                                                      //                 color: Theme.of(
                                                      //                     context)
                                                      //                     .colorScheme
                                                      //                     .primaryContainer),
                                                      //             onPressed: () {
                                                      //               Navigator.pop(context);
                                                      //             },
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //   ],),
                                                      // ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(30),
                                                        child: Align(
                                                          alignment:
                                                          Alignment.centerRight,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: IconButton.outlined(
                                                              style: ButtonStyle(

                                                                  backgroundColor:
                                                                  WidgetStateProperty.all(Theme
                                                                      .of(
                                                                      context)
                                                                      .colorScheme
                                                                      .onPrimaryContainer
                                                                      .withOpacity(
                                                                      0.5))),
                                                              icon: Icon(Icons.close,
                                                                  color: Theme.of(
                                                                      context)
                                                                      .colorScheme
                                                                      .primaryContainer),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 60),
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Center(
                                                                child: Text(
                                                                    question
                                                                        .question!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    style: TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .colorScheme
                                                                            .surface
                                                                            .withOpacity(
                                                                                0.7),
                                                                        fontFamily:
                                                                            "Scheherazade",
                                                                        letterSpacing:
                                                                            0,
                                                                        fontSize:
                                                                            20)),
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
                                                              const EdgeInsets.only(
                                                                  left: 45, right:45),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                    question
                                                                        .description!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    style: TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .colorScheme
                                                                            .surface,
                                                                        fontFamily:
                                                                            "Scheherazade",
                                                                        letterSpacing:
                                                                            0,
                                                                        fontSize:
                                                                            25)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  )
                                                ],
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
