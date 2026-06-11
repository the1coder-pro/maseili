import 'package:flutter/material.dart';
import 'package:m3e_buttons/m3e_buttons.dart';
import 'package:masel/models/question_model.dart';

Future<dynamic> deleteAQuestion(
    BuildContext context, List<Question> questions, int index) {
  final colorScheme = Theme.of(context).colorScheme;
  return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.delete_outline),
            iconColor: colorScheme.error,
            title: const Text("حذف المسألة"),
            content:
                Text("هل أنت متأكد من حذف '${questions[index].question}'؟"),
            actions: [
              M3EOutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("لا"),
              ),
              M3EFilledButton(
                onPressed: () {
                  questions[index].delete();

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم حذف المسألة بنجاح."),
                    ),
                  );
                },
                decoration: M3EButtonDecoration(
                  backgroundColor: WidgetStatePropertyAll(colorScheme.error),
                  foregroundColor: WidgetStatePropertyAll(colorScheme.onError),
                ),
                child: const Text("نعم"),
              ),
            ],
          ),
        );
      });
}

