
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:masel/models/question_model.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.carouselController,
    required this.questions,
    required this.index,
  });

  final CarouselSliderController carouselController;
  final List<Question> questions;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_new.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 8),
            Expanded(
              child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    initialPage: index,
                    enableInfiniteScroll: false,
                    height: MediaQuery.of(context).size.height,
                  ),
                  carouselController: carouselController,
                  items: questions
                      .map((question) => Column(children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height /8),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Center(
                                      child: Text(question.question,
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontFamily: "Scheherazade",
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0,
                                              fontSize: 20)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(

                                          question.description!,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              fontSize: 30,
                                              height: 1.2,
                                              color: Colors.white,
                                              fontFamily: "Scheherazade",
                                              letterSpacing: 0),
                                          minFontSize: 18,
                                          stepGranularity: 18,
                                          maxLines: 18,

                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]))
                      .toList()),
            ),
            if (questions.length > 1)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // two buttons to forward and backward
                      IconButton.outlined(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withOpacity(0.5))),
                        iconSize: 30,
                        icon: Icon(Icons.arrow_back,
                            color:
                                Theme.of(context).colorScheme.secondaryContainer),
                        onPressed: () {
                          carouselController.previousPage();
                        },
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withOpacity(0.5))),
                        child:Icon(Icons.close,
                            color:
                            Theme.of(context).colorScheme.secondaryContainer),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),

                      IconButton.outlined(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withOpacity(0.5))),
                        iconSize: 30,
                        icon: Icon(Icons.arrow_forward,
                            color:
                            Theme.of(context).colorScheme.secondaryContainer),
                        onPressed: () {
                          carouselController.nextPage();
                        },
                      ),
                    ]),
              ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}