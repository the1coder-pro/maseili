import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/question_model.dart';
import 'package:masel/models/tag_model.dart';

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

  // get the list of tags from the tags box
  Box<Tag> tagsBox = Hive.box<Tag>('tags');
  List<Tag> allTags = [];
  List<String> selectedTags = [];

  @override
  void initState() {
    allTags = tagsBox.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get all tags from the tags box

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
                  var question = Question(
                      questionController.text,
                      descriptionController.text,
                      false,
                      widget.mosqueName ?? "",
                      isParagraph,
                      null);
                  question.tags = selectedTags;
                  questionsBox.add(question);

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
                minLines: 4,
                maxLines: 7,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "الوصف",
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                  title: const Text(
                    "هل هذه خطبة؟",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18),
                  ),
                  value: isParagraph,
                  onChanged: (value) {
                    setState(() {
                      isParagraph = value;
                    });
                  }),

              // show a list of chips to select from as tags
              Wrap(
                children: allTags
                    .map((tag) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: ChoiceChip(
                            label: Text(tag.name),
                            selected: selectedTags.contains(tag.name),
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  selectedTags.add(tag.name);
                                } else {
                                  selectedTags.remove(tag.name);
                                }
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
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
