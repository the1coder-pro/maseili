import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/main.dart';
import 'package:masel/models/tag_model.dart';

void createTagDialog(BuildContext context) {
  final TextEditingController tagController = TextEditingController();
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

  showDialog(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text("إضافة تصنيف"),
          content: Column(
            children: [
              TextField(
                controller: tagController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "اسم التصنيف"),
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
                    selectedColor = newSelection.first;
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
            TextButton(
              onPressed: () {
                if (tagController.text.isNotEmpty) {
                  Hive.box<Tag>('tags').add(
                    Tag(tagController.text, color: selectedColor.toHex),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("إضافة"),
            ),
          ],
        ),
      );
    },
  );
}
