
import 'package:flutter/material.dart';
import 'package:masel/models/question_model.dart';

Future<dynamic> editDialog(
    BuildContext context, List<Question> questions, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      final TextEditingController questionController = TextEditingController();
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
                  border: OutlineInputBorder(),
                  hintText: "المسألة",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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