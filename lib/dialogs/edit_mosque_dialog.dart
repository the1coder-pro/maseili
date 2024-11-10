import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/mosque_model.dart';

void editMosque(int index, String newName, BuildContext context) {
  if (newName.isNotEmpty) {
    Box<Mosque> mosquesBox = Hive.box<Mosque>('mosques');
    Mosque? mosque = mosquesBox.getAt(index);
    mosque!.name = newName;
    mosque.save();
    Navigator.pop(context);
  }
}

void showEditMosqueDialog(BuildContext context, int index, String currentName) {
  TextEditingController controller = TextEditingController(text: currentName);
  showDialog(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text("تعديل اسم مسجد"),
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
            onPressed: () {
              editMosque(index, controller.text, context);
              Navigator.of(context).pop();
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    ),
  );
}
