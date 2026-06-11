import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/main.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "إضافة مسألة",
            style: TextStyle(fontFamily: "Rubik", fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(
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
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "تفاصيل المسألة",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Rubik",
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: questionController,
                            style: const TextStyle(fontFamily: "Rubik"),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.quiz_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
                              ),
                              labelText: "المسألة / السؤال",
                              labelStyle: const TextStyle(fontFamily: "Rubik"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: descriptionController,
                            minLines: 4,
                            maxLines: 7,
                            style: const TextStyle(fontFamily: "Rubik"),
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 80),
                                child: Icon(Icons.description_outlined),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
                              ),
                              labelText: "الوصف التفصيلي أو الجواب",
                              labelStyle: const TextStyle(fontFamily: "Rubik"),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
                    ),
                    child: SwitchListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        "هل هذه خطبة؟",
                        style: TextStyle(fontFamily: "Rubik", fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        "تفعيل هذا الخيار يحول المسألة إلى نص خطبة كامل",
                        style: TextStyle(fontFamily: "Rubik", fontSize: 12),
                      ),
                      secondary: Icon(Icons.menu_book_rounded, color: colorScheme.secondary),
                      value: isParagraph,
                      onChanged: (value) {
                        setState(() {
                          isParagraph = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (allTags.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "التصنيفات",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Rubik",
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allTags.map((tag) {
                        final isSelected = selectedTags.contains(tag.name);
                        return FilterChip(
                          label: Text(
                            tag.name,
                            style: TextStyle(
                              fontFamily: "Rubik",
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : colorScheme.onSurface,
                            ),
                          ),
                          backgroundColor: tag.color.toColor.withOpacity(0.15),
                          selectedColor: tag.color.toColor,
                          checkmarkColor: Colors.white,
                          selected: isSelected,
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                selectedTags.add(tag.name);
                              } else {
                                selectedTags.remove(tag.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
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

  // get the list of tags from the tags box
  Box<Tag> tagsBox = Hive.box<Tag>('tags');
  List<Tag> allTags = [];
  List<String> selectedTags = [];

  @override
  void initState() {
    questionController.text = widget.questions[widget.index].question;
    descriptionController.text =
        widget.questions[widget.index].description ?? "";
    isParagraph = widget.questions[widget.index].isParagraph ?? false;
    allTags = tagsBox.values.toList();
    selectedTags = List<String>.from(widget.questions[widget.index].tags ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "تعديل مسألة",
            style: TextStyle(fontFamily: "Rubik", fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(
                onPressed: () {
                  if (questionController.text.isNotEmpty) {
                    widget.questions[widget.index].question =
                        questionController.text;
                    widget.questions[widget.index].description =
                        descriptionController.text;
                    widget.questions[widget.index].isParagraph = isParagraph;
                    widget.questions[widget.index].tags = selectedTags;
                    widget.questions[widget.index].save();
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check),
              ),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "تفاصيل المسألة",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Rubik",
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: questionController,
                            style: const TextStyle(fontFamily: "Rubik"),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.quiz_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
                              ),
                              labelText: "المسألة / السؤال",
                              labelStyle: const TextStyle(fontFamily: "Rubik"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: descriptionController,
                            minLines: 4,
                            maxLines: 7,
                            style: const TextStyle(fontFamily: "Rubik"),
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 80),
                                child: Icon(Icons.description_outlined),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                      ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
                              ),
                              labelText: "الوصف التفصيلي أو الجواب",
                              labelStyle: const TextStyle(fontFamily: "Rubik"),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
                    ),
                    child: SwitchListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        "هل هذه خطبة؟",
                        style: TextStyle(fontFamily: "Rubik", fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        "تفعيل هذا الخيار يحول المسألة إلى نص خطبة كامل",
                        style: TextStyle(fontFamily: "Rubik", fontSize: 12),
                      ),
                      secondary: Icon(Icons.menu_book_rounded, color: colorScheme.secondary),
                      value: isParagraph,
                      onChanged: (value) {
                        setState(() {
                          isParagraph = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (allTags.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "التصنيفات",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Rubik",
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allTags.map((tag) {
                        final isSelected = selectedTags.contains(tag.name);
                        return FilterChip(
                          label: Text(
                            tag.name,
                            style: TextStyle(
                              fontFamily: "Rubik",
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : colorScheme.onSurface,
                            ),
                          ),
                          backgroundColor: tag.color.toColor.withOpacity(0.15),
                          selectedColor: tag.color.toColor,
                          checkmarkColor: Colors.white,
                          selected: isSelected,
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                selectedTags.add(tag.name);
                              } else {
                                selectedTags.remove(tag.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
