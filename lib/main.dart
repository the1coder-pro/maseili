import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/mosque_model.dart';
import 'package:masel/mosque_page.dart';
import 'package:masel/mosques_page.dart';
import 'package:masel/question_model.dart';
import 'package:masel/questions_page.dart';
import 'package:masel/settings.dart';
import 'package:masel/settings_page.dart';
import 'package:masel/theme.dart';
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

const textTheme = TextTheme(
  displayLarge: TextStyle(fontFamily: "Lateef", fontSize: 151),
  displayMedium: TextStyle(fontFamily: "Lateef", fontSize: 94),
  displaySmall: TextStyle(fontFamily: "Lateef", fontSize: 76),
  headlineMedium: TextStyle(fontFamily: "Lateef", fontSize: 54),
  headlineSmall: TextStyle(fontFamily: "Lateef", fontSize: 38),
  titleLarge: TextStyle(fontFamily: "Lateef", fontSize: 31),
  titleMedium: TextStyle(fontFamily: "Lateef", fontSize: 25),
  titleSmall: TextStyle(fontFamily: "Lateef", fontSize: 22),
  bodyLarge: TextStyle(fontFamily: "Vazirmatn", fontSize: 23),
  bodyMedium: TextStyle(fontFamily: "Vazirmatn", fontSize: 21),
  labelLarge: TextStyle(fontFamily: "Vazirmatn", fontSize: 21),
  bodySmall: TextStyle(fontFamily: "Vazirmatn", fontSize: 18),
  labelSmall: TextStyle(fontFamily: "Vazirmatn", fontSize: 15),
);

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
            textTheme: textTheme,
            colorScheme: MaterialTheme.lightScheme(),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            textTheme: textTheme,
            colorScheme: MaterialTheme.darkScheme(),
            useMaterial3: true,
          ),
          home: const MainPage(),
          themeMode: themeMode.darkTheme ? ThemeMode.dark : ThemeMode.light,
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  Widget selectedPage(int index) {
    switch (index) {
      case 0:
        return const MosquesPage();
      case 1:
        return const QuestionsPage();
      case 2:
        return const SettingsPage();
      default:
        return const MosquesPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/background_new.png"), context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: selectedPage(_selectedIndex),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.mosque),
                icon: Icon(Icons.mosque_outlined),
                label: 'المساجد',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.question_answer),
                icon: Icon(Icons.question_answer_outlined),
                label: 'المسائل',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.settings),
                icon: Icon(Icons.settings_outlined),
                label: 'الإعدادات',
              ),
            ],
          ),
        ));
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
  const AddQuestionDialog({super.key, this.mosqueName});

  final String? mosqueName;

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
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "المسألة",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
                    widget.mosqueName ?? "",
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

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key, this.mosqueName});

  final String? mosqueName;

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isParagraph = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة مسألة"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (questionController.text.isNotEmpty) {
                  Box<Question> questionsBox = Hive.box<Question>('questions');
                  questionsBox.add(Question(
                      questionController.text,
                      descriptionController.text,
                      false,
                      widget.mosqueName ?? "",
                      isParagraph));
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "المسألة",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
        ),
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
