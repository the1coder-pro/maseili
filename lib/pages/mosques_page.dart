import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/dialogs/delete_mosque_dialog.dart';
import 'package:masel/dialogs/edit_mosque_dialog.dart';
import 'package:masel/main.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/pages/mosque_content_page.dart';

enum ViewType { gridView, listView }

class MosquesPage extends StatefulWidget {
  const MosquesPage({super.key});

  @override
  State<MosquesPage> createState() => _MosquesPageState();
}

class _MosquesPageState extends State<MosquesPage> {
  final TextEditingController controller = TextEditingController();
  Color selectedColor = Colors.blue;
  final List<Color> colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.grey,
  ];

  void addMosque() {
    if (controller.text.isNotEmpty) {
      Box<Mosque> mosquesBox = Hive.box<Mosque>('mosques');
      mosquesBox.add(Mosque(controller.text, color: selectedColor.toHex));
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
                  onSelectionChanged: (Set<ViewType> value) async {
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
                return const Text("لا توجد مساجد",
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
                                  if (context.mounted) {
                                    if (value == 0) {
                                      showEditMosqueDialog(
                                          context, index, mosques[index].name);
                                    } else if (value == 1) {
                                      // Delete mosque
                                      deleteMosque(context, mosques, index);
                                    }
                                  }
                                });
                              },
                              child: Card(
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
                                ),
                              ),
                            );
                          },
                        )
                      : GridView.builder(
                          itemCount: mosques.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
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
                                  if (context.mounted) {
                                    if (value == 0) {
                                      showEditMosqueDialog(
                                          context, index, mosques[index].name);
                                    } else if (value == 1) {
                                      // Delete mosque
                                      deleteMosque(context, mosques, index);
                                    }
                                  }
                                });
                              },
                              child: Card(
                                color: Theme.of(context).colorScheme.surface,
                                elevation: 0,
                                child: GestureDetector(
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
                                          color: mosques[index].color.toColor,
                                          // color: Theme.of(context)
                                          //     .colorScheme
                                          //     .secondaryContainer,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: SizedBox(
                                            width: 130,
                                            height: 100,
                                            child: Center(
                                              child: Text(
                                                mosques[index].name,
                                                maxLines: 2,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  letterSpacing: 0,
                                                  // overflow: TextOverflow.fade,
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                  content: Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "اسم المسجد",
                        ),
                      ),
                      const SizedBox(height: 16),
                      // SegmentedButton for color selection
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SegmentedButton<Color>(
                          segments: colorOptions
                              .map((color) => ButtonSegment<Color>(
                                    value: color,
                                    label: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: selectedColor == color ? 2 : 1,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          selected: {selectedColor},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              selectedColor = newSelection.first;
                            });
                          },
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
}
