import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m3e_card_list/m3e_card_list.dart';
import 'package:masel/dialogs/create_tag_dialog.dart';
import 'package:masel/main.dart';
import 'package:masel/models/tag_model.dart';
import 'package:masel/pages/add_questions_page.dart';
import 'package:masel/dialogs/delete_dialog.dart';
import 'package:masel/components/helper_functions.dart';
import 'package:masel/components/question_view.dart';
import 'package:masel/models/question_model.dart';
import 'package:masel/components/preferences.dart';
import 'package:masel/pages/mosque_content_page.dart';
import 'package:provider/provider.dart';

class QuestionsPage extends StatefulWidget {
  final bool isGridView;
  const QuestionsPage({super.key, required this.isGridView});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  TextEditingController searchController = TextEditingController();
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<GeneralPrefrencesProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body: ValueListenableBuilder<Box<Question>>(
                valueListenable: Hive.box<Question>('questions').listenable(),
                builder: (BuildContext context, box, _) {
                  var allQuestions = box.values.toList();
                  var questions =
                      filterUniqueQuestions(allQuestions).reversed.toList();
                  return ValueListenableBuilder<Box<Tag>>(
                      valueListenable: Hive.box<Tag>('tags')
                          .listenable(), // for tags
                      builder: (BuildContext context, box, _) {
                        var tags = box.values.toList();
                        if (tags.isEmpty) {
                           return Center(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 M3EContainer.gem(
                                   width: 130,
                                   height: 130,
                                   color: Theme.of(context).colorScheme.primaryContainer,
                                   child: Icon(
                                     Icons.category_outlined,
                                     size: 50,
                                     color: Theme.of(context).colorScheme.primary,
                                   ),
                                 ),
                                 const SizedBox(height: 16),
                                 const Text(
                                    "لا توجد تصنيفات",
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
                        // return grid of tags
                        return GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            final baseColor = tags[index].color.toColor;
                            Color adjustColor;
                            if (Theme.of(context).brightness == Brightness.dark) {
                              if (baseColor.value == Colors.blue.shade600.value) {
                                adjustColor = Colors.blue.shade300;
                              } else if (baseColor.value == Colors.red.shade600.value) {
                                adjustColor = Colors.red.shade300;
                              } else if (baseColor.value == Colors.green.shade600.value) {
                                adjustColor = Colors.green.shade300;
                              } else if (baseColor.value == Colors.amber.shade600.value) {
                                adjustColor = Colors.amber.shade300;
                              } else if (baseColor.value == Colors.purple.shade600.value) {
                                adjustColor = Colors.purple.shade300;
                              } else if (baseColor.value == Colors.orange.shade600.value) {
                                adjustColor = Colors.orange.shade300;
                              } else if (baseColor.value == Colors.pink.shade600.value) {
                                adjustColor = Colors.pink.shade300;
                              } else if (baseColor.value == Colors.teal.shade600.value) {
                                adjustColor = Colors.teal.shade300;
                              } else if (baseColor.value == Colors.brown.shade600.value) {
                                adjustColor = Colors.brown.shade300;
                              } else if (baseColor.value == Colors.grey.shade600.value) {
                                adjustColor = Colors.grey.shade400;
                              } else {
                                adjustColor = baseColor;
                              }
                            } else {
                              if (baseColor.value == Colors.blue.shade300.value) {
                                adjustColor = Colors.blue.shade600;
                              } else if (baseColor.value == Colors.red.shade300.value) {
                                adjustColor = Colors.red.shade600;
                              } else if (baseColor.value == Colors.green.shade300.value) {
                                adjustColor = Colors.green.shade600;
                              } else if (baseColor.value == Colors.amber.shade300.value) {
                                adjustColor = Colors.amber.shade600;
                              } else if (baseColor.value == Colors.purple.shade300.value) {
                                adjustColor = Colors.purple.shade600;
                              } else if (baseColor.value == Colors.orange.shade300.value) {
                                adjustColor = Colors.orange.shade600;
                              } else if (baseColor.value == Colors.pink.shade300.value) {
                                adjustColor = Colors.pink.shade600;
                              } else if (baseColor.value == Colors.teal.shade300.value) {
                                adjustColor = Colors.teal.shade600;
                              } else if (baseColor.value == Colors.brown.shade300.value) {
                                adjustColor = Colors.brown.shade600;
                              } else if (baseColor.value == Colors.grey.shade400.value) {
                                adjustColor = Colors.grey.shade600;
                              } else {
                                adjustColor = baseColor;
                              }
                            }

                            final textColor = adjustColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

                            return Card.filled(
                              margin: EdgeInsets.zero,
                              color: adjustColor,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                      final filteredList = questions
                                          .where((element) {
                                            if (element.tags == null) {
                                              return false;
                                            }
                                            return element.tags!
                                                .contains(tags[index].name);
                                          })
                                          .toList();
                                      if (filteredList.isEmpty) {
                                        return Directionality(
                                          textDirection:
                                              TextDirection.rtl,
                                          child: Scaffold(
                                            appBar: AppBar(
                                              title: Text(tags[index].name),
                                            ),
                                            body: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  M3EContainer.gem(
                                                    width: 130,
                                                    height: 130,
                                                    color: Theme.of(context).colorScheme.primaryContainer,
                                                    child: Icon(
                                                      Icons.assignment_outlined,
                                                      size: 50,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  const Text(
                                                    "لا توجد أسئلة بهذا التصنيف",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Directionality(
                                        textDirection:
                                            TextDirection.rtl,
                                        child: Scaffold(
                                          appBar: AppBar(
                                            title: Text(tags[index].name),
                                          ),
                                          body: ListViewSection(
                                            searchController:
                                                searchController,
                                            themeProvider:
                                                themeProvider,
                                            questions: filteredList,
                                            carouselController:
                                                carouselController,
                                          ),
                                        ),
                                      );
                                    }));
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        tags[index].name,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Rubik",
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                }),
            floatingActionButton: FloatingActionButton(
              elevation: 3,
              onPressed: () {
                createTagDialog(context);
              },
              child: const Icon(Icons.add),
            )));
  }
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: M3ECardList.builder(
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
                          child: InkWell(
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: themeProvider.showAnswer
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          question.question,
                                          style: TextStyle(
                                              fontFamily: "Rubik",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          question.description ?? "",
                                          style: TextStyle(
                                              fontFamily: "Scheherazade",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                              fontSize: 22),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      question.question,
                                      style: TextStyle(
                                          fontFamily: "Rubik",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
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
        width: 900,
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(6),
            1: FlexColumnWidth(8),
            2: FlexColumnWidth(10),
            3: FlexColumnWidth(8),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('التصنيف',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      question['tags'] ?? "",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Theme.of(context).colorScheme.onSurface),
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
