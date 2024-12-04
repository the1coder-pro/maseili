
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
    final screenHeight = MediaQuery.of(context).size.height / 1.75;


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
            SizedBox(height: MediaQuery.of(context).size.height / 9),
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
                                      child: SizedBox(
                                        width: 200,
                                        child: AutoSizeText(question.question,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            minFontSize: 20,
                                            maxFontSize: 30,
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontFamily: "Scheherazade",
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: AutoSizeText(

                                            question.description!,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: question.description!.length < 300 ? screenHeight * 0.05 : screenHeight * 0.035,
                                                height: 1.6,
                                                color: Colors.white,
                                                fontFamily: "Scheherazade",
                                                letterSpacing: 0),
                                            // make the values below dynamic for the mediaQuery size
                                            minFontSize: question.description!.length < 100 ? screenHeight * 0.03 : screenHeight * 0.02,
                                            maxLines: (screenHeight / (question.description!.length < 100 ? screenHeight * 0.05 : screenHeight * 0.04)).floor(),
                                            stepGranularity: question.description!.length < 100 ? screenHeight * 0.03 : screenHeight * 0.02,
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]))
                      .toList()),
            ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // two buttons to forward and backward
                      if (questions.length > 1)

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
                      if (questions.length > 1)

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