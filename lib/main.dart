import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/mosque_model.dart';
import 'package:masel/question_model.dart';
import 'package:masel/settings.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Mosque>(MosqueAdapter());
  Hive.registerAdapter<Question>(QuestionAdapter());
  await Hive.openBox<Mosque>('mosques');
  await Hive.openBox<Question>('questions');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => themeChangeProvider,
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeMode, _) => MaterialApp(
          title: 'مسائل بين الفرضين',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontFamily: "Lateef", fontSize: 151),
              displayMedium: TextStyle(fontFamily: "Lateef", fontSize: 94),
              displaySmall: TextStyle(fontFamily: "Lateef", fontSize: 76),
              headlineMedium: TextStyle(fontFamily: "Lateef", fontSize: 54),
              headlineSmall: TextStyle(fontFamily: "Lateef", fontSize: 38),
              titleLarge: TextStyle(fontFamily: "Lateef", fontSize: 31),
              titleMedium: TextStyle(fontFamily: "Lateef", fontSize: 25),
              titleSmall: TextStyle(fontFamily: "Lateef", fontSize: 22),
              bodyLarge: TextStyle(fontFamily: "Rubik", fontSize: 23),
              bodyMedium: TextStyle(fontFamily: "Rubik", fontSize: 21),
              labelLarge: TextStyle(fontFamily: "Rubik", fontSize: 21),
              bodySmall: TextStyle(fontFamily: "Rubik", fontSize: 18),
              labelSmall: TextStyle(fontFamily: "Rubik", fontSize: 15),
            ),
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF83d0da),
                brightness:
                    themeMode.darkTheme ? Brightness.dark : Brightness.light),
            useMaterial3: true,
          ),
          themeMode: themeMode.darkTheme ? ThemeMode.dark : ThemeMode.light,
          home: const MyHomePage(),
        ),
      ),
    );
  }
}

enum ViewType { gridView, listView }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();

  void addMosque() {
    if (controller.text.isNotEmpty) {
      Box<Mosque> mosquesBox = Hive.box<Mosque>('mosques');
      mosquesBox.add(Mosque(controller.text));
      Navigator.pop(context);
    }
  }

  Set<ViewType> selected = {ViewType.gridView};

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkThemeProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("المساجد"),
          centerTitle: true,
          leading: IconButton.outlined(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: SegmentedButton<ViewType>(
                  onSelectionChanged: (Set<ViewType> value) {
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
                            Icons.grid_view_outlined,
                            size: 20,
                          ),
                        ),
                        value: ViewType.gridView),
                    ButtonSegment(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Icon(
                            Icons.list_outlined,
                            size: 20,
                          ),
                        ),
                        value: ViewType.listView),
                  ],
                  selected: selected),
            )
          ],
        ),
        body: Center(
          child: ValueListenableBuilder<Box<Mosque>>(
            valueListenable: Hive.box<Mosque>('mosques').listenable(),
            builder: (context, box, _) {
              var mosques = box.values.toList();
              if (mosques.isEmpty) {
                return const Text("لا توجد مساجد.",
                    style: TextStyle(fontSize: 25));
              }
              return PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverse: selected.contains(ViewType.listView),
                  transitionBuilder: (child, animation, secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: selected.contains(ViewType.listView)
                      ? ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: mosques.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Theme.of(context).colorScheme.surface,
                              elevation: 0,
                              child: ListTile(
                                splashColor:
                                    Theme.of(context).colorScheme.surface,
                                trailing: const Icon(
                                  Icons.arrow_back_outlined,
                                  textDirection: TextDirection.ltr,
                                ),
                                title: Text(mosques[index].name,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MosquePage(
                                          mosqueName: mosques[index].name),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  deleteMosque(context, mosques, index);
                                },
                              ),
                            );
                          },
                        )
                      : GridView.builder(
                          itemCount: box.values.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return Card(
                              color: Theme.of(context).colorScheme.surface,
                              elevation: 0,
                              child: GestureDetector(
                                // onLongPress show dialog to delete mosque
                                onLongPress: () {
                                  deleteMosque(context, mosques, index);
                                },
                                onTap: () {
                                  // open new scaffold with app the name of it is the opened mosque name
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MosquePage(
                                          mosqueName: mosques[index].name),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder,
                                        size: 180,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                      SizedBox(
                                        width: 130,
                                        height: 100,
                                        child: Center(
                                          child: Text(
                                            mosques[index].name,
                                            maxLines: 2,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              // overflow: TextOverflow.fade,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 3,
          onPressed: () {
            controller.text = "";

            showDialog(
              context: context,
              builder: (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Text("إضافة مسجد"),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "اسم المسجد",
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("إلغاء"),
                    ),
                    FilledButton(
                      onPressed: addMosque,
                      child: const Text("إضافة"),
                    ),
                  ],
                ),
              ),
            );
          },
          tooltip: 'إضافة مسجد',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<dynamic> deleteMosque(
      BuildContext context, List<Mosque> mosques, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.delete_outline),
            iconColor: Theme.of(context).colorScheme.error,
            title: const Text("حذف المسجد"),
            content: const Text("هل أنت متأكد من حذف المسجد؟"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("إلغاء"),
              ),
              FilledButton(
                onPressed: () {
                  mosques[index].delete();
                  // delete all questions related to this mosque
                  Hive.box<Question>('questions')
                      .values
                      .where((question) =>
                          question.mosqueName == mosques[index].name)
                      .toList()
                      .forEach((question) {
                    question.delete();
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
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkThemeProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("الإعدادات"),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SwitchListTile(
                        title: const Text("الوضع الليلي"),
                        value: themeMode.darkTheme,
                        onChanged: (value) {
                          themeMode.darkTheme = value;
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 30),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("مسائل بين الفرضين",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: "Lateef",
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8))),
                ),
              )
            ],
          ),
        ));
  }
}

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
    final themeMode = Provider.of<DarkThemeProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: pageMode == PageMode.normal
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.secondaryContainer,
              title: Text(widget.mosqueName),
              centerTitle: true,
              leading: pageMode == PageMode.normal
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          pageMode = PageMode.normal;
                        });
                      }),
              // more actions
              actions: pageMode == PageMode.select
                  ? [
                      IconButton(
                        icon: const Icon(Icons.copy_all_outlined),
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
                            icon: const Icon(Icons.delete_outlined),
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
                          PopupMenuButton(itemBuilder: (context) {
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
                          }, onSelected: (value) {
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
                        .toList();
                    if (questions.isEmpty) {
                      return const Center(
                        child: Text("لا توجد مسائل.",
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
                                ? const Color(0xFF83d0da).withOpacity(0.2)
                                : const Color(0xFF83d0da).withOpacity(0.4),
                            leading: Icon(
                              questions[index].answered
                                  ? Icons.check_circle_outline
                                  : Icons.circle_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            trailing: const Icon(Icons.article_outlined),
                            splashColor: themeMode.darkTheme
                                ? const Color(0xFF83d0da).withOpacity(0.2)
                                : const Color(0xFF83d0da).withOpacity(0.4),
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
                                onChanged: (value) {
                                  questions[index].answered = value!;
                                  questions[index].save();
                                },
                                secondary: PopupMenuButton(
                                  itemBuilder: (context) =>
                                      const <PopupMenuEntry>[
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
                                    if (value == 0) {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CopyToMultipleMosquesDialog(
                                                  question: questions[index]));
                                    } else if (value == 1) {
                                      editDialog(context, questions, index);
                                    } else if (value == 2) {
                                      deleteDialog(context, questions, index);
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
                          builder: (context) =>
                              AddQuestionDialog(mosqueName: widget.mosqueName),
                        );
                      },
                      tooltip: 'إضافة مسألة',
                      child: const Icon(Icons.add_comment_outlined),
                    )),
    );
  }

  Future<dynamic> editDialog(
      BuildContext context, List<Question> questions, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        final TextEditingController questionController =
            TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        questionController.text = questions[index].question;
        descriptionController.text = questions[index].description ?? "";
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text("تعديل المسألة"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    hintText: "المسألة",
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  minLines: 4,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "الوصف",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("إلغاء"),
              ),
              FilledButton(
                onPressed: () {
                  if (questionController.text.isNotEmpty) {
                    questions[index].question = questionController.text;
                    questions[index].description = descriptionController.text;
                    questions[index].save();
                    Navigator.pop(context);
                  }
                },
                child: const Text("حفظ"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> deleteDialog(
      BuildContext context, List<Question> questions, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.delete_outline),
            iconColor: Theme.of(context).colorScheme.error,
            title: const Text("حذف المسألة"),
            content: const Text("هل أنت متأكد من حذف المسألة؟"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("إلغاء"),
              ),
              FilledButton(
                onPressed: () {
                  questions[index].delete();
                  Navigator.pop(context);
                },
                child: const Text("حذف"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ParagraphPage extends StatefulWidget {
  const ParagraphPage({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<ParagraphPage> createState() => _ParagraphPageState();
}

class _ParagraphPageState extends State<ParagraphPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // edit and delete buttons
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final TextEditingController questionController =
                        TextEditingController();
                    final TextEditingController descriptionController =
                        TextEditingController();
                    questionController.text = widget.question.question;
                    descriptionController.text =
                        widget.question.description ?? "";
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: const Text("تعديل الخطبة"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: questionController,
                              decoration: const InputDecoration(
                                hintText: "الخطبة",
                              ),
                            ),
                            TextField(
                              controller: descriptionController,
                              minLines: 3,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: "الوصف",
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("إلغاء"),
                          ),
                          FilledButton(
                            onPressed: () {
                              if (questionController.text.isNotEmpty) {
                                widget.question.question =
                                    questionController.text;
                                widget.question.description =
                                    descriptionController.text;
                                widget.question.save();
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            child: const Text("حفظ"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // delete button
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        icon: const Icon(Icons.delete_outline),
                        iconColor: Theme.of(context).colorScheme.error,
                        title: const Text("حذف الخطبة"),
                        content: const Text("هل أنت متأكد من حذف الخطبة؟"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("إلغاء"),
                          ),
                          FilledButton(
                            onPressed: () {
                              widget.question.delete();
                              Navigator.pop(context);
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
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 5),
              child: Text(widget.question.question,
                  style: const TextStyle(fontSize: 30)),
            ),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.question.description!),
              ),
            ),

            CheckboxListTile(
              value: widget.question.answered,
              title: const Text("تم شرحها"),
              onChanged: (value) {
                setState(() {
                  widget.question.answered = value!;
                  widget.question.save();
                });
              },
            ),

            // add a button to copy this paragraph to other mosques
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FilledButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => CopyToMultipleMosquesDialog(
                          question: widget.question));
                },
                child: const Text("نسخ"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class AddQuestionDialog extends StatefulWidget {
  const AddQuestionDialog({super.key, required this.mosqueName});

  final String mosqueName;

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isParagraph = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text("إضافة مسألة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                hintText: "المسألة",
              ),
            ),
            TextField(
              controller: descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "الوصف",
              ),
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
                title: const Text(
                  "هل هذه خطبة؟",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18),
                ),
                value: isParagraph,
                onChanged: (value) {
                  setState(() {
                    isParagraph = value!;
                  });
                })
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          FilledButton(
            onPressed: () {
              if (questionController.text.isNotEmpty) {
                Box<Question> questionsBox = Hive.box<Question>('questions');
                questionsBox.add(Question(
                    questionController.text,
                    descriptionController.text,
                    false,
                    widget.mosqueName,
                    isParagraph));
                Navigator.pop(context);
              }
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }
}

class CopyMultipleQuestionsToMosques extends StatefulWidget {
  const CopyMultipleQuestionsToMosques(
      {super.key, required this.mosqueName, required this.selectedQuestion});

  final String mosqueName;
  final List<Question> selectedQuestion;

  @override
  State<CopyMultipleQuestionsToMosques> createState() =>
      _CopyMultipleQuestionsToMosquesState();
}

class _CopyMultipleQuestionsToMosquesState
    extends State<CopyMultipleQuestionsToMosques> {
  List selectedMosques = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(Icons.mosque_outlined),
        title: const Text("نسخ المسائل إلى"),
        content: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 300,
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var mosque in Hive.box<Mosque>('mosques').values.toList())
                if (mosque.name != widget.mosqueName)
                  CheckboxListTile(
                    title: Text(
                      mosque.name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 18),
                    ),
                    value: selectedMosques.contains(mosque.name),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedMosques.add(mosque.name);
                        } else {
                          selectedMosques.remove(mosque.name);
                        }
                      });
                    },
                  ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, PageMode.normal);
            },
            child: const Text("إلغاء"),
          ),
          FilledButton(
            onPressed: () {
              // add question to selected mosques
              for (var mosqueName in selectedMosques) {
                for (var question in widget.selectedQuestion) {
                  Box<Question> questionsBox = Hive.box<Question>('questions');
                  questionsBox.add(Question(
                      question.question,
                      question.description,
                      false,
                      mosqueName,
                      question.isParagraph));
                }
              }

              Navigator.pop(context, PageMode.normal);
            },
            child: const Text("نسخ"),
          ),
        ],
      ),
    );
  }
}

class CopyToMultipleMosquesDialog extends StatefulWidget {
  const CopyToMultipleMosquesDialog({super.key, required this.question});

  final Question question;

  @override
  State<CopyToMultipleMosquesDialog> createState() =>
      _CopyToMultipleMosquesDialogState();
}

class _CopyToMultipleMosquesDialogState
    extends State<CopyToMultipleMosquesDialog> {
  List selectedMosques = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(Icons.mosque_outlined),
        title: widget.question.isParagraph == true
            ? const Text("نسخ الخطبة إلى")
            : const Text("نسخ المسألة إلي"),
        content: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 300,
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var mosque in Hive.box<Mosque>('mosques').values.toList())
                if (mosque.name != widget.question.mosqueName)
                  CheckboxListTile(
                    title: Text(
                      mosque.name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 18),
                    ),
                    value: selectedMosques.contains(mosque.name),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedMosques.add(mosque.name);
                        } else {
                          selectedMosques.remove(mosque.name);
                        }
                      });
                    },
                  ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          FilledButton(
              onPressed: () {
                // add question to selected mosques
                for (var mosqueName in selectedMosques) {
                  Box<Question> questionsBox = Hive.box<Question>('questions');
                  questionsBox.add(Question(
                      widget.question.question,
                      widget.question.description,
                      false,
                      mosqueName,
                      widget.question.isParagraph));
                }

                Navigator.pop(context);
              },
              child: const Text("نسخ")),
        ],
      ),
    );
  }
}
