import 'package:flutter/material.dart';
import 'package:masel/models/question_model.dart';

Future<dynamic> deleteAQuestion(
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
            content:
                Text("هل أنت متأكد من حذف '${questions[index].question}'؟"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("لا"),
              ),
              FilledButton(
                onPressed: () {
                  questions[index].delete();

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم حذف المسألة بنجاح."),
                    ),
                  );
                },
                child: const Text("نعم"),
              ),
            ],
          ),
        );
      });
}
