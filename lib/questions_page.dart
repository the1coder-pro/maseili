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
                          child: ListView.builder(
                            itemCount: questions.length,
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
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: IconButton.filled(
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
                                                const SizedBox(height: 100),
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
                                                        const EdgeInsets.all(
                                                            45),
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
