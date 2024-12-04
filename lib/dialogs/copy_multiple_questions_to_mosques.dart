
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/pages/mosque_page.dart';
import 'package:masel/models/question_model.dart';

class CopyMultipleQuestionsToMosques extends StatefulWidget {
  const CopyMultipleQuestionsToMosques(
      {super.key, required this.mosqueName, required this.selectedQuestion});

  final String mosqueName;
  final List<Question> selectedQuestion;

  @override
  State<CopyMultipleQuestionsToMosques> createState() =>
      _CopyMultipleQuestionsToMosquesState();
}

class _CopyMultipleQuestionsToMosquesState
    extends State<CopyMultipleQuestionsToMosques> {
  List selectedMosques = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(Icons.mosque_outlined),
        title: const Text("نسخ المسائل إلى"),
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
                if (mosque.name != widget.mosqueName)
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
              Navigator.pop(context, PageMode.normal);
            },
            child: const Text("إلغاء"),
          ),
          FilledButton(
            onPressed: () {
              // add question to selected mosques
              for (var mosqueName in selectedMosques) {
                for (var question in widget.selectedQuestion) {
                  Box<Question> questionsBox = Hive.box<Question>('questions');
                  questionsBox.add(Question(
                      question.question,
                      question.description,
                      false,
                      mosqueName,
                      question.isParagraph, null));
                }
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم نسخ المسائل بنجاح"),
                ),
              );

              Navigator.pop(context, PageMode.normal);
            },
            child: const Text("نسخ"),
          ),
        ],
      ),
    );
  }
}
