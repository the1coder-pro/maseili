import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m3e_buttons/m3e_buttons.dart';
import 'package:m3e_card_list/m3e_card_list.dart';
import 'package:masel/dialogs/delete_mosque_dialog.dart';
import 'package:masel/dialogs/edit_mosque_dialog.dart';
import 'package:masel/main.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/pages/mosque_content_page.dart';

enum ViewType { gridView, listView }

class MosquesPage extends StatefulWidget {
  final bool isGridView;
  const MosquesPage({super.key, required this.isGridView});

  @override
  State<MosquesPage> createState() => _MosquesPageState();
}

class _MosquesPageState extends State<MosquesPage> {
  final TextEditingController controller = TextEditingController();
  Color selectedColor = Colors.blue;

  List<Color> getColorOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return [
        Colors.blue.shade300,
        Colors.red.shade300,
        Colors.green.shade300,
        Colors.amber.shade300,
        Colors.purple.shade300,
        Colors.orange.shade300,
        Colors.pink.shade300,
        Colors.teal.shade300,
        Colors.brown.shade300,
        Colors.grey.shade400,
      ];
    } else {
      return [
        Colors.blue.shade600,
        Colors.red.shade600,
        Colors.green.shade600,
        Colors.amber.shade600,
        Colors.purple.shade600,
        Colors.orange.shade600,
        Colors.pink.shade600,
        Colors.teal.shade600,
        Colors.brown.shade600,
        Colors.grey.shade600,
      ];
    }
  }

  void addMosque() {
    if (controller.text.isNotEmpty) {
      Box<Mosque> mosquesBox = Hive.box<Mosque>('mosques');
      mosquesBox.add(Mosque(controller.text, color: selectedColor.toHex));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: ValueListenableBuilder<Box<Mosque>>(
            valueListenable: Hive.box<Mosque>('mosques').listenable(),
            builder: (context, box, _) {
              var mosques = box.values.toList();

              if (mosques.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      M3EContainer.gem(
                        width: 130,
                        height: 130,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.mosque_outlined,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "لا توجد مساجد",
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
              return PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverse: !widget.isGridView,
                  transitionBuilder: (child, animation, secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: !widget.isGridView
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: M3ECardList.builder(
                            itemCount: mosques.length,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
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
                                        child: ListTile(
                                          leading: const Icon(
                                              Icons.edit_outlined,
                                              size: 20),
                                          title: const Text("تعديل"),
                                          contentPadding: EdgeInsets.zero,
                                          titleTextStyle: TextStyle(
                                            fontFamily: "Rubik",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 1,
                                        child: ListTile(
                                          leading: const Icon(
                                              Icons.delete_outline_rounded,
                                              size: 20),
                                          title: const Text("حذف"),
                                          contentPadding: EdgeInsets.zero,
                                          titleTextStyle: TextStyle(
                                            fontFamily: "Rubik",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).then((value) {
                                    if (context.mounted) {
                                      if (value == 0) {
                                        showEditMosqueDialog(context, index,
                                            mosques[index].name);
                                      } else if (value == 1) {
                                        // Delete mosque
                                        deleteMosque(context, mosques, index);
                                      }
                                    }
                                  });
                                },
                                child: ListTile(
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
                              );
                            },
                          ),
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
                                      child: ListTile(
                                        leading: const Icon(Icons.edit_outlined,
                                            size: 20),
                                        title: const Text("تعديل"),
                                        contentPadding: EdgeInsets.zero,
                                        titleTextStyle: TextStyle(
                                          fontFamily: "Rubik",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: ListTile(
                                        leading: const Icon(
                                            Icons.delete_outline_rounded,
                                            size: 20),
                                        title: const Text("حذف"),
                                        contentPadding: EdgeInsets.zero,
                                        titleTextStyle: TextStyle(
                                          fontFamily: "Rubik",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
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
                                  child: (() {
                                    final baseColor =
                                        mosques[index].color.toColor;
                                    Color folderColor;
                                    if (Theme.of(context).brightness ==
                                        Brightness.dark) {
                                      if (baseColor.value ==
                                          Colors.blue.shade600.value) {
                                        folderColor = Colors.blue.shade300;
                                      } else if (baseColor.value ==
                                          Colors.red.shade600.value) {
                                        folderColor = Colors.red.shade300;
                                      } else if (baseColor.value ==
                                          Colors.green.shade600.value) {
                                        folderColor = Colors.green.shade300;
                                      } else if (baseColor.value ==
                                          Colors.amber.shade600.value) {
                                        folderColor = Colors.amber.shade300;
                                      } else if (baseColor.value ==
                                          Colors.purple.shade600.value) {
                                        folderColor = Colors.purple.shade300;
                                      } else if (baseColor.value ==
                                          Colors.orange.shade600.value) {
                                        folderColor = Colors.orange.shade300;
                                      } else if (baseColor.value ==
                                          Colors.pink.shade600.value) {
                                        folderColor = Colors.pink.shade300;
                                      } else if (baseColor.value ==
                                          Colors.teal.shade600.value) {
                                        folderColor = Colors.teal.shade300;
                                      } else if (baseColor.value ==
                                          Colors.brown.shade600.value) {
                                        folderColor = Colors.brown.shade300;
                                      } else if (baseColor.value ==
                                          Colors.grey.shade600.value) {
                                        folderColor = Colors.grey.shade400;
                                      } else {
                                        folderColor = baseColor;
                                      }
                                    } else {
                                      if (baseColor.value ==
                                          Colors.blue.shade300.value) {
                                        folderColor = Colors.blue.shade600;
                                      } else if (baseColor.value ==
                                          Colors.red.shade300.value) {
                                        folderColor = Colors.red.shade600;
                                      } else if (baseColor.value ==
                                          Colors.green.shade300.value) {
                                        folderColor = Colors.green.shade600;
                                      } else if (baseColor.value ==
                                          Colors.amber.shade300.value) {
                                        folderColor = Colors.amber.shade600;
                                      } else if (baseColor.value ==
                                          Colors.purple.shade300.value) {
                                        folderColor = Colors.purple.shade600;
                                      } else if (baseColor.value ==
                                          Colors.orange.shade300.value) {
                                        folderColor = Colors.orange.shade600;
                                      } else if (baseColor.value ==
                                          Colors.pink.shade300.value) {
                                        folderColor = Colors.pink.shade600;
                                      } else if (baseColor.value ==
                                          Colors.teal.shade300.value) {
                                        folderColor = Colors.teal.shade600;
                                      } else if (baseColor.value ==
                                          Colors.brown.shade300.value) {
                                        folderColor = Colors.brown.shade600;
                                      } else if (baseColor.value ==
                                          Colors.grey.shade400.value) {
                                        folderColor = Colors.grey.shade600;
                                      } else {
                                        folderColor = baseColor;
                                      }
                                    }

                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder,
                                          size: 180,
                                          color: folderColor,
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
                                                  fontSize: 20,
                                                  color: folderColor
                                                              .computeLuminance() >
                                                          0.5
                                                      ? Colors.black87
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })(),
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
            final colorOptions = getColorOptions(context);
            selectedColor = colorOptions[0];

            showDialog(
              context: context,
              builder: (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: StatefulBuilder(
                  builder: (context, setStateDialog) {
                    final colorOptions = getColorOptions(context);
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      title: const Text(
                        "إضافة مسجد",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: "اسم المسجد",
                              hintText: "أدخل اسم المسجد",
                              prefixIcon: const Icon(Icons.mosque_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "لون المجلد",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: colorOptions.map((color) {
                              final isSelected = selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setStateDialog(() {
                                    selectedColor = color;
                                  });
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.grey.withValues(alpha: 0.3),
                                      width: isSelected ? 3 : 1,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: color.withValues(alpha: 0.4),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                    ],
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: color.computeLuminance() > 0.5
                                              ? Colors.black87
                                              : Colors.white,
                                          size: 18,
                                        )
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      actions: [
                        M3EOutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("إلغاء"),
                        ),
                        M3EFilledButton(
                          onPressed: addMosque,
                          child: const Text("إضافة"),
                        ),
                      ],
                    );
                  },
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
