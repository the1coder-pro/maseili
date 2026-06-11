import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m3e_buttons/m3e_buttons.dart';
import 'package:masel/pages/add_questions_page.dart';
import 'package:masel/components/helper_functions.dart';
import 'package:masel/pages/mosque_content_page.dart';
import 'package:masel/models/question_model.dart';

class AddingQuestionsDialog extends StatefulWidget {
  const AddingQuestionsDialog({
    super.key,
    required this.widget,
  });

  final MosquePage widget;

  @override
  State<AddingQuestionsDialog> createState() => _AddingQuestionsDialogState();
}

class _AddingQuestionsDialogState extends State<AddingQuestionsDialog> {
  Question? selectedQuestion;

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: enabled 
                ? colorScheme.outlineVariant.withOpacity(0.5) 
                : colorScheme.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
        color: enabled 
            ? colorScheme.surfaceContainerLow
            : colorScheme.surface.withOpacity(0.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: enabled 
                        ? colorScheme.primaryContainer.withOpacity(0.4) 
                        : colorScheme.onSurface.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: enabled ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rubik",
                    color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Rubik",
                    color: enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionsBox = Hive.box<Question>('questions');
    final colorScheme = Theme.of(context).colorScheme;
    bool uniqueQuestionsBoxIsEmpty =
        filterUniqueQuestions(questionsBox.values.toList()).where((question) {
      return Hive.box<Question>('questions')
              .values
              .toList()
              .reversed
              .toList()
              .where(
                  (element) => element.mosqueName == widget.widget.mosqueName)
              .map((e) => e.question)
              .contains(question.question) ==
          false;
    }).isEmpty;
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "إضافة مسألة جديدة للمسجد",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    fontFamily: "Rubik",
                    color: colorScheme.onSurface,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(width: 48), // Spacer to balance close button
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildOptionCard(
                  context: context,
                  icon: Icons.move_to_inbox_rounded,
                  title: "إستيراد مسألة",
                  subtitle: uniqueQuestionsBoxIsEmpty ? "لا توجد مسائل" : "من المساجد الأخرى",
                  onTap: uniqueQuestionsBoxIsEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          var questionsList =
                              Hive.box<Question>('questions')
                                  .values
                                  .toList()
                                  .reversed
                                  .toList();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    title: const Text(
                                      "إستيراد مسألة",
                                      style: TextStyle(fontFamily: "Rubik", fontWeight: FontWeight.bold),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "اختر المسألة التي ترغب في استيرادها:",
                                          style: TextStyle(fontFamily: "Rubik", fontSize: 14),
                                        ),
                                        const SizedBox(height: 12),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text("اختر مسألة", style: TextStyle(fontFamily: "Rubik")),
                                          onChanged: (value) {
                                            Question question =
                                                value as Question;
                                            selectedQuestion = Question(
                                                question.question,
                                                question.description,
                                                false,
                                                widget
                                                    .widget.mosqueName,
                                                question.isParagraph,
                                                null);
                                          },
                                          items: filterUniqueQuestions(
                                                  questionsList)
                                              .where((question) {
                                            return questionsList
                                                    .where((element) =>
                                                        element
                                                            .mosqueName ==
                                                        widget.widget
                                                            .mosqueName)
                                                    .map((e) =>
                                                        e.question)
                                                    .contains(question
                                                        .question) ==
                                                false;
                                          }).map((question) {
                                            return DropdownMenuItem(
                                              value: question,
                                              child: Text(
                                                question.question,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "Rubik"),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      M3EOutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("إلغاء", style: TextStyle(fontFamily: "Rubik")),
                                      ),
                                      M3EFilledButton(
                                        onPressed: () {
                                          if (selectedQuestion != null) {
                                            questionsBox.add(selectedQuestion!);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    duration:
                                                        Duration(
                                                            seconds: 2),
                                                    content: Text(
                                                        "تم إضافة المسألة",
                                                        style: TextStyle(fontFamily: "Rubik"))));
                                          }
                                        },
                                        child: const Text("إضافة", style: TextStyle(fontFamily: "Rubik")),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                ),
                const SizedBox(width: 16),
                _buildOptionCard(
                  context: context,
                  icon: Icons.add_circle_outline_rounded,
                  title: "إضافة مسألة",
                  subtitle: "كتابة مسألة جديدة",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddQuestionPage(
                        mosqueName: widget.widget.mosqueName,
                      );
                    }));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
