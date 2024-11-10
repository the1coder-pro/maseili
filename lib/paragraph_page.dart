import 'package:flutter/material.dart';
import 'package:masel/main.dart';
import 'package:masel/question_model.dart';

class ParagraphPage extends StatefulWidget {
  const ParagraphPage({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<ParagraphPage> createState() => _ParagraphPageState();
}

class _ParagraphPageState extends State<ParagraphPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // edit and delete buttons
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ParagraphEditPage(question: widget.question);
                })).then((value) {
                  setState(() {});
                });
              },
            ),

            // delete button
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        icon: const Icon(Icons.delete_outline),
                        iconColor: Theme.of(context).colorScheme.error,
                        title: const Text("حذف الخطبة"),
                        content: const Text("هل أنت متأكد من حذف الخطبة؟"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("إلغاء"),
                          ),
                          FilledButton(
                            onPressed: () {
                              widget.question.delete();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("حذف"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 5),
              child: Text(widget.question.question,
                  style: const TextStyle(fontSize: 30)),
            ),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.question.description!),
              ),
            ),

            CheckboxListTile(
              value: widget.question.answered,
              title: const Text("تم شرحها"),
              onChanged: (value) {
                setState(() {
                  widget.question.answered = value!;
                  widget.question.save();
                });
              },
            ),

            // add a button to copy this paragraph to other mosques
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FilledButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => CopyToMultipleMosquesDialog(
                          question: widget.question));
                },
                child: const Text("نسخ"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ParagraphEditPage extends StatefulWidget {
  const ParagraphEditPage({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<ParagraphEditPage> createState() => _ParagraphEditPageState();
}

class _ParagraphEditPageState extends State<ParagraphEditPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    questionController.text = widget.question.question;
    descriptionController.text = widget.question.description ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("تعديل الخطبة"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    if (questionController.text.isNotEmpty) {
                      widget.question.question = questionController.text;
                      widget.question.description = descriptionController.text;
                      widget.question.save();
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.check))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    hintText: "الخطبة",
                  ),
                ),
              ),
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: descriptionController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "الوصف",
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
