import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m3e_buttons/m3e_buttons.dart';
import 'package:masel/main.dart';
import 'package:masel/models/tag_model.dart';

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

void createTagDialog(BuildContext context) {
  final TextEditingController tagController = TextEditingController();
  final initialColors = getColorOptions(context);
  Color selectedColor = initialColors[0];

  showDialog(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            final colorOptions = getColorOptions(context);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                "إضافة تصنيف",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: tagController,
                    decoration: InputDecoration(
                      labelText: "اسم التصنيف",
                      hintText: "أدخل اسم التصنيف",
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "لون التصنيف",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
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
            );
          },
        ),
      );
    },
  );
}
