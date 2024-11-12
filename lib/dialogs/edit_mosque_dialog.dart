import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/mosque_model.dart';

import '../models/question_model.dart';

void editMosque(int index, String newName, BuildContext context) {
  if (newName.isNotEmpty) {
    Box<Mosque> mosquesBox = Hive.box<Mosque>('mosques');

    // get the questions with the same mosqueName of the mosque to be edited
    String mosqueName = mosquesBox.getAt(index)!.name;
    Box<Question> questionsBox = Hive.box<Question>('questions');
    List<Question> questions = questionsBox.values.where((element) => element.mosqueName == mosqueName).toList();

    // update the mosqueName of the questions
    for (Question question in questions) {
      question.mosqueName = newName;
      question.save();
    }


    Mosque? mosque = mosquesBox.getAt(index);
    mosque!.name = newName;
    mosque.save();

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
              Navigator.pop(context);

            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    ),
  );
}
