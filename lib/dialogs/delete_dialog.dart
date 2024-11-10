
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
                    Box<Question> questionsBox =
                        Hive.box<Question>('questions');
                    questionsBox.deleteAt(index);
                    Navigator.pop(context);
                  },
                  child: const Text("نعم"),
                ),
              ],
            ),
          );
        });
  }