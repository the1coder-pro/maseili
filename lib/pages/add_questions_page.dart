import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/question_model.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key, this.mosqueName});

  final String? mosqueName;

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isParagraph = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة مسألة"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (questionController.text.isNotEmpty) {
                  Box<Question> questionsBox = Hive.box<Question>('questions');
                  questionsBox.add(Question(
                      questionController.text,
                      descriptionController.text,
                      false,
                      widget.mosqueName ?? "",
                      isParagraph));
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
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
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "الوصف",
                ),
              ),
              const SizedBox(height: 5),
              CheckboxListTile(
                  title: const Text(
                    "هل هذه خطبة؟",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18),
                  ),
                  value: isParagraph,
                  onChanged: (value) {
                    setState(() {
                      isParagraph = value!;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class EditQuestionPage extends StatefulWidget {
  const EditQuestionPage(this.context, this.questions, this.index, {super.key});

  final BuildContext context;
  final List<Question> questions;
  final int index;

  @override
  State<EditQuestionPage> createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isParagraph = false;

  @override
  void initState() {
    questionController.text = widget.questions[widget.index].question;
    descriptionController.text =
        widget.questions[widget.index].description ?? "";
    isParagraph = widget.questions[widget.index].isParagraph!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تعديل مسألة"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (questionController.text.isNotEmpty) {
                  widget.questions[widget.index].question =
                      questionController.text;
                  widget.questions[widget.index].description =
                      descriptionController.text;
                  widget.questions[widget.index].isParagraph = isParagraph;
                  widget.questions[widget.index].save();
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
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
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "الوصف",
                ),
              ),
              const SizedBox(height: 5),
              CheckboxListTile(
                  title: const Text(
                    "هل هذه خطبة؟",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18),
                  ),
                  value: isParagraph,
                  onChanged: (value) {
                    setState(() {
                      isParagraph = value!;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

