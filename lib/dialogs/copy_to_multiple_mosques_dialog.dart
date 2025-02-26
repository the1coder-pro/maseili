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
                    subtitle: // if the question is in the mosque already show a message
                        Hive.box<Question>('questions').values
                                .toList()
                                .where((element) =>
                                    element.mosqueName == mosque.name)
                                .toList()
                                .contains(widget.question)
                            ?  Text(
                                "المسألة موجودة في هذا المسجد",
                                style: TextStyle(
                                  fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
                              )
                            : null,
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
                      widget.question.isParagraph, null));
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تم نسخ المسألة إلى المساجد المختارة"),
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text("نسخ")),
        ],
      ),
    );
  }
}
