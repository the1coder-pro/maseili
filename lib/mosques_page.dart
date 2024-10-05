import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/mosque_model.dart';
import 'package:masel/mosque_page.dart';
import 'package:masel/question_model.dart';
import 'package:masel/settings_page.dart';

enum ViewType { gridView, listView }

class MosquesPage extends StatefulWidget {
  const MosquesPage({super.key});

  @override
  State<MosquesPage> createState() => _MosquesPageState();
}

class _MosquesPageState extends State<MosquesPage> {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("المساجد"),
          centerTitle: true,

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
                        icon: Center(
                          child: Icon(
                            Icons.grid_view_outlined,
                            size: 20,
                          ),
                        ),
                        value: ViewType.gridView),
                    ButtonSegment(
                        icon: Center(
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
                                            .onSecondaryContainer)),
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
                                            .secondaryContainer,
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
                      border: OutlineInputBorder(),
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
