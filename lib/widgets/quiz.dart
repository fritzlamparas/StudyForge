import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyforge/models/quiz_display.dart';

class SecondPage extends StatefulWidget {
  final String topicId;

  const SecondPage({Key? key, required this.topicId}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Object> _questionsList = [];
  int correctAnswers = 0;
  int totalQuestions = 0;
  int answeredQuestions = 0;
  bool isLoading = false;

  // Add a map to store the selected options for each question
  Map<int, int> selectedOptions = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getQuestionsList();
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
          title: const Text(
            "Result",
            style: TextStyle(
              color: Color.fromRGBO(0, 51, 102, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score: $correctAnswers/$totalQuestions',
                style: const TextStyle(
                  color: Color.fromRGBO(0, 51, 102, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Do you want to take the quiz again?",
                style: TextStyle(
                  color: Color.fromRGBO(0, 51, 102, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text(
                "Home",
                style: TextStyle(color: Color.fromRGBO(0, 51, 102, 1.0)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Review",
                style: TextStyle(color: Color.fromRGBO(0, 51, 102, 1.0)),
              ),
            ),
            TextButton(
              onPressed: () {
                _resetQuiz();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Retake",
                style: TextStyle(color: Color.fromRGBO(0, 51, 102, 1.0)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String htopic = widget.topicId;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromRGBO(0, 51, 102, 1.0)),
        centerTitle: true,
        title: Text(
          "Quiz: $htopic",
          style: const TextStyle(
              color: Color.fromRGBO(0, 51, 102, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'RobotoBold'),
        ),
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
        shadowColor: const Color.fromRGBO(0, 51, 102, 1.0),
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(0, 51, 102, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _questionsList.length,
                    itemBuilder: (context, index) {
                      return QuizCard(
                        _questionsList[index] as Question,
                        selectedOptionIndex: selectedOptions[index],
                        onAnswerSubmitted: (isCorrect, selectedIndex) {
                          if (isCorrect) {
                            setState(() {
                              correctAnswers++;
                            });
                          }
                          setState(() {
                            answeredQuestions++;
                            selectedOptions[index] = selectedIndex;
                          });
                          if (answeredQuestions == totalQuestions) {
                            _showResetConfirmationDialog();
                          }
                        },
                      );
                    },
                    padding: const EdgeInsets.only(top: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showResetConfirmationDialog();
        },
        backgroundColor: const Color.fromRGBO(0, 51, 102, 1.0),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Color.fromRGBO(248, 248, 248, 1.0),
              )
            : const Icon(
                Icons.more_horiz,
                color: Color.fromRGBO(248, 248, 248, 1.0),
              ),
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        correctAnswers = 0;
        totalQuestions = 0;
        answeredQuestions = 0;
        _questionsList.clear();
        selectedOptions.clear(); // Clear selected options
        getQuestionsList();
        isLoading = false;
      });
    });
  }

  Future<void> getQuestionsList() async {
    var data =
        await FirebaseFirestore.instance.collection(widget.topicId).get();
    setState(() {
      _questionsList =
          data.docs.map((doc) => Question.fromSnapshot(doc)).toList();
      totalQuestions = _questionsList.length;

      _questionsList.shuffle();

      _questionsList.forEach((question) {
        (question as Question).options?.shuffle();
      });
    });
  }
}

class QuizCard extends StatefulWidget {
  final Question _question;
  final int? selectedOptionIndex; // Add selectedOptionIndex
  final Function(bool, int) onAnswerSubmitted;

  const QuizCard(this._question,
      {Key? key, required this.onAnswerSubmitted, this.selectedOptionIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  int selectedOptionIndex = -1;
  bool isCorrect = false;
  bool answerSubmitted = false;
  List<bool> optionSelectedList = [];
  bool showCorrectAnswer = false;

  @override
  void initState() {
    super.initState();
    optionSelectedList = List.filled(widget._question.options!.length, false);
    if (widget.selectedOptionIndex != null) {
      selectedOptionIndex = widget.selectedOptionIndex!;
      answerSubmitted = true;
      optionSelectedList[selectedOptionIndex] = true;
      isCorrect = widget._question.options![selectedOptionIndex] ==
          widget._question.ans;
      // Only show the correct answer if the answer was incorrect
      showCorrectAnswer = !isCorrect && widget._question.correctAnswerShown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(248, 248, 248, 1.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              widget._question.question ?? "",
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 51, 102, 1.0),
                  fontFamily: 'RobotoBold'),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children:
                  List.generate(widget._question.options?.length ?? 0, (index) {
                final option = widget._question.options![index];
                return Row(
                  children: [
                    if (answerSubmitted && selectedOptionIndex == index)
                      Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: isCorrect
                            ? const Color.fromRGBO(0, 51, 102, 1.0)
                            : const Color.fromRGBO(0, 51, 102, 1.0),
                      ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: answerSubmitted
                            ? () {}
                            : () {
                                if (!answerSubmitted) {
                                  bool userAnswerIsCorrect =
                                      option == widget._question.ans;
                                  handleOptionSelection(
                                      userAnswerIsCorrect, index);
                                  widget.onAnswerSubmitted(
                                      userAnswerIsCorrect, index);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: optionSelectedList[index]
                              ? isCorrect
                                  ? const Color.fromRGBO(248, 248, 248, 1.0)
                                  : const Color.fromRGBO(248, 248, 248, 1.0)
                              : const Color.fromRGBO(0, 51, 102, 1.0),
                        ),
                        child: Text(
                          option,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'RobotoMedium',
                            color: optionSelectedList[index]
                                ? const Color.fromRGBO(0, 51, 102, 1.0)
                                : const Color.fromRGBO(248, 248, 248, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            if (showCorrectAnswer && answerSubmitted)
              Text(
                'Correct Answer: ${widget._question.ans}',
                style: const TextStyle(
                  color: Color.fromRGBO(0, 51, 102, 1.0),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMedium',
                ),
              ),
          ],
        ),
      ),
    );
  }

  void handleOptionSelection(bool userAnswerIsCorrect, int index) {
    setState(() {
      isCorrect = userAnswerIsCorrect;
      answerSubmitted = true;
      selectedOptionIndex = index;
      optionSelectedList[index] = true;
      // Only show the correct answer if the user selected an incorrect answer.
      showCorrectAnswer = !userAnswerIsCorrect;
      widget._question.correctAnswerShown = !userAnswerIsCorrect;
    });

    if (!userAnswerIsCorrect) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showCorrectAnswer = true;
        });
      });
    }
  }
}
