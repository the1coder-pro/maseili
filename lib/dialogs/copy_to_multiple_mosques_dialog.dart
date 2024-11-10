import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/models/question_model.dart';

class CopyToMultipleMosquesDialog extends StatefulWidget {
  const CopyToMultipleMosquesDialog({super.key, required this.question});

  final Question question;

  @override
  State<CopyToMultipleMosquesDialog> createState() =>
      _CopyToMultipleMosquesDialogState();
}

class _CopyToMultipleMosquesDialogState
    extends State<CopyToMultipleMosquesDialog> {
  List selectedMosques = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(Icons.mosque_outlined),
        title: widget.question.isParagraph == true
            ? const Text("نسخ الخطبة إلى")
            : const Text("نسخ المسألة الى"),
        content: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 300,
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var mosque in Hive.box<Mosque>('mosques').values.toList())
                if (mosque.name != widget.question.mosqueName)
                  CheckboxListTile(
                    title: Text(
                      mosque.name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 18),
                    ),
                    value: selectedMosques.contains(mosque.name),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedMosques.add(mosque.name);
                        } else {
                          selectedMosques.remove(mosque.name);
                        }
                      });
                    },
                  ),
            ],
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
                // add question to selected mosques
                for (var mosqueName in selectedMosques) {
                  Box<Question> questionsBox = Hive.box<Question>('questions');
                  questionsBox.add(Question(
                      widget.question.question,
                      widget.question.description,
                      false,
                      mosqueName,
                      widget.question.isParagraph));
                }

                Navigator.pop(context);
              },
              child: const Text("نسخ")),
        ],
      ),
    );
  }
}
