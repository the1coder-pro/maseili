import 'package:flutter/material.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/models/question_model.dart';
import 'package:masel/components/helper_functions.dart';
import 'package:masel/components/question_view.dart';
import 'package:masel/pages/mosque_content_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  // Initial widths for columns: [المسألة, الوصف, المساجد, التصنيف]
  final List<double> widths = [150.0, 200.0, 250.0, 150.0];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "جدول المسائل",
            style: TextStyle(
              fontFamily: "Lateef",
              fontSize: 32,
            ),
          ),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Question>>(
          valueListenable: Hive.box<Question>('questions').listenable(),
          builder: (BuildContext context, box, _) {
            var allQuestions = box.values.toList();
            if (allQuestions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    M3EContainer.gem(
                      width: 130,
                      height: 130,
                      color: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 50,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "لا توجد مسائل",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            List<Map<String, dynamic>> groupedQuestions = groupQuestions(allQuestions);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card.outlined(
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FixedColumnWidth(widths[0]),
                        1: FixedColumnWidth(widths[1]),
                        2: FixedColumnWidth(widths[2]),
                        3: FixedColumnWidth(widths[3]),
                      },
                      border: TableBorder(
                        verticalInside: BorderSide(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                          width: 1,
                        ),
                        horizontalInside: BorderSide(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                          ),
                          children: [
                            _buildHeaderCell(context, 0, 'المسألة'),
                            _buildHeaderCell(context, 1, 'الوصف'),
                            _buildHeaderCell(context, 2, 'المساجد وحالة الشرح'),
                            _buildHeaderCell(context, 3, 'التصنيف'),
                          ],
                        ),
                        ...groupedQuestions.map((question) {
                          return TableRow(
                            children: [
                              TableRowInkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return QuestionView(
                                        index: allQuestions.indexWhere((element) =>
                                            element.question == question['question'] &&
                                            element.description == question['description']),
                                        carouselController: CarouselSliderController(),
                                        questions: allQuestions);
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Text(
                                    question['question'],
                                    style: TextStyle(
                                      fontFamily: "Rubik",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Text(
                                  question['description']?.isEmpty == true ? "لا يوجد وصف" : question['description'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Rubik",
                                    fontSize: 14,
                                    color: question['description']?.isEmpty == true 
                                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5) 
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: question['mosques'].map<Widget>((mosque) {
                                    final answered = mosque['answered'] == true;
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MosquePage(
                                                  mosqueName: mosque['mosqueName']),
                                            ),
                                          );
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: answered 
                                              ? Colors.green.withValues(alpha: 0.1) 
                                              : colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: answered 
                                                ? Colors.green.withValues(alpha: 0.3) 
                                                : colorScheme.outlineVariant.withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              mosque['mosqueName'],
                                              style: TextStyle(
                                                fontFamily: "Rubik",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: answered 
                                                    ? Colors.green.shade800 
                                                    : colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              answered ? Icons.check_circle_rounded : Icons.cancel_outlined,
                                              size: 14,
                                              color: answered ? Colors.green : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Text(
                                  (question['tags'] as String?) ?? "-",
                                  style: TextStyle(
                                    fontFamily: "Rubik",
                                    fontSize: 13,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, int index, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "Rubik",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              setState(() {
                // In RTL layout: dragging left (negative dx) increases the width
                widths[index] = (widths[index] - details.delta.dx).clamp(80.0, 500.0);
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  Icons.drag_handle_rounded,
                  size: 16,
                  color: colorScheme.onSecondaryContainer.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
